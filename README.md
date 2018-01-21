![ActionsList](https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/ActionsList/ActionsListHeader.png)

<p align="center">
<a href=""><img alt="Swift" src="https://img.shields.io/badge/Swift-3.2+-orange.svg?style=flat" /></a>
<a href="http://cocoapods.org/pods/ActionsList"><img alt="Platform" src="https://img.shields.io/cocoapods/p/ActionsList.svg?style=flat&label=Platform" /></a>
<a href="https://raw.githubusercontent.com/LowKostKustomz/ActionsList/master/LICENSE"><img alt="License" src="https://img.shields.io/cocoapods/l/ActionsList.svg?style=flat&label=License" /></a>
<br /><br />Dependency managers<br />
<a href="http://cocoapods.org/pods/ActionsList"><img alt="Cocoapods" src="https://img.shields.io/cocoapods/v/ActionsList.svg?style=flat&label=Cocoapods" /></a>
<a href="https://github.com/Carthage/Carthage"><img alt="Carthage" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" /></a>
<a href="https://swiftpkgs.ng.bluemix.net/package/LowKostKustomz/ActionsList"><img alt="SwiftPackageManager" src="https://img.shields.io/badge/Swift_Package_Manager-compatible-orange.svg?style=flat" /></a>
<br />
</p>

ActionsList is an iOS framework for presenting actions lists similar to Apple's Quick Actions menu. It presents and dismisses list with actions with animation from the source view.

It is the best replace for the Android's floating action button in iOS if your app is following the iOS Design Guidelines.

![ScreenShot](https://raw.githubusercontent.com/LowKostKustomz/ActionsList/master/Assets/ClocksScreenShot.png)

 - [Features](#features)
 - [Requirements](#requirements)
 - [Known Issues and Important Things](#known-issues-and-important-things)
 - [Installation](#installation)
	- [CocoaPods](#cocoapods)
	- [Carthage](#carthage)
	- [Swift Package Manager](#swift-package-manager)
	- [Manual installation](#manual-installation)
 - [Demo](#demo)
 - [Usage](#usage)
 - [Customization](#customization)
 	- [List](#list)
 	- [Actions](#actions)
 	- [Background View](#background-view)
 	- [Feedback](#feedback)
 - [Apps Using _ActionsList_](#apps-using-actionslist)
 - [Author](#author)
 - [License](#license)

## Features

* System-like look and feel:

>	- actions order is reverted if list is displayed in top part of the screen;
>	- feedback is generated on list opening and action highlight (if device supports any feedback; can be disabled);
>	- blurred list background and background view (if device supports blur and "Reduce transparency" is off, otherwise dimmed view will be used; can be customized);
>	- source view pulses on list opening;

* Safe Areas supported;
* Universal (iPhone & iPad);
* Change orientation supported (not fully, see [**Known Issues**](#known-issues));
* Highly customizable:

>	- no actions count limits (contained in scroll view);
>	- list background color, action's appearance and background view can be changed;


## Requirements

* Xcode 9.0 or later
* iOS 9.0 or later
* Swift 3.2 or later

## Known Issues and Important things

* List created with `UITabBarItem` extension method does not support orientation changes:

> Constraints to `UITabBarItem` do not work properly, so after orientation change `sourceView` and `senderView` will have different frames and content positions.

* `UIBarButtonItem`'s create list method is obsoleted since iOS 11:

> In iOS 11 `UIBarButtonItem` created with `image` or `title` initializer has wrong content frame, so `sourceView` will be a bit offset. Instead, use `init(customView:)` to create `UIBarButtonItem` with UIButton and create list with this button. In iOS 10 or earlier issue is not present.

## Installation

### CocoaPods

To install ActionsList using [CocoaPods](http://cocoapods.org), add the following line to your `Podfile`:

```ruby
pod 'ActionsList', '~> 0.9.1'
```

### Carthage

To install ActionsList using [Carthage](https://github.com/Carthage/Carthage), add the following line to your `Cartfile`:

```ruby
github "LowKostKustomz/ActionsList" ~> 0.9.1
```

### Swift Package Manager

To install StatusAlert using [Swift Package Manager](https://github.com/apple/swift-package-manager) add this to your dependencies in a `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/LowKostKustomz/ActionsList.git", .exact("0.9.1"))
]
```

### Manual installation

You can also add this project:
 * as git submodule;
 * simply download and copy source files to your project.

## Demo

Demo application is included in the `ActionsList` workspace. To run it clone the repo.

![Demo Screenshot](https://raw.githubusercontent.com/LowKostKustomz/ActionsList/master/Assets/DemoScreenshot.png)

## Usage

```swift
// Importing framework
import ActionsList

// Save list model to a property or it will be deallocated and you will have no ability to control it outside of the scope list was created in
private var list: ActionsListModel? = nil

// Creating list in your method
private func method() {

	// For UIButton instance (must be in the view hierarchy)
	let list = uiButton.createActionsList() // Use createActionsList(withDelegate:) if needed
	
	// For UITabBarItem instance (must be in the view hierarchy)
	let list = uiTabBarItem.createActionsList() // Use createActionsList(withDelegate:) if needed
	
	// For UIBarButtonItem instance (must be in the view hierarchy)
	let list = uiBarButtonItem.createActionsList() // Use createActionsList(withColor:font:delegate:) if needed
	
	// For your custom view (must be in the view hierarchy)
	let list = ActionsListModel(senderView: viewThatEmittedListShowing, 
				    sourceView: copyOfSenderViewToShowAboveBackgroundView, 
				    delegate: actionsListDelegate)
	
	// Add actions to list in order to 
	list.add(action: ActionsListDefaultButtonModel(
	    localizedTitle: "Create Alarm",
	    image: UIImage(named: "Alarm clock"),
	    action: { action in
		// You can use action's list property to control it
		                                               
		// - To dismiss
		action.list?.dismiss()
		                                                
		// - To update action appearance
		action.appearance.//anything
		// Do not forget to reload actions to apply changes
		action.list?.reloadActions()
	}))
	
	// Present list
	list.present()
	
	// Do not forget to save list to the property
	self.list = list
}
```

## Customization

> **IMPORTANT**
> 
> Default list appearance looks and feels similar to the system menu.

### List

To customize list background colors use `ActionsListModel`'s `appearance` property or `ActionsListAppearance.List.common` to set default appearance.

### Actions

To customize actions you can use `ActionsListDefaultButtonModel`'s `appearance` property or `ActionsListAppearance.Button.common` to set default appearance.

Action can be disabled, you can control it via the `ActionsListDefaultButtonModel`'s `isEnabled` property.

Actions generate feedback on highlight, to manage this see [**Feedback**](#feedback) section.

### Background View

To set custom background view use `ActionsListBackgroundViewBuilder`'s type property.
> Custom background view should implement `ActionsListBackgroundView` protocol

```swift
ActionsListBackgroundViewBuilder.instance.type = .custom(backgroundView: customBackgroundView)
```

To change default dimmed view dimming color use `ActionsListAppearance.BackgroundView.common.dimmingColor`

### Feedback

> Taptic engine is used on iPhone 6s and iPhone 6s Plus only.
> 
> Haptic feedback is used on iPhone 7, iPhone 7 Plus and later.
> 
> Other devices do not produce feedback.

To disable feedback generation use `FeedbackGenerator.instance.isEnabled` property. This property manages list opening and action highlight feedback.

## Apps Using _ActionsList_

[BitxfyAppStoreLink]: https://itunes.apple.com/us/app/bitxfy-bitcoin-wallet/id1326910438?ls=1&mt=8

### • <img src="https://raw.githubusercontent.com/LowKostKustomz/ActionsList/master/Assets/BitxfyIcon.png" align="center" width="40"> [Bitxfy][BitxfyAppstoreLink]

[![BitxfyScreenShot](https://raw.githubusercontent.com/LowKostKustomz/ActionsList/master/Assets/BitxfyActionsList.png)][BitxfyAppstoreLink]

> Feel free to submit pull request if you are using this framework in your apps.

## Author

[FrameworksRepo]: https://github.com/LowKostKustomz/Frameworks

[![Author ActionsList](https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/ActionsList/ActionsListAuthor.png)][FrameworksRepo]

[<img src="https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/Socials/Twitter.png" width="80">](https://twitter.com/LowKostKustomz)
[<img src="https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/Socials/Email.png" width="80">](mierosh@gmail.com)
[<img src="https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/Socials/Portfolio.png" width="80">][FrameworksRepo]

## License

> The MIT License (MIT)
>
> Copyright (c) 2017-2018 LowKostKustomz <mierosh@gmail.com>
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
