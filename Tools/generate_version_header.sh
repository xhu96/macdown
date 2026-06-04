#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/utils.sh"

SHORT_VERSION=$(get_short_version)
BUNDLE_VERSION=$(get_bundle_version)

printf "#ifndef VERSION_H
#define VERSION_H

static const char * const kMPApplicationShortVersion = \"$SHORT_VERSION\";
static const char * const kMPApplicationBundleVersion = \"$BUNDLE_VERSION\";

#endif
" > version.h
