//
//  UIScrollView+FloatingButton.h
//  A drop-in UITableView/UICollectionView/UIScrollView superclass category for showing a floating button on top of it.
//
//  https://github.com/manuelescrig/MEVFloatingButton
//
//  Created by Manuel Escrig Ventura on 27/01/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//  Licence: MIT-Licence
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MEVFloatingButtonDelegate;

/*! @enum MEVFloatingButtonDisplayMode
 @abstract Display mode for the MEVFloatingButton.
 @constant MEVFloatingButtonDisplayModeNone             Button not displaying.
 @constant MEVFloatingButtonDisplayModeAlways           Button is displayed always.
 @constant MEVFloatingButtonDisplayModeWhenScrolling    Button is just displayed when the user scrolls.
 */
typedef NS_ENUM(NSInteger, MEVFloatingButtonDisplayMode) {
    MEVFloatingButtonDisplayModeNone,
    MEVFloatingButtonDisplayModeAlways,
    MEVFloatingButtonDisplayModeWhenScrolling
};

/*! @enum MEVFloatingButtonAnimation
 @abstract Animation type for the MEVFloatingButton. The MEVFloatingButtonAnimation will make effect
 @discussion The MEVFloatingButtonAnimation will make effect only when the MEVFloatingButtonDisplayMode selected is MEVFloatingButtonDisplayModeWhenScrolling.
 @constant MEVFloatingButtonAnimationNone               Button will be displayed without any animation.
 @constant MEFloatingButtonAnimationFadeIn              Button will be displayed with a fade in/fade out animation.
 @constant MEVFloatingButtonAnimationFromBottom         Button will be displayed with an animation comging from bottom.
 */
typedef NS_ENUM(NSInteger, MEVFloatingButtonAnimation) {
    MEVFloatingButtonAnimationNone,
    MEFloatingButtonAnimationFadeIn,
    MEVFloatingButtonAnimationFromBottom
};


/*! @enum MEVFloatingButtonPosition
 @abstract Position on the screen for the MEVFloatingButton.
 @constant MEVFloatingButtonPositionBottomCenter        Button will be displayed in the bottom center.
 @constant MEVFloatingButtonPositionBottomLeft          Button will be displayed in the bottom left.
 @constant MEVFloatingButtonPositionBottomRight         Button will be displayed in the bottom right.
 */
typedef NS_ENUM(NSInteger, MEVFloatingButtonPosition) {
    MEVFloatingButtonPositionBottomCenter,
    MEVFloatingButtonPositionBottomLeft,
    MEVFloatingButtonPositionBottomRight
};


/*! A UIView object subclass that represents the button itself.
 */
@interface MEVFloatingButton : UIView

/*! @abstract Sets the display mode MEVFloatingButtonDisplayMode for the MEVFloatingButton.
 @param displayMode A MEVFloatingButtonDisplayMode type.
 @discussion MEVFloatingButtonDisplayModeAlways is the default value when this property is not assigned.
 */
@property (nonatomic, assign) MEVFloatingButtonDisplayMode displayMode;

/*! @abstract Sets the animation type MEVFloatingButtonAnimation for the MEVFloatingButton.
 @param animationType A MEVFloatingButtonAnimation type.
 @discussion MEVFloatingButtonAnimationNone is the default value when this property is not assigned.
 */
@property (nonatomic, assign) MEVFloatingButtonAnimation animationType;

/*! @abstract Sets the position MEVFloatingButtonPosition for the MEVFloatingButton.
 @param position A MEVFloatingButtonPosition type.
 @discussion MEVFloatingButtonPositionBottomCenter is the default value when this property is not assigned.
 */
@property (nonatomic, assign) MEVFloatingButtonPosition position;

/*! @abstract Sets the image for the MEVFloatingButton.
 @param image An UIImage object.
 @discussion This property must be assigned.
 */
@property (nonatomic, strong) UIImage *image;

/*! @abstract Sets the image color for the MEVFloatingButton.
 @param imageColor An UIColor object.
 @discussion [UIColor whiteColor] is the default color when this property is not assigned.
 */
@property (nonatomic, strong) UIColor *imageColor;

/*! @abstract Sets the background color for the MEVFloatingButton.
 @param backgroundColor An UIColor object.
 @discussion [UIColor blueColor] is the default color when this property is not assigned.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/*! @abstract Sets the shadow color for the MEVFloatingButton.
 @param shadowColor An UIColor object.
 @discussion [UIColor clearColor] is the default color when this property is not assigned.
 */
@property (nonatomic, strong) UIColor *shadowColor;

/*! @abstract Sets the shadow offset for the MEVFloatingButton.
 @param shadowOffset A CGSize struct indicating the offset.
 @discussion CGSizeMake(0, 0) is the default value when this property is not assigned.
 */
@property (nonatomic) CGSize shadowOffset;

/*! @abstract Sets the opacity shadow for the MEVFloatingButton.
 @param shadowOpacity A float indicating the shadow opacity.
 @discussion 1.0f is the default value when this property is not assigned.
 */
@property (nonatomic) float shadowOpacity;

/*! @abstract Sets the radious shadow for the MEVFloatingButton.
 @param shadowRadius A float indicating the shadow radius.
 @discussion 1.0f is the default value when this property is not assigned.
 */
@property (nonatomic) float shadowRadius;

/*! @abstract Sets the outline color for the MEVFloatingButton.
 @param outlineColor An UIColor object.
 @discussion [UIColor blueColor] is the default color when this property is not assigned.
 */
@property (nonatomic, strong) UIColor *outlineColor;

/*! @abstract Sets the outline width size.
 @param outlineWidth A float indicating the width.
 @discussion 0.0f is the default value when this property is not assigned.
 */
@property (nonatomic) float outlineWidth;

/*! @abstract Sets the padding size between the image and the outline.
 @param imagePadding A float indicating the padding.
 @discussion 10.0f is the default value when this property is not assigned.
 */
@property (nonatomic) float imagePadding;

/*! @abstract Sets the horizontal offset.
 @param horizontalOffset A float indicating the offset.
 @discussion 0.0f is the default value when this property is not assigned.
 */
@property (nonatomic) float horizontalOffset;

/*! @abstract Sets the vertical offset.
 @param verticalOffset A float indicating the offset.
 @discussion -20.0f is the default value when this property is not assigned.
 */
@property (nonatomic) float verticalOffset;

/*! @abstract Indicates if the MEVFloatingButton should be either square or rounded.
 @param rounded A BOOL value.
 @discussion Default value is NO.
 */
@property (nonatomic, getter=isRounded) BOOL rounded;

/*! @abstract Indicates if the MEVFloatingButton will be hidden when on the scroll view is scroll to top.
 @param hideWhenScrollToTop A BOOL value.
 @discussion Default value is NO.
 */
@property (nonatomic, getter=isHideWhenScrollToTop) BOOL hideWhenScrollToTop;

@end


/*! A drop-in UITableView/UICollectionView superclass category for showing a floating button on top of it.
 */
@interface UIScrollView (FloatingButton)

/*! The floating button delegate.
 */
@property (nonatomic, weak) IBOutlet id <MEVFloatingButtonDelegate> floatingButtonDelegate;

/*! The MEVFloatingButton view.
 */
- (void)setFloatingButtonView:(MEVFloatingButton *)view;

@end


/*! A protocol that acts as the delegate of the floating button.
 @discussion The delegate can adopt the MEVFloatingButtonDelegate protocol. The delegate is not retained. All delegate methods are optional.
 @discussion All delegate methods are optional. Use this delegate for receiving action callbacks.
 */
@protocol MEVFloatingButtonDelegate <NSObject>
@optional

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

@end
