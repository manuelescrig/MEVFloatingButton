//
//  UIScrollView+FloatingButton.h
//  A drop-in UITableView/UICollectionView/UIScrollView superclass category for showing a floating button on top of it.
//
//  https://github.com/manuelescrig/MEFloatingButton
//
//  Created by Manuel Escrig Ventura on 27/01/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//  Licence: MIT-Licence
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DLog(s, ... ) NSLog(@"%@ | %@ | %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], NSStringFromSelector(_cmd), [NSString stringWithFormat:(s), ##__VA_ARGS__] )

@protocol MEFloatingButtonDelegate;

/**
 Display mode for the MEFloatingButton.
 */
typedef NS_ENUM(NSInteger, MEFloatingButtonDisplayMode) {
    MEFloatingButtonDisplayModeNone,
    MEFloatingButtonDisplayModeAlways,
    MEFloatingButtonDisplayModeWhenScrolling
};

/**
 Animation type for the MEFloatingButton.
 */
typedef NS_ENUM(NSInteger, MEFloatingButtonAnimation) {
    MEFloatingButtonAnimationNone,
    MEFloatingButtonAnimationFadeIn,
    MEFloatingButtonAnimationFromBottom
};

/**
 Position on the screen for the MEFloatingButton.
 */
typedef NS_ENUM(NSInteger, MEFloatingButtonPosition) {
    MEFloatingButtonPositionBottomCenter,
    MEFloatingButtonPositionBottomLeft,
    MEFloatingButtonPositionBottomRight
};


/**
 A UIView object subclass that represents the button itself.
 */
@interface MEFloatingButton : UIView

/**
 Sets the display mode MEFloatingButtonDisplayMode for the MEFloatingButton.
 @param displayMode A MEFloatingButtonDisplayMode type.
 @discussion MEFloatingButtonDisplayModeAlways is the default value when this property is not assigned.
 */
@property (nonatomic, assign) MEFloatingButtonDisplayMode displayMode;

/**
 Sets the animation type MEFloatingButtonAnimation for the MEFloatingButton.
 @param animationType A MEFloatingButtonAnimation type.
 @discussion MEFloatingButtonAnimationNone is the default value when this property is not assigned.
 */
@property (nonatomic, assign) MEFloatingButtonAnimation animationType;

/**
 Sets the position MEFloatingButtonPosition for the MEFloatingButton.
 @param position A MEFloatingButtonPosition type.
 @discussion MEFloatingButtonPositionBottomCenter is the default value when this property is not assigned.
 */
@property (nonatomic, assign) MEFloatingButtonPosition position;

/**
 Sets the image for the MEFloatingButton.
 @param image An UIImage object.
 @discussion This property must be assigned.
 */
@property (nonatomic, strong) UIImage *image;

/**
 Sets the background color for the MEFloatingButton.
 @param backgroundColor An UIColor object.
 @discussion [UIColor blueColor] is the default color when this property is not assigned.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 Sets the image color for the MEFloatingButton.
 @param imageColor An UIColor object.
 @discussion [UIColor whiteColor] is the default color when this property is not assigned.
 */
@property (nonatomic, strong) UIColor *imageColor;

/**
 Sets the outline color for the MEFloatingButton.
 @param outlineColor An UIColor object.
 @discussion [UIColor blueColor] is the default color when this property is not assigned.
 */
@property (nonatomic, strong) UIColor *outlineColor;

/**
 Sets the outline width size.
 @param outlineWidth A float indicating the width.
 @discussion 0.0f is the default value when this property is not assigned.
 */
@property (nonatomic) float outlineWidth;

/**
 Sets the padding size between the image and the outline.
 @param imagePadding A float indicating the padding.
 @discussion 10.0f is the default value when this property is not assigned.
 */
@property (nonatomic) float imagePadding;

/**
 Sets the horizontal offset.
 @param horizontalOffset A float indicating the offset.
 @discussion 0.0f is the default value when this property is not assigned.
 */
@property (nonatomic) float horizontalOffset;

/**
 Sets the vertical offset.
 @param verticalOffset A float indicating the offset.
 @discussion -20.0f is the default value when this property is not assigned.
 */
@property (nonatomic) float verticalOffset;

/**
 Indicates if the MEFloatingButton should be either square or rounded.
 @param rounded A BOOL value.
 @discussion Default value is YES.
 */
@property (nonatomic, getter=isRounded) BOOL rounded;

@end


/**
 A drop-in UITableView/UICollectionView superclass category for showing a floating button on top of it.
 */
@interface UIScrollView (FloatingButton)

/**
 The floating button delegate.
 */
@property (nonatomic, weak) IBOutlet id <MEFloatingButtonDelegate> floatingButtonDelegate;

/**
 The MEFloatingButton view.
 */
- (void)setFloatingButtonView:(MEFloatingButton *)view;

@end


/**
 The object that acts as the delegate of the floating button.
 @discussion The delegate can adopt the MEFloatingButtonDelegate protocol. The delegate is not retained. All delegate methods are optional.
 @discussion All delegate methods are optional. Use this delegate for receiving action callbacks.
 */
@protocol MEFloatingButtonDelegate <NSObject>
@optional

/**
 Tells the delegate that the action button was tapped.
 
 @param scrollView A scrollView subclass informing the delegate.
 @param button the button tapped by the user
 */
- (void)floatingButton:(UIScrollView *)scrollView didTapButton:(UIButton *)button;

/**
 Tells the delegate that the floating button will appear.
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)floatingButtonWillAppear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the floating button did appear.
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)floatingButtonDidAppear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the floating button will disappear.
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)floatingButtonWillDisappear:(UIScrollView *)scrollView;

/**
 Tells the delegate that the floating button did disappear.
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)floatingButtonDidDisappear:(UIScrollView *)scrollView;

@end
