# SystemImagePicker

[![Swift](https://img.shields.io/badge/Swift-5.8-%23DE5C43?style=flat&logo=swift)](https://swift.org)
![iOS](https://img.shields.io/badge/iOS-15.0-34c759)
![macOS](https://img.shields.io/badge/macOS-12-34c759)
![watchOS](https://img.shields.io/badge/watchOS-8.0-34c759)
![visionOS](https://img.shields.io/badge/visionOS-1.0-34c759)

**SystemImagePicker** is a _SwiftUI_ `View` providing a cross-platform and highly customizable `Picker`-like component for selecting **SF Symbols**. 

## Installation
### Swift Package Manager (Xcode 11 and above)
1. Select `File`/`Swift Packages`/`Add Package Dependency…` from the menu.
1. Paste `https://github.com/sbertix/SystemImagePicker.git`.
1. Follow the steps.

## Usage

The easiest way to present the `Picker` is through the provided `View` extension methods. 

```swift
struct SomeView: View {
    @State private var isPresentingSymbols: Bool = false
    @State private var symbol: String?
    
    var body: some View {    
        Button("Choose a SF Symbol") { 
            isPresentingSymbols = true 
        }.systemImagePicker(
            isPresented: $isPresentingSymbols, 
            selection: $symbol
        )
    }
 }
```

But you can also initialize `SystemImagePicker` directly. 

## Features

**SystemImagePicker** supports the widest variety of features of any _SF Symbols_ picker.

- [x] Sectioned and un-sectioned _SF Symbols_
- [x] Defaults for both sectioned and un-sectioned pickers
- [x] Filter or pass your own subset of _SF Symbols_ to pick from
- [x] Support both precise and human readable search (e.g. `"circle.fill"` returns only _circle.fill_, but `"circle fill"` or `"fill circle"` returns all _SF Symbols_ having a combination of both words)
- [x] Dismiss automatically on selection or wait for user input with `.systemImagePickerDismissOnSelection(false)`
- [x] Allow for no selection using `Optional`s 
- [x] Pixel-perfect padding using fully dynamic cell sizing
- [x] `Identifiable` and `RawRepresentable` support in place of `String` _SF Symbol_ name if you wanna be extra safe or you're using another library abstraction
- [x] Bring your own style or branding with `SystemImagePickerStyle` conformance
- [x] Support for _SF Symbols 5_ and _visionOS_

And much more!

## Appearance
|Light mode|Dark mode||
|---|---|---|
|<img align="middle" alt="iOS default appearance with custom subset" src="/resources/default.webp" width="120px"/>|<img align="middle" alt="iOS default appearance with custom subset" src="/resources/default-dark.webp" width="120px"/>|**iOS default** appearance with custom **subset**.|
|<img align="middle" alt="iOS unsectioned default appearance with confirmation required on dismiss and optional selection" src="/resources/optional-confirm.webp" width="120px"/>|<img align="middle" alt="iOS unsectioned default appearance with confirmation required on dismiss and optional selection" src="/resources/optional-confirm-dark.webp" width="120px"/>|**iOS unsectioned default** appearance with **confirmation** required **on dismiss** and **optional selection**.|
|<img align="middle" alt="macOS default appearance with filled-only subset" src="/resources/fill.webp" width="200px" />|<img align="middle" alt="macOS default appearance with filled-only subset" src="/resources/fill-dark.webp" width="200px" />|**macOS default** appearance with filled-only **subset**.<br />(_The modal sheet was scaled up for visibility in the README alone_)|

## Status
![GitHub release (latest by date)](https://img.shields.io/github/v/release/sbertix/SystemImagePicker)

You can find all changelogs directly under every [release](https://github.com/sbertix/SystemImagePicker/releases).

[Milestones](https://github.com/sbertix/SystemImagePicker/milestones), [issues](https://github.com/sbertix/SystemImagePicker/issues), are the best way to keep updated with active developement.
Feel free to contribute by sending a [pull request](https://github.com/sbertix/SystemImagePicker/pulls).
Just remember to refer to our [guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) beforehand.

<p />
