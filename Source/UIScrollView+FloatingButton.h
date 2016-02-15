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

#import <UIKit/UIKit.h>

#define DLog(s, ... ) NSLog(@"%@ | %@ | %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], NSStringFromSelector(_cmd), [NSString stringWithFormat:(s), ##__VA_ARGS__] )

@protocol MEFloatingButtonDelegate;


typedef NS_ENUM(NSInteger, MEFloatingButtonDisplayMode) {
    MEFloatingButtonDisplayModeNone,
    MEFloatingButtonDisplayModeAlways,
    MEFloatingButtonDisplayModeWhenScrolling
};

typedef NS_ENUM(NSInteger, MEFloatingButtonAnimation) {
    MEFloatingButtonAnimationNone,
    MEFloatingButtonAnimationFadeIn,
    MEFloatingButtonAnimationFromBottom
};

typedef NS_ENUM(NSInteger, MEFloatingButtonPosition) {
    MEFloatingButtonPositionBottomCenter,
    MEFloatingButtonPositionBottomLeft,
    MEFloatingButtonPositionBottomRight
};


@interface MEFloatingButton : UIView

@property (nonatomic, assign, readonly) MEFloatingButtonDisplayMode displayMode;

@property (nonatomic, assign, readonly) MEFloatingButtonAnimation animationType;

@property (nonatomic, assign, readonly) MEFloatingButtonPosition position;

@property (nonatomic, strong, readonly) UIColor *backgroundColor;

@property (nonatomic, strong, readonly) UIImage *image;

@property (nonatomic, strong, readonly) UIColor *imageColor;

@property (nonatomic, strong, readonly) UIColor *outlineColor;

@property (nonatomic, readonly) float outlineWidth;

@property (nonatomic, readonly) float imagePadding;

@property (nonatomic, readonly) float horizontalOffset;

@property (nonatomic, readonly) float verticalOffset;

- (void)setDisplayMode:(MEFloatingButtonDisplayMode)displayMode;

- (void)setAnimationType:(MEFloatingButtonAnimation)animationType;

- (void)setPosition:(MEFloatingButtonPosition)position;

- (void)setImage:(UIImage *)image;

- (void)setImageColor:(UIColor *)imageColor;

- (void)setBackgroundColor:(UIColor *)backgroundColor;

- (void)setOutlineColor:(UIColor *)outlineColor;

- (void)setOutlineWidth:(float)outlineWidth;

- (void)setImagePadding:(float)imagePadding;

- (void)setHorizontalOffset:(float)horizontalOffset;

- (void)setVerticalOffset:(float)verticalOffset;

@end


/**
 A drop-in UITableView/UICollectionView superclass category for showing a floating button on top of it.
 */
@interface UIScrollView (FloatingButton)

/**
 The floating button delegate.
 */
@property (nonatomic, weak) IBOutlet id <MEFloatingButtonDelegate> floatingButtonDelegate;


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
