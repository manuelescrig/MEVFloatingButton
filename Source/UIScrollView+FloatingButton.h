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

@protocol MEFloatingButtonSource;
@protocol MEFloatingButtonDelegate;

typedef NS_ENUM(NSInteger, FloatingButtonAnimationType) {
    FloatingButtonAnimationTypeNone,
    FloatingButtonAnimationTypeFadeIn,
    FloatingButtonAnimationTypeFromBottom
};

/*
typedef NS_ENUM(NSInteger, FloatingButtonDisplayMode) {
    FloatingButtonDisplayModeAlways,
    FloatingButtonDisplayModeWhenScrolling,
    FloatingButtonDisplayModeWhenScrollingDownOnly,
    FloatingButtonDisplayModeWhenScrollingUpOnly
};
*/

/**
 A drop-in UITableView/UICollectionView superclass category for showing a floating button on top of it.
 */
@interface UIScrollView (FloatingButton)

/** The floating button data source. */
@property (nonatomic, weak) IBOutlet id <MEFloatingButtonSource> floatingButtonSource;
/** The floating button delegate. */
@property (nonatomic, weak) IBOutlet id <MEFloatingButtonDelegate> floatingButtonDelegate;
/** Hides the floating button when it is tapped. Default NO. */
@property (nonatomic, assign, getter = isHideOnTap) BOOL hideOnTap;
/** YES if floating button is visible. */
@property (nonatomic, readonly, getter = isFloatingButtonVisible) BOOL floatingButtonVisible;

@end

/**
 The object that acts as the data source of the floating button.
 @discussion The data source must adopt the MEFloatingButtonSource protocol. The data source is not retained. All data source methods are optional.
 */
@protocol MEFloatingButtonSource <NSObject>
@optional

/**
 Asks the data source for the image to be used for the specified button state.
 
 @param scrollView A scrollView subclass object informing the data source.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 @return An image for the floating button imageview.
 */
- (UIImage *)buttonImageForFloatingButton:(UIScrollView *)scrollView forState:(UIControlState)state;

/**
 Asks the data source for the color to be used for the button image.
 
 @param scrollView A scrollView subclass object informing the data source.
 @return A color for the floating button image.
 @discussion When this method is not implemented, the image won't be rendered with another color.
 */
- (UIColor *)buttonTintColorForFloatingButton:(UIScrollView *)scrollView;

/**
 Asks the data source for the color to be used for the button background.
 
 @param scrollView A scrollView subclass object informing the data source.
 @return A color for the floating button background.
 @discussion When this method is not implemented. Default value is [UIColor darkGrayColor].
 */
- (UIColor *)buttonBackgroundColorForFloatingButton:(UIScrollView *)scrollView;

/**
 Asks the data source for the padding size to be used around the button image.
 
 @param scrollView A scrollView subclass object informing the data source.
 @return The size for the padding image inside the button.
 @discussion When this method is not implemented. Default value is 10.
 */
- (CGFloat)buttonImagePaddingForFloatingButton:(UIScrollView *)scrollView;

/**
 Asks the data source for a offset for vertical and horizontal alignment of the content. Default is 10.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return The offset for vertical alignment.
 */
- (CGFloat)verticalOffsetForFloatingButton:(UIScrollView *)scrollView;

/**
 Asks the data source for the type of animation to be used when presenting the floating button.
 
 @param scrollView A scrollView subclass object informing the data source.
 @return FloatingButtonAnimationType object type.
 @discussion When this method is not implemented. Default value is FloatingButtonAnimationTypeFadeIn.
 */
- (FloatingButtonAnimationType)animationTypeForFloatingButton:(UIScrollView *)scrollView;

@end


/**
 The object that acts as the delegate of the floating button.
 @discussion The delegate can adopt the MEFloatingButtonDelegate protocol. The delegate is not retained. All delegate methods are optional.
 @discussion All delegate methods are optional. Use this delegate for receiving action callbacks.
 */
@protocol MEFloatingButtonDelegate <NSObject>
@optional

/**
 Asks the delegate to know if the floating button should be rendered and displayed. Default is YES.
 
 @param scrollView A scrollView subclass object informing the delegate.
 @return YES if the floating button should show.
 */
- (BOOL)floatingButtonShouldDisplay:(UIScrollView *)scrollView;

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
