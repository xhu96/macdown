#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-run}"
APP_NAME="MacDown"
WORKSPACE="MacDown.xcworkspace"
SCHEME="MacDown"
CONFIGURATION="${CONFIGURATION:-Debug}"
DERIVED_DATA="${DERIVED_DATA:-build/DerivedData}"
DESTINATION_ARCH="${DESTINATION_ARCH:-$(uname -m)}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ "$DERIVED_DATA" = /* ]]; then
  DERIVED_DATA_PATH="$DERIVED_DATA"
else
  DERIVED_DATA_PATH="$ROOT_DIR/$DERIVED_DATA"
fi
APP_BUNDLE="$DERIVED_DATA_PATH/Build/Products/$CONFIGURATION/$APP_NAME.app"

usage() {
  echo "usage: $0 [run|--verify|--logs|--telemetry]" >&2
}

require_full_xcode() {
  if ! command -v xcodebuild >/dev/null 2>&1; then
    echo "error: xcodebuild was not found. Install full Xcode and select it with xcode-select." >&2
    exit 1
  fi

  local developer_dir
  developer_dir="${DEVELOPER_DIR:-$(xcode-select -p 2>/dev/null || true)}"
  if [[ "$developer_dir" == *"/CommandLineTools" ]]; then
    echo "error: Command Line Tools are selected, but MacDown needs full Xcode." >&2
    echo "Select Xcode with: sudo xcode-select -s /Applications/Xcode.app/Contents/Developer" >&2
    echo "Or run with: DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer $0" >&2
    exit 1
  fi

  if [[ ! -d "$developer_dir/Platforms/MacOSX.platform" ]]; then
    echo "error: developer directory is not a full macOS Xcode install: $developer_dir" >&2
    exit 1
  fi

  if ! xcodebuild -version >/dev/null 2>&1; then
    echo "error: xcodebuild is not usable. Install/select full Xcode before building." >&2
    exit 1
  fi
}

require_pods() {
  if [[ ! -d "$ROOT_DIR/Pods" || ! -f "$ROOT_DIR/Pods/Manifest.lock" ]]; then
    echo "error: CocoaPods dependencies are missing." >&2
    echo "Run: bundle install" >&2
    echo "Then: bundle exec ruby -e 'require \"logger\"; load Gem.bin_path(\"cocoapods\", \"pod\")' install" >&2
    exit 1
  fi
}

build_app() {
  require_full_xcode
  require_pods
  cd "$ROOT_DIR"
  xcodebuild \
    -workspace "$WORKSPACE" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -destination "platform=macOS,arch=$DESTINATION_ARCH" \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    build

  if [[ ! -d "$APP_BUNDLE" ]]; then
    echo "error: expected app bundle was not produced: $APP_BUNDLE" >&2
    exit 1
  fi
}

stop_running_app() {
  osascript -e "tell application \"$APP_NAME\" to quit" >/dev/null 2>&1 || true
  pkill -x "$APP_NAME" >/dev/null 2>&1 || true
}

launch_app() {
  if [[ "$#" -gt 0 ]]; then
    /usr/bin/open -n -a "$APP_BUNDLE" "$@"
  else
    /usr/bin/open -n "$APP_BUNDLE"
  fi
}

verify_launch() {
  for _ in {1..20}; do
    if pgrep -x "$APP_NAME" >/dev/null 2>&1; then
      echo "$APP_NAME launched from $APP_BUNDLE"
      return 0
    fi
    sleep 0.5
  done

  echo "error: $APP_NAME did not appear as a running process after launch." >&2
  return 1
}

case "$MODE" in
  run)
    ;;
  --verify|verify|--logs|logs|--telemetry|telemetry)
    ;;
  *)
    usage
    exit 2
    ;;
esac

build_app
stop_running_app

case "$MODE" in
  run)
    launch_app
    ;;
  --verify|verify)
    VERIFY_FILE="$(mktemp "${TMPDIR:-/tmp/}macdown-verify.XXXXXX")"
    printf "# MacDown launch verification\n" > "$VERIFY_FILE"
    launch_app "$VERIFY_FILE"
    verify_launch
    ;;
  --logs|logs)
    launch_app
    /usr/bin/log stream --info --style compact --predicate "process == \"$APP_NAME\""
    ;;
  --telemetry|telemetry)
    launch_app
    /usr/bin/log stream --info --style compact --predicate "process == \"$APP_NAME\""
    ;;
esac
