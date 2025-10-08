<p align="center">
<a href="https://discord.gg/JAndPDc3" target="_blank"><img src="https://img.shields.io/discord/1351718119147831460?logo=discord"></a>
<a href="https://github.com/ChopinDavid/grammatika/actions" target="_blank"><img src="https://github.com/ChopinDavid/grammatika/actions/workflows/push_main.yml/badge.svg" alt="build"></a>
<a href="https://app.codecov.io/gh/ChopinDavid/grammatika" target="_blank"><img src="https://codecov.io/gh/ChopinDavid/grammatika/branch/main/graph/badge.svg" alt="codecov"></a>
</p>

## Grammatika
Grammatika is a free and open source language learning app. We do not charge and we do not show adds, and we never will. Grammatika is built using the [OpenRussian.org database](https://en.openrussian.org/) and currently supports exercises for English speakers wanting to learn the Russian language and its grammar. With that being said, there is tremendous potential for the app to have additional languages added, provided that the language is indexed in a way identical to the OpenRussian.org database (I believe [OpenSpanish.org](https://en.openspanish.org/) is also in the works). The app is also extremely flexible in the sense that new exercise types could easily be added. Right now, exercises to identify gender and practice declension and conjugation exist, but date/time telling, identifying numbers, etc. could all easily be added in the future.

<a href="https://apps.apple.com/us/app/grammatika/id6743226229"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTD0-VifLPKywOa4lSu4LWfOfsBb-lNBJrrRw&s" style="width: 20vw;"></a>

### [Demo Video](https://www.youtube.com/watch?v=WtZY2Bri0pA)

### How to contribute
Contributions to this project are welcome and encouraged! If you would like to report a bug or feature request, feel free to do so in [this repository's Issues page](https://github.com/ChopinDavid/grammatika/issues).

Please note that PRs will not be approved/merged until adequate test coverage has been added, either by the person who opened the PR or by a project maintainer. We have high test coverage and we want to keep it that way!

This project is setup so that open PRs must have all of their tests pass and pass a linter before they can be approved. This includes bumping [the version number in the pubspec.yaml](https://github.com/ChopinDavid/grammatika/blob/069626f93de02bb3234d09cb3010e232b0d1d2f7/pubspec.yaml#L19) and adding a corresponding entry in [our CHANGELOG.md](https://github.com/ChopinDavid/grammatika/blob/main/CHANGELOG.md).

### Setup
Install flutter, clone the repo, run `flutter pub get` and you should be ready to code!

### Downloading the app
We plan to release the app to both Google Play and the App Store in the near future. For the time being, we will be building a beta testing group. Members of [our Discord server](https://discord.gg/JAndPDc3) can also be notified/can download new builds from the [mobile-builds channel](https://discord.gg/7GAAGzdS). iOS users can also take part in [our public TestFlight](https://testflight.apple.com/join/bDtu3G9B).

### Help wanted!
Any issue in the Issues page is something that the team has identified as needing to be addressed, but here are some issues that are particularly noteworthy:
* [We need app icon/splash page designs](https://github.com/ChopinDavid/grammatika/issues/9)!
* General UI designs from Figma would be very nice.
* Our [deploy to iOS workflow](https://github.com/ChopinDavid/grammatika/blob/14bdf6ebc2035a0661473769d2b498c59f31a21e/.github/workflows/workflow_dispatch.yml#L113-L119) is currently not workring as expected. Signing/building the ipa file seems to always fail in CD/CI. [Would love some guidance on how to make this work correctly](https://github.com/ChopinDavid/grammatika/issues/6).
