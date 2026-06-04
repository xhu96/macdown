# MacDown

MacDown is an open source Markdown editor for macOS, released under the MIT
License. The author stole the idea from
[Chen Luo](https://twitter.com/chenluois)’s [Mou](http://mouapp.com) so that
people can make crappy clones.

This fork keeps the original MacDown app identity while modernizing the source
for universal macOS 11+ builds on Apple Silicon and Intel Macs. The original
project is [MacDownApp/macdown](https://github.com/MacDownApp/macdown). This
modernization fork was prepared by [Xhulio L.](https://github.com/xhu96).

Visit the historical [project site](http://macdown.uranusjr.com/) for original
MacDown information.

## What Changed in This Fork

This fork modernizes MacDown so it can be built and used on current macOS
systems while preserving the original app identity.

Key changes:

* Universal macOS 11+ project settings for Apple Silicon and Intel Macs.
* Updated Xcode build configuration for modern macOS SDKs.
* Sparkle 2 integration through Swift Package Manager.
* Restored `Check for Updates...` flow, disabled until a real appcast URL and
  public key are configured.
* Developer ID-ready Release settings with hardened runtime guidance.
* Removed legacy architecture/deployment settings such as old Intel-only
  assumptions.
* Added `script/build_and_run.sh` for local build, launch, verification, and
  logs.
* Updated documentation for source-first distribution instead of unsupported
  old binaries.
* Added Albanian (`sq`) localization.
* Added modernization credits for Xhulio L.

This is a source modernization fork. It does not currently ship signed/notarized
binaries, a public Sparkle appcast, or an active support channel.

## Install

This fork currently publishes source changes, not fork-owned notarized binary
releases. To try the Apple Silicon/macOS modernization, build the app locally
from `MacDown.xcworkspace` or use the helper script in the
[Build and Run](#build-and-run) section.

Historical upstream binaries and the Homebrew Cask may still be available from
the original project, but they are not produced by this fork and may not include
the Apple Silicon/macOS 11+ modernization. For reference, the historical cask
command is:

    brew install --cask macdown

## Screenshot

![screenshot](assets/screenshot.png)

## License

MacDown is released under the terms of MIT License. You may find the content of the license [here](http://opensource.org/licenses/MIT), or inside the `LICENSE` directory.

You may find full text of licenses about third-party components in the `LICENSE` directory, or the **About MacDown** panel in the application.

The following editor themes and CSS files are extracted from [Mou](http://mouapp.com), courtesy of Chen Luo:

* Mou Fresh Air
* Mou Fresh Air+
* Mou Night
* Mou Night+
* Mou Paper
* Mou Paper+
* Tomorrow
* Tomorrow Blue
* Tomorrow+
* Writer
* Writer+
* Clearness
* Clearness Dark
* GitHub
* GitHub2

## Development

### Requirements

If you wish to build MacDown yourself, you will need the following components/tools:

* Full Xcode with the macOS 11.0 SDK or later
* Git
* [Bundler](http://bundler.io)

> Note: Old versions of CocoaPods are not supported. Please use Bundler to execute CocoaPods, or make sure your CocoaPods is later than shown in `Gemfile.lock`.

An appropriate SDK is bundled with recent versions of Xcode. Command Line Tools
alone are not enough to build the Xcode workspace.

The project deployment target is macOS 11.0. Release builds are intended to be
universal Apple Silicon and Intel builds when `ONLY_ACTIVE_ARCH=NO` is used.

### Environment Setup

After cloning the repository, run the following commands inside the repository root (directory containing this `README.md` file):

    git submodule update --init
    bundle install
    bundle exec pod install
    make -C Dependency/peg-markdown-highlight

and open `MacDown.xcworkspace` in Xcode. The first command initialises the
dependency submodule(s) used in MacDown; Bundler and CocoaPods install the Ruby
and Cocoa dependencies.

Sparkle 2 is resolved by Xcode through Swift Package Manager from
`https://github.com/sparkle-project/Sparkle`. CocoaPods continues to manage the
Objective-C dependencies already used by MacDown.

For release-quality builds, install the optional Node dependencies used by the
GitHub stylesheet generator:

    (cd Tools/GitHub-style-generator && npm install)

The Xcode `Transpile Styles` phase uses that generator. If these Node
dependencies are missing, Xcode may print a `node-sass` warning and leave the
generated `GitHub-2020.css` stylesheet empty while the app build continues.

If Apple's system Ruby fails to start CocoaPods with an ActiveSupport `Logger`
error, run the CocoaPods step with:

    bundle exec ruby -e 'require "logger"; load Gem.bin_path("cocoapods", "pod")' install

Refer to the official guides of Git and CocoaPods if you need more instructions. If you run into build issues later on, try running the following commands to update dependencies:

    git submodule update
    bundle exec pod install

### Build and Run

Use the project-local runner for the normal edit/build/run loop:

    ./script/build_and_run.sh

It builds `MacDown.xcworkspace` with the `MacDown` scheme, quits any running
MacDown instance, and launches the freshly built app. Additional modes:

    ./script/build_and_run.sh --verify
    ./script/build_and_run.sh --logs

The script requires full Xcode, not only Command Line Tools, and prints the
CocoaPods install command if the `Pods` directory is missing.

### Updates and Signing

MacDown uses Sparkle 2's `SPUStandardUpdaterController`. `Check for Updates...`
is present in the app menu, but Sparkle is not started and the menu item remains
disabled unless both a feed URL and EdDSA public key are supplied.

This fork does not ship a public appcast URL or Sparkle key by default.

Set these build settings in an `.xcconfig`, in Xcode, or on the `xcodebuild`
command line for release builds:

    MACDOWN_SPARKLE_FEED_URL=https://example.com/appcast.xml
    MACDOWN_SPARKLE_BETA_FEED_URL=https://example.com/beta-appcast.xml
    MACDOWN_SPARKLE_PUBLIC_ED_KEY=<sparkle-ed25519-public-key>

The beta feed is optional and is used only when the existing prerelease update
preference is enabled.

Release builds enable the hardened runtime for Developer ID distribution. The
project does not hard-code signing credentials or sandbox entitlements. Provide
distribution signing values from your local environment or CI:

    DEVELOPMENT_TEAM=<team-id>
    CODE_SIGN_IDENTITY="Developer ID Application"

After a signed archive is exported, validate the result with:

    codesign -dvvv --entitlements :- MacDown.app
    lipo -archs MacDown.app/Contents/MacOS/MacDown
    spctl -a -vv MacDown.app

### Translation

Existing translations are retained from the original MacDown project. This fork
also adds Albanian (`sq`). It does not currently manage a separate translation
workflow or progress badge.

## Discussion

This repository is a source modernization fork, not an active support channel.
Bug reports and pull requests may be reviewed on a best-effort basis, but there
is no guarantee of ongoing maintenance or user support.

For original upstream history and older project discussion, see
[MacDownApp/macdown](https://github.com/MacDownApp/macdown).

MacDown does not update on your computer immediately when changes are made, so
something you experienced might be known, or even fixed in the development
version.

MacDown depends a lot on other open source projects, such as
[Hoedown](https://github.com/hoedown/hoedown) for Markdown-to-HTML rendering,
[Prism](http://prismjs.com) for syntax highlighting in code blocks, and
[PEG Markdown Highlight](https://github.com/ali-rantakari/peg-markdown-highlight)
for editor highlighting. If you find problems when using those particular
features, you can also consider reporting them directly to upstream projects as
well as checking whether the original MacDown project already documented the
behavior.

## Tipping

This note is retained from the original upstream project for the original
author.

If you find MacDown suitable for your needs, please consider [giving me a tip through PayPal](http://macdown.uranusjr.com/faq/#donation). Or, if you prefer to buy me a drink *personally* instead, just [send me a tweet](https://twitter.com/uranusjr) when you visit [Taipei, Taiwan](http://en.wikipedia.org/wiki/Taipei), where I live. I look forward to meeting you!
