# MacDown

[![](https://img.shields.io/github/release/MacDownApp/macdown.svg)](http://macdown.uranusjr.com/download/latest/)
![Total downloads](https://img.shields.io/github/downloads/MacDownApp/macdown/latest/total.svg)
[![Build Status](https://travis-ci.org/MacDownApp/macdown.svg?branch=master)](https://travis-ci.org/MacDownApp/macdown)


MacDown is an open source Markdown editor for OS X, released under the MIT License. The author stole the idea from [Chen Luo](https://twitter.com/chenluois)’s [Mou](http://mouapp.com) so that people can make crappy clones.

Visit the [project site](http://macdown.uranusjr.com/) for more information, or download [MacDown.app.zip](http://macdown.uranusjr.com/download/latest/) directly from the [latest releases](https://github.com/MacDownApp/macdown/releases/latest) page.

## Install

[Download](http://macdown.uranusjr.com/download/latest/), unzip, and drag the app to Applications folder. MacDown is also available through [Homebrew Cask](https://caskroom.github.io/):

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

* Xcode with the macOS 11.0 SDK or later
* Git
* [Bundler](http://bundler.io)

> Note: Old versions of CocoaPods are not supported. Please use Bundler to execute CocoaPods, or make sure your CocoaPods is later than shown in `Gemfile.lock`.

> Note: The Command Line Tools (CLT) should be unnecessary. If you failed to compile without it, please install CLT with
>
>     xcode-select --install
>
> and report back.

An appropriate SDK should be bundled with recent versions of Xcode. Command
Line Tools alone are not enough to build the Xcode workspace.

### Environment Setup

After cloning the repository, run the following commands inside the repository root (directory containing this `README.md` file):

    git submodule update --init
    bundle install
    bundle exec pod install
    make -C Dependency/peg-markdown-highlight

and open `MacDown.xcworkspace` in Xcode. The first command initialises the dependency submodule(s) used in MacDown; Bundler and CocoaPods install the Ruby and Cocoa dependencies.

Sparkle 2 is resolved by Xcode through Swift Package Manager from
`https://github.com/sparkle-project/Sparkle`. CocoaPods continues to manage the
Objective-C dependencies already used by MacDown.

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
    spctl -a -vv MacDown.app

### Translation

Please help translation on [Transifex](https://www.transifex.com/macdown/macdown/).

![Transifex translation percentage](https://www.transifex.com/projects/p/macdown/resource/macdownxliff/chart/image_png/)

## Discussion

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/MacDownApp/macdown)

Join our [Gitter channel](https://gitter.im/MacDownApp/macdown) if you have any problems with MacDown. Any suggestions are welcomed, too!

You can also [file an issue directly](https://github.com/MacDownApp/macdown/issues/new) on GitHub if you prefer so. But please, **search first to make sure no-one has reported the same issue already** before opening one yourself. MacDown does not update in your computer immediately when we make changes, so something you experienced might be known, or even fixed in the development version.

MacDown depends a lot on other open source projects, such as [Hoedown](https://github.com/hoedown/hoedown) for Markdown-to-HTML rendering, [Prism](http://prismjs.com) for syntax highlighting (in code blocks), and [PEG Markdown Highlight](https://github.com/ali-rantakari/peg-markdown-highlight) for editor highlighting. If you find problems when using those particular features, you can also consider reporting them directly to upstream projects as well as to MacDown’s issue tracker. I will do what I can if you report it here, but sometimes it can be more beneficial to interact with them directly.

## Tipping

If you find MacDown suitable for your needs, please consider [giving me a tip through PayPal](http://macdown.uranusjr.com/faq/#donation). Or, if you prefer to buy me a drink *personally* instead, just [send me a tweet](https://twitter.com/uranusjr) when you visit [Taipei, Taiwan](http://en.wikipedia.org/wiki/Taipei), where I live. I look forward to meeting you!
