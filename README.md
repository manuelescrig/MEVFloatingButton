# MEFloatingButton
An iOS drop-in UITableView/UICollectionView/UIScrollView superclass category for showing a floating button on top of it.

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-objective--c-blue.svg?style=flat
)](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)


## Demo Screens
![feb 22 2016 14 16](https://cloud.githubusercontent.com/assets/1849990/13219261/29aef4a8-d96f-11e5-8632-85b31c3c1c1f.gif)
![feb 22 2016 14 17](https://cloud.githubusercontent.com/assets/1849990/13219263/29d8c3b4-d96f-11e5-9d12-502363e77759.gif)
![feb 22 2016 14 18](https://cloud.githubusercontent.com/assets/1849990/13219262/29d78f94-d96f-11e5-8d01-0805ef799160.gif)
![feb 22 2016 14 21](https://cloud.githubusercontent.com/assets/1849990/13219329/9efde354-d96f-11e5-88a5-4175729e471e.gif)


## Requirements

Requires iOS SDK version > 8.0


## Installation
### CocoaPods
Comming soon.

### Manual 

Simply include `UIScrollView+FloatingButton.h` and `UIScrollView+FloatingButton.m` from `Source` folder in your App’s Xcode project. 


## How to use
### Step 1

```
#import "UIScrollView+FloatingButton.h"
```

### Step 2

Add delegate and delegate methods.
```
@interface ViewController () <MEVFloatingButtonDelegate>
```

```
#pragma mark - MEScrollToTopDelegate Methods

/*! @abstract Tells the delegate that the action button was tapped.
 @param scrollView A scrollView subclass informing the delegate.
 @param button the button tapped by the user
 */
- (void)floatingButton:(UIScrollView *)scrollView didTapButton:(UIButton *)button;

/*! @abstract Tells the delegate that the floating button will appear.
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)floatingButtonWillAppear:(UIScrollView *)scrollView;

/*! @abstract Tells the delegate that the floating button did appear.
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)floatingButtonDidAppear:(UIScrollView *)scrollView;

/*! @abstract Tells the delegate that the floating button will disappear.
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)floatingButtonWillDisappear:(UIScrollView *)scrollView;

/*! @abstract Tells the delegate that the floating button did disappear.
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)floatingButtonDidDisappear:(UIScrollView *)scrollView;
```

### Step 3

Create a `MEVFloatingButton`object.
```
MEVFloatingButton *button = [[MEVFloatingButton alloc] init];
button.animationType = MEVFloatingButtonAnimationFromBottom;
button.displayMode = MEVFloatingButtonDisplayModeWhenScrolling;
button.position = MEVFloatingButtonPositionBottomCenter;
button.image = [UIImage imageNamed:@"Icon0"];
button.imageColor = [UIColor groupTableViewBackgroundColor];
button.backgroundColor = [UIColor darkGrayColor];
button.outlineColor = [UIColor darkGrayColor];
button.outlineWidth = 0.0f;
button.imagePadding = 20.0f;
button.horizontalOffset = 20.0f;
button.verticalOffset = -30.0f;
button.rounded = YES;
button.hideWhenScrollToTop = YES;
```
Set the object to your UIScrollView/UITableView/UICollectionView.
```
[self.tableView setFloatingButtonView:button];
```

## Sample Project

For more info check the Examples project. Everything is there.

## Author

Manuel Escrig Ventura, [@manuelescrig](https://twitter.com/manuelescrig)

Portfolio,  [ventura.media](https//ventura.media)

## Credits
Icons made by Elegant Themes from www.flaticon.com 


## License

MEFloatingButton is available under the MIT License. See the LICENSE file for more info.

