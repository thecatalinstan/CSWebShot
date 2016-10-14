[![Version Status](https://img.shields.io/cocoapods/v/CSWebShot.svg?style=flat)](http://cocoadocs.org/docsets/CSWebShot)  [![Platform](http://img.shields.io/cocoapods/p/CSWebShot.svg?style=flat)](http://cocoapods.org/?q=CSWebShot) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg?style=flat)](https://opensource.org/licenses/MIT)

# CSWebShot

A simple utility for getting the fully rendered content of a web-page, as the browser *sees* it, after all JavaScript, CSS and images have loaded and executed, either as a PNG or HTML text.

## Installation

Install using [CocoaPods](http://cocoapods.org) by adding this line to your Podfile:

````ruby
use_frameworks!

target 'MyApp' do
  pod 'CSWebShot'
end
````

## Getting a PNG rendering of a web page

The example below fetches a PNG rendering of a webpage and generates an `NSImage` object from the returned data. 

```swift
let url = URL(string: "https://criollo.io/")!
CSWebShot(url: url).webshot { (action, data, error) in
	if (error != nil) {
		print ("An error has occurred: \(error?.localizedDescription)")
		return
	}	
	let image = NSImage(data: data!)
}
```

## Getting the rendered HTML content of the page

The example below fetches the rendered HTML content of a webpage and generates a `String` object from the returned data. 

```swift
let url = URL(string: "https://criollo.io/")!
CSWebShot(url: url).renderedHTML { (action, data, error) in
	if (error != nil) {
		print ("An error has occurred: \(error?.localizedDescription)")
		return
	}	
	let html = String(data: data!, encoding: String.Encoding.utf8)
}
```

## What’s Next

Check out the complete documentation on [CocoaDocs](http://cocoadocs.org/docsets/CSWebShot/).
