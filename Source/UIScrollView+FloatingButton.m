//
//  UIScrollView+FloatingButton.m
//  A drop-in UITableView/UICollectionView/UIScrollView superclass category for showing a floating button on top of it.
//
//  https://github.com/manuelescrig/MEFloatingButton
//
//  Created by Manuel Escrig Ventura on 27/01/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//  Licence: MIT-Licence
//

#import "UIScrollView+FloatingButton.h"
#import <objc/runtime.h>
#import <objc/message.h>

#pragma mark - MEFloatingButton

typedef NS_ENUM(NSInteger, FloatingButtonState) {
    FloatingButtonStateWillAppear,
    FloatingButtonStateDidAppear,
    FloatingButtonStateWillDisappear,
    FloatingButtonStateDidDisappear
};


@interface MEFloatingButton ()

@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, readonly) UIButton *button;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) NSTimer *fadeOutTimer;

@property (nonatomic, assign) FloatingButtonState buttonState;

- (void)setupConstraints;
- (void)prepareForReuse;

@end

@implementation MEFloatingButton
@synthesize contentView = _contentView;
@synthesize button = _button;

#pragma mark - Initialization Methods

- (instancetype)init
{
    self =  [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)didMoveToSuperview
{
    self.frame = self.superview.bounds;
    
    void(^fadeInBlock)(void) = ^{_contentView.alpha = 1.0;};
    fadeInBlock();
}


#pragma mark - Getters

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.userInteractionEnabled = YES;
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.backgroundColor = [UIColor darkGrayColor];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.accessibilityIdentifier = @"floating button";
        _button.userInteractionEnabled = YES;
        
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_button];
    }
    return _button;
}

- (BOOL)canShowButton
{
    if ([_button attributedTitleForState:UIControlStateNormal].string.length > 0 || [_button imageForState:UIControlStateNormal]) {
        return (_button.superview != nil) ? YES : NO;
    }
    return NO;
}


#pragma mark - Action Methods

- (void)didTapButton:(id)sender
{
    SEL selector = NSSelectorFromString(@"me_didTapDataButton:");
    
    if ([self.superview respondsToSelector:selector]) {
        [self.superview performSelector:selector withObject:sender afterDelay:0.0f];
    }
}


#pragma mark - Layout Configuration

- (void)setupConstraints
{
    [self.button.layer setCornerRadius:_button.frame.size.width/2];
    [self.contentView setFrame:CGRectMake(0, 0, _button.frame.size.width, _button.frame.size.width)];
    [self.contentView setCenter:CGPointMake(self.center.x, self.frame.size.height - self.button.frame.size.height - self.verticalOffset)];
}

- (void)prepareForReuse
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _button = nil;
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    // Return any UIControl instance such as buttons, segmented controls, switches, etc.
    if ([hitView isKindOfClass:[UIControl class]]) {
        return hitView;
    }
    
    // Return either the contentView
    if ([hitView isEqual:_contentView]) {
        return hitView;
    }
    
    return nil;
}

@end


#pragma mark - UIScrollView+FloatingButton

static char const *const kFloatingButtonSource = "floatingButtonSource";
static char const *const kFloatingButtonDelegate = "floatingButtonDelegate";
static char const *const kFloatingButtonView = "floatingButton";

static NSString *const kObserverContentOffset = @"contentOffset";
static NSString *const kObserverFrame = @"frame";

static float const kFloatingButtonDefaultImagePadding = 10.0f;
static float const kFloatingButtonDefaultOffset = 10.0f;
static float const kFloatingButtonDefaultFadingDurationTime = 2.0f;
static float const kFloatingButtonDefaultFadingAnimationTime = 0.3f;
static float const kFloatingButtonDefaultFromBottomAnimationTime = 0.5f;

@interface UIScrollView () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL hideOnTap;

@end

@implementation UIScrollView (FloatingButton)


//+ (void)load
//{
//    DLog(@"load");
//    
//    Method origMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
//    Method newMethod = class_getInstanceMethod([self class], @selector(my_dealloc));
//    method_exchangeImplementations(origMethod, newMethod);
//}
//
//- (void)my_dealloc {
//    DLog(@"my_dealloc");
//
//    [self stopTimer];
//    
//    @try {
//        [self removeObserver:self forKeyPath:kObserverContentOffset context:nil];
//        [self removeObserver:self forKeyPath:kObserverFrame context:nil];
//    } @catch(id anException) {
//        //do nothing, obviously it wasn't attached because an exception was thrown
//    }
//    
//    // This calls original dealloc method
//    [self my_dealloc];
//}



#pragma mark - Setters (Public)

- (void)setFloatingButtonSource:(id<MEFloatingButtonSource>)floatingButtonSource
{
    DLog(@"setFloatingButtonSource");

    if (!floatingButtonSource || ![self me_canDisplay]) {
        [self me_invalidateView];
    }
    
    objc_setAssociatedObject(self, kFloatingButtonSource, floatingButtonSource, OBJC_ASSOCIATION_ASSIGN);
    
    [self me_validateView];
}

- (void)setFloatingButtonDelegate:(id<MEFloatingButtonDelegate>)floatingButtonDelegate
{
    DLog(@"setFloatingButtonDelegate");

    if (!floatingButtonDelegate) {
        [self me_invalidateView];
    }
    
    objc_setAssociatedObject(self, kFloatingButtonDelegate, floatingButtonDelegate, OBJC_ASSOCIATION_ASSIGN);
    
    // Add observer to be notified when scrolling
    [self addObserver:self forKeyPath:kObserverContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    // Add observer to be notified when frame changes
    [self addObserver:self forKeyPath:kObserverFrame options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}


#pragma mark - Setters (Private)

- (void)setFloatingButtonView:(MEFloatingButton *)view
{
    DLog(@"setFloatingButtonView");

    objc_setAssociatedObject(self, kFloatingButtonView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Getters (Public)

- (id<MEFloatingButtonSource>)floatingButtonSource
{
    return objc_getAssociatedObject(self, kFloatingButtonSource);
}

- (id<MEFloatingButtonDelegate>)floatingButtonDelegate
{
    return objc_getAssociatedObject(self, kFloatingButtonDelegate);
}

- (BOOL)isFloatingButtonVisible
{
    UIView *view = objc_getAssociatedObject(self, kFloatingButtonView);
    return view ? !view.hidden : NO;
}


#pragma mark - Getters (Private)

- (MEFloatingButton *)floatingButton
{
    MEFloatingButton *view = objc_getAssociatedObject(self, kFloatingButtonView);
    
    if (!view) {
        view = [MEFloatingButton new];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.hidden = YES;
        
        [self setFloatingButtonView:view];
    }
    
    return view;
}

- (BOOL)me_canDisplay
{
    DLog(@"self.bounds = %@", NSStringFromCGRect(self.bounds));
    DLog(@"self.window = %@", self.window);
    
    if (self.floatingButtonSource && [self.floatingButtonSource conformsToProtocol:@protocol(MEFloatingButtonSource)]) {
        if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]] || [self isKindOfClass:[UIScrollView class]]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)me_isVisible
{
    DLog(@"self.bounds = %@", NSStringFromCGRect(self.bounds));
    DLog(@"self.window = %@", self.window);
    
    if (self.window) {
        return YES;
    } else {
        
        [self stopTimer];
        
        @try {
            [self removeObserver:self forKeyPath:kObserverContentOffset context:nil];
            [self removeObserver:self forKeyPath:kObserverFrame context:nil];
        } @catch(id anException) {
            //do nothing, obviously it wasn't attached because an exception was thrown
        }
    }
    
    return NO;
}


#pragma mark - DataSource Getters (Private)

- (BOOL)me_shouldDisplay
{
    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(floatingButtonShouldDisplay:)]) {
        return [self.floatingButtonSource floatingButtonShouldDisplay:self];
    }
    return YES;
}

- (BOOL)me_hideOnTap
{
    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(floatingButtonShouldDisplay:)]) {
        return [self.floatingButtonSource floatingButtonHideOnTap:self];
    }
    return NO;
}

- (UIImage *)me_buttonImageForState:(UIControlState)state
{
    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(buttonImageForFloatingButton:forState:)]) {
        UIImage *image = [self.floatingButtonSource buttonImageForFloatingButton:self forState:state];
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -buttonImageForFloatingButton:forState:");
        return image;
    }
    return nil;
}

- (UIColor *)me_buttonTintColor
{
    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(buttonTintColorForFloatingButton:)]) {
        UIColor *color = [self.floatingButtonSource buttonTintColorForFloatingButton:self];
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object for -buttonTintColorForFloatingButton:");
        return color;
    }
    return nil;
}

- (UIColor *)me_buttonBackgroundColor
{
    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(buttonBackgroundColorForFloatingButton:)]) {
        UIColor *color = [self.floatingButtonSource buttonBackgroundColorForFloatingButton:self];
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object for -buttonBackgroundColorForFloatingButton:");
        return color;
    }
    return nil;
}

- (CGFloat)me_buttonImagePadding
{
    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(buttonImagePaddingForFloatingButton:)]) {
        CGFloat size = [self.floatingButtonSource buttonImagePaddingForFloatingButton:self];
        if (size) NSAssert(size >= 0, @"You must return a valid CGFloat object for -buttonImagePaddingForFloatingButton:");
        return size;
    }
    return kFloatingButtonDefaultImagePadding;
}


- (CGFloat)me_verticalOffset
{
    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(verticalOffsetForFloatingButton:)]) {
        CGFloat offset = [self.floatingButtonSource verticalOffsetForFloatingButton:self];
        if (offset) NSAssert(offset >= 0, @"You must return a valid CGFloat object for -verticalOffsetForFloatingButton:");
        return offset;
    }
    return kFloatingButtonDefaultOffset;
}

- (FloatingButtonAnimation)me_animationType
{
    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(animationTypeForFloatingButton:)]) {
        return [self.floatingButtonSource animationTypeForFloatingButton:self];
    }
    return MEFloatingButtonAnimationFadeIn;
}

- (MEFloatingButtonDisplayMode)me_displayMode
{
    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(displayModeForFloatingButton:)]) {
        return [self.floatingButtonSource displayModeForFloatingButton:self];
    }
    return MEFloatingButtonDisplayModeWhenScrolling;
}


#pragma mark - Delegate Events (Private)

- (void)me_willAppear
{
    self.floatingButton.buttonState = FloatingButtonStateWillAppear;
    self.floatingButton.hidden = NO;

    
    if ([self me_isVisible]) {
        DLog(@"self.floatingButtonDelegate = %@", self.floatingButtonDelegate);
        if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonWillAppear:)]) {
            [self.floatingButtonDelegate floatingButtonWillAppear:self];
        }
    }
}

- (void)me_didAppear
{
    self.floatingButton.buttonState = FloatingButtonStateDidAppear;

    DLog(@"self = %@", self);

    if ([self me_isVisible]) {
        DLog(@"self.floatingButtonDelegate = %@", self.floatingButtonDelegate);
        if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonDidAppear:)]) {
            [self.floatingButtonDelegate floatingButtonDidAppear:self];
        }
    }
    
  
}

- (void)me_willDisappear
{
    self.floatingButton.buttonState = FloatingButtonStateWillDisappear;

    if ([self me_isVisible]) {
        DLog(@"self.floatingButtonDelegate = %@", self.floatingButtonDelegate);
        if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonWillDisappear:)]) {
            [self.floatingButtonDelegate floatingButtonWillDisappear:self];
        }
    }
}

- (void)me_didDisappear
{
    self.floatingButton.buttonState = FloatingButtonStateDidDisappear;
    self.floatingButton.hidden = YES;

    if ([self me_isVisible]) {
        DLog(@"self.floatingButtonDelegate = %@", self.floatingButtonDelegate);
        if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonDidDisappear:)]) {
            [self.floatingButtonDelegate floatingButtonDidDisappear:self];
        }
    }
}

- (void)me_didTapDataButton:(id)sender
{
    if ([self me_hideOnTap] && self.floatingButton.displayMode != MEFloatingButtonDisplayModeAlways) {
        [self me_hideFloatingButtonView];
    }
    
    if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButton:didTapButton:)]) {
        [self.floatingButtonDelegate floatingButton:self didTapButton:sender];
    }
}


#pragma mark - Layout Methods (Private)

- (void)me_validateView
{
    DLog(@"me_validateView");

    if (![self me_canDisplay]) {
        return;
    }
    
    if ([self me_shouldDisplay]) {
        
        MEFloatingButton *view = self.floatingButton;
        
        if (!view.superview) {
            // Send the view all the way to the back, in case a header and/or footer is present, as well as for sectionHeaders or any other content
            [self addSubview:view];
        }
        
        // Removing view resetting the view and its constraints it very important to guarantee a good state
        [view prepareForReuse];
        
        // Get the data from the data source
        UIImage *buttonImage = [self me_buttonImageForState:UIControlStateNormal];
        UIColor *buttonTintColor = [self me_buttonTintColor];
        UIColor *buttonBackgroundColor = [self me_buttonBackgroundColor];
        CGFloat buttonImagePadding = [self me_buttonImagePadding];
        
        // Configure button
        if (buttonImage) {
            [view.button setFrame:CGRectMake(0, 0, buttonImage.size.width + buttonImagePadding*2, buttonImage.size.height + buttonImagePadding*2)];
            [view.button setContentMode:UIViewContentModeCenter];
            if (buttonTintColor) {
                [view.button setImage:[buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                [view.button setImage:[[self me_buttonImageForState:UIControlStateHighlighted] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
                [view setTintColor:buttonTintColor];
            } else {
                [view.button setImage:buttonImage forState:UIControlStateNormal];
                [view.button setImage:[self me_buttonImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
            }
            if (buttonBackgroundColor) {
                [view.button setBackgroundColor:buttonBackgroundColor];
            }
        }
        
        // Configure offset
        view.verticalOffset = [self me_verticalOffset];
        
        // Configure the floating button view
        view.backgroundColor = [UIColor clearColor];
        view.clipsToBounds = YES;
        
        // Configure floating button userInteraction permission
        view.userInteractionEnabled = YES;
        
        // Configure animation type
        view.animationType = [self me_animationType];
        
        // Configure display mode
        view.displayMode = [self me_displayMode];
        
        [view setupConstraints];
        
//        switch (self.floatingButton.buttonDisplayMode) {
//            case MEFloatingButtonDisplayModeAlways:
//                view.hidden = NO;
//                break;
//            case MEFloatingButtonDisplayModeWhenScrolling:
//                view.hidden = YES;
//                break;
//            case FloatingButtonDisplayModeWhenScrollingDownOnly:
//                view.hidden = YES;
//                break;
//            case FloatingButtonDisplayModeWhenScrollingUpOnly:
//                view.hidden = YES;
//                break;
//            default:
//                break;
//        }
        
    } else if (self.isFloatingButtonVisible) {
        [self me_invalidateView];
    }
}

- (void)me_invalidateView
{
    DLog(@"");
    
    if (self.floatingButton) {
        [self.floatingButton prepareForReuse];
        [self.floatingButton removeFromSuperview];
        
        [self setFloatingButtonView:nil];
    }
}

-(void)me_showFloatingButtonView
{
    DLog(@"");

    [self stopTimer];
    [self startTimer];
    
    if ([self me_canDisplay]) {
        
        // State
        [self me_willAppear];
        
        switch (self.floatingButton.animationType) {
            case MEFloatingButtonAnimationNone:
                [self fadeInView:NO];
                break;
            case MEFloatingButtonAnimationFadeIn:
                [self fadeInView:YES];
                break;
            case MEFloatingButtonAnimationFromBottom:
                [self animateInView];
                break;
                
            default:
                break;
        }
    }
}

-(void)me_hideFloatingButtonView
{
    DLog(@"");

    [self stopTimer];
    
    if ([self me_canDisplay]) {
        
        // State
        [self me_willDisappear];
        
        switch (self.floatingButton.animationType) {
            case MEFloatingButtonAnimationNone:
                [self fadeOutView:NO];
                break;
            case MEFloatingButtonAnimationFadeIn:
                [self fadeOutView:YES];
                break;
            case MEFloatingButtonAnimationFromBottom:
                [self animateOutView];
                break;
                
            default:
                break;
        }
    }
}

- (void)me_repositionFloatingButtonViewFrame:(CGPoint)point
{
    DLog(@"");

    CGRect fixedFrame = self.floatingButton.frame;
    fixedFrame.origin.y = point.y;
    [self.floatingButton setFrame:fixedFrame];
}


#pragma mark - KVO Methods (Private)

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"self.floatingButtonDelegate = %@", self.floatingButtonDelegate);

    if ([keyPath isEqualToString:kObserverFrame]) {
        DLog(@"kObserverFrame");

        if (![self me_canDisplay]) {
            [self me_invalidateView];
        }
        
        [self me_validateView];

    } else if ([keyPath isEqualToString:kObserverContentOffset]) {
        DLog(@"kObserverContentOffset");

        if ([self me_canDisplay]) {
            
            [self bringSubviewToFront:self.floatingButton];
            
            if (self.floatingButton.displayMode == MEFloatingButtonDisplayModeAlways) {
                [self.floatingButton setHidden:NO];
                [self me_repositionFloatingButtonViewFrame:((UITableView *)object).contentOffset];
                
            } else {
                
                [self stopTimer];
                [self startTimer];
                
                switch (self.floatingButton.buttonState) {
                    case FloatingButtonStateWillAppear:
                        [self me_repositionFloatingButtonViewFrame:((UITableView *)object).contentOffset];
                        break;
                        
                    case FloatingButtonStateDidAppear:
                        [self me_repositionFloatingButtonViewFrame:((UITableView *)object).contentOffset];
                        break;
                        
                    case FloatingButtonStateWillDisappear:
                        if (self.floatingButton.animationType == MEFloatingButtonAnimationFadeIn) {
                            [self me_repositionFloatingButtonViewFrame:((UITableView *)object).contentOffset];
                        }
                        break;
                        
                    case FloatingButtonStateDidDisappear:
                        [self me_showFloatingButtonView];
                        break;
                        
                    default:
                        break;
                }
            }
        }
    }
}


#pragma mark - Timer Methods (Private)

- (void)stopTimer
{
    DLog(@"");

    [self.floatingButton.fadeOutTimer invalidate];
    self.floatingButton.fadeOutTimer = nil;

}

- (void)startTimer
{
    DLog(@"");

    self.floatingButton.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:kFloatingButtonDefaultFadingDurationTime target:self selector:@selector(me_hideFloatingButtonView) userInfo:nil repeats:YES];
}

#pragma mark - Animation Methods (Private)

- (void)fadeInView:(BOOL)animated
{
    DLog(@"");

    [UIView animateWithDuration:animated ? kFloatingButtonDefaultFadingAnimationTime : 0.0f
                     animations:^{
                         [self.floatingButton setAlpha:1];
                     } completion:^(BOOL finished) {
                         [self me_didAppear];
                     }];
}

- (void)fadeOutView:(BOOL)animated
{
    DLog(@"");

    [UIView animateWithDuration:animated ? kFloatingButtonDefaultFadingAnimationTime : 0.0f
                     animations:^{
                         [self.floatingButton setAlpha:0.0];
                     } completion:^(BOOL finished) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                             [self me_didDisappear];
                         });
                     }];
}

- (void)animateInView
{
    DLog(@"");

    CGRect frame = self.floatingButton.frame;
    CGPoint finalPosition = CGPointMake(0, self.frame.size.height - self.floatingButton.frame.size.height - self.floatingButton.verticalOffset);
    CGPoint previousPosition = CGPointMake(finalPosition.x, finalPosition.y + self.floatingButton.frame.size.height + self.floatingButton.verticalOffset);
    [self.floatingButton setFrame:CGRectMake(previousPosition.x, previousPosition.y, frame.size.width, frame.size.height)];

    [UIView animateWithDuration:kFloatingButtonDefaultFromBottomAnimationTime
                     animations:^{
                         [self.floatingButton setFrame:CGRectMake(finalPosition.x, finalPosition.y, frame.size.width, frame.size.height)];
                     } completion:^(BOOL finished) {
                         [self me_didAppear];
                     }];
}

- (void)animateOutView
{
    DLog(@"");

    CGRect frame = self.floatingButton.frame;
    frame.origin.y += self.floatingButton.frame.size.height + self.floatingButton.verticalOffset;

    [UIView animateWithDuration:kFloatingButtonDefaultFromBottomAnimationTime
                     animations:^{
                         [self.floatingButton setFrame:frame];
                     } completion:^(BOOL finished) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                             [self me_didDisappear];
                         });
                     }];
}


#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isEqual:self.floatingButton]) {
        return YES;
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    UIGestureRecognizer *tapGesture = self.floatingButton.tapGesture;
    
    if ([gestureRecognizer isEqual:tapGesture] || [otherGestureRecognizer isEqual:tapGesture]) {
        return YES;
    }
    
    // defer to scrollToTopDelegate's implementation if available
    if ( (self.floatingButtonDelegate != (id)self) && [self.floatingButtonDelegate respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]) {
        return [(id)self.floatingButtonDelegate gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }
    
    return NO;
}

@end



