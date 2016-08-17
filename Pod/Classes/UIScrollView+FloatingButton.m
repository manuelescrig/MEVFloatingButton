//
//  UIScrollView+FloatingButton.m
//  A drop-in UITableView/UICollectionView/UIScrollView superclass category for showing a floating button on top of it.
//
//  https://github.com/manuelescrig/MEVFloatingButton
//
//  Created by Manuel Escrig Ventura on 27/01/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//  Licence: MIT-Licence
//

#import "UIScrollView+FloatingButton.h"
#import <objc/runtime.h>
#import <objc/message.h>


static float const kMEFlatingButtonDefaultOutlineWidth = 0.0f;
static float const kMEFlatingButtonDefaultImagePadding = 10.0f;
static float const kMEFlatingButtonDefaultHorizontalOffset = 0.0f;
static float const kMEFlatingButtonDefaultVerticalOffset = -20.0f;

typedef NS_ENUM(NSInteger, MEFloatingButtonState) {
    MEFloatingButtonStateWillAppear,
    MEFloatingButtonStateDidAppear,
    MEFloatingButtonStateWillDisappear,
    MEFloatingButtonStateDidDisappear
};


@interface MEVFloatingButton ()

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIButton *button;
@property (nonatomic, strong) NSTimer *fadeOutTimer;
@property (nonatomic, assign) MEFloatingButtonState buttonState;
@property (nonatomic, assign) float scrollThreshold;
@property (nonatomic, assign) BOOL valid;

@end

#pragma mark - MEVFloatingButton

@implementation MEVFloatingButton
@synthesize contentView = _contentView;
@synthesize button = _button;

#pragma mark - Initialization (private)

- (instancetype)init
{
    self =  [super init];
    if (self) {
        
        // Set as hidden when is created
        self.hidden = YES;
        
        // Default configuration
        _buttonState = MEFloatingButtonStateDidDisappear;
        _displayMode = MEVFloatingButtonDisplayModeAlways;
        _animationType = MEVFloatingButtonAnimationNone;
        _position = MEVFloatingButtonPositionBottomCenter;
        _imageColor = [UIColor whiteColor];
        _backgroundColor = [UIColor blueColor];
        _shadowColor = [UIColor clearColor];
        _shadowOffset = CGSizeMake(0, 0);
        _shadowOpacity = 1;
        _shadowRadius = 1;
        _outlineColor = [UIColor blueColor];
        _outlineWidth = kMEFlatingButtonDefaultOutlineWidth;
        _imagePadding = kMEFlatingButtonDefaultImagePadding;
        _horizontalOffset = kMEFlatingButtonDefaultHorizontalOffset;
        _verticalOffset = kMEFlatingButtonDefaultVerticalOffset;
        _rounded = NO;
        _hideWhenScrollToTop = NO;
        _valid = NO;
        
        [self addSubview:self.contentView];
    }
    return self;
}


#pragma mark - Setters (Public)

- (void)setDisplayMode:(MEVFloatingButtonDisplayMode)displayMode {
    if (displayMode == MEVFloatingButtonDisplayModeNone ||
        displayMode == MEVFloatingButtonDisplayModeAlways ||
        displayMode == MEVFloatingButtonDisplayModeWhenScrolling) {
        _displayMode = displayMode;
    } else {
        NSAssert(NO, @"You must assign a valid MEVFloatingButtonDisplayMode type for -setDisplayMode:");
    }
}
- (void)setAnimationType:(MEVFloatingButtonAnimation)animationType {
    if (animationType == MEVFloatingButtonAnimationNone ||
        animationType == MEFloatingButtonAnimationFadeIn ||
        animationType == MEVFloatingButtonAnimationFromBottom) {
        _animationType = animationType;
    } else {
        NSAssert(NO, @"You must assign a valid MEVFloatingButtonAnimation type for -setAnimationType:");
    }
}

- (void)setPosition:(MEVFloatingButtonPosition)position {
    if (position == MEVFloatingButtonPositionBottomCenter ||
        position == MEVFloatingButtonPositionBottomLeft ||
        position == MEVFloatingButtonPositionBottomRight) {
        _position = position;
    } else {
        NSAssert(NO, @"You must assign a valid MEVFloatingButtonPosition type for -setPosition:");
    }
}

- (void)setImage:(UIImage *)image {
    NSAssert(image != nil, @"You must assign a valid UIImage object for -setImage:");
    _image = image;
}

- (void)setImageColor:(UIColor *)imageColor {
    NSAssert(imageColor != nil, @"You must assign a valid UIColor object for -setImageColor:");
    _imageColor = imageColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSAssert(backgroundColor != nil, @"You must assign a valid UIColor object for -setBackgroundColor:");
    _backgroundColor = backgroundColor;
}

- (void)setOutlineColor:(UIColor *)outlineColor {
    NSAssert(outlineColor != nil, @"You must assign a valid UIColor object for -setOutlineColor:");
    _outlineColor = outlineColor;
}

- (void)setOutlineWidth:(float)outlineWidth  {
    if (outlineWidth) NSAssert(outlineWidth >= 0, @"You must assign a valid CGFloat object for -setOutlineWidth:");
    _outlineWidth = outlineWidth;
}

- (void)setImagePadding:(float)imagePadding {
    if (imagePadding) NSAssert(imagePadding >= 0, @"You must assign a valid CGFloat object for -setImagePadding:");
    _imagePadding = imagePadding;
}

- (void)setHorizontalOffset:(float)horizontalOffset {
    _horizontalOffset = horizontalOffset;
}

- (void)setVerticalOffset:(float)verticalOffset  {
    _verticalOffset = verticalOffset;
}

- (void)setRounded:(BOOL)rounded {
    _rounded = rounded;
}


#pragma mark - Getters (Private)

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.userInteractionEnabled = YES;
        _button.backgroundColor =  _backgroundColor;
        _button.tintColor = _imageColor;
        _button.layer.masksToBounds = NO;
        _button.layer.shadowColor = _shadowColor.CGColor;
        _button.layer.shadowOffset = _shadowOffset;
        _button.layer.shadowOpacity = _shadowOpacity;
        _button.layer.shadowRadius = _shadowRadius;
        _button.layer.borderColor = _outlineColor.CGColor;
        _button.layer.borderWidth = _outlineWidth;
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.contentMode = UIViewContentModeCenter;
        _button.accessibilityIdentifier = @"floating button";
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_button];
    }
    return _button;
}


#pragma mark - Action Methods (Private)

- (void)didTapButton:(id)sender
{
    SEL selector = NSSelectorFromString(@"mev_didTapDataButton:");
    
    if ([self.superview respondsToSelector:selector]) {
        [self.superview performSelector:selector withObject:sender afterDelay:0.0f];
    }
}


#pragma mark - Layout Methods (Private)

- (void)setupConstraints
{
    self.frame = self.superview.bounds;
    
    _contentView.frame = CGRectMake(0, 0, _button.frame.size.width, _button.frame.size.width);
    switch (_position) {
        case MEVFloatingButtonPositionBottomCenter:
            _contentView.center = CGPointMake(self.center.x, self.frame.size.height - (_button.frame.size.height/2) + _verticalOffset);
            break;
        case MEVFloatingButtonPositionBottomRight:
            _contentView.center = CGPointMake(self.frame.size.width - (_button.frame.size.width/2) + _horizontalOffset, self.frame.size.height - (_button.frame.size.height/2) + _verticalOffset);
            break;
        case MEVFloatingButtonPositionBottomLeft:
            _contentView.center = CGPointMake(self.frame.origin.x + (_button.frame.size.width/2) + _horizontalOffset, self.frame.size.height - (_button.frame.size.height/2) + _verticalOffset);
            break;
        default:
            break;
    }
}


#pragma mark - Gestures Methods (Private)

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

static char const *const kFloatingButtonDelegate = "floatingButtonDelegate";
static char const *const kFloatingButtonView = "floatingButton";

static NSString *const kObserverContentOffset = @"contentOffset";
static NSString *const kObserverContentSize = @"contentSize";
static NSString *const kObserverFrame = @"frame";

static float const kFloatingButtonDefaultTime = 2.0f;

static float const kFloatingButtonDefaultFadingAnimationTime = 0.3f;
static float const kFloatingButtonDefaultFromBottomAnimationTime = 0.6f;


@implementation UIScrollView (FloatingButton)


#pragma mark - Initialization (private)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // Swizzle
        Swizzle([self class], NSSelectorFromString(@"dealloc"), @selector(mev_dealloc));
        Swizzle([self class], @selector(willMoveToWindow:), @selector(mev_willMoveToWindow:));
        Swizzle([self class], @selector(didMoveToWindow), @selector(mev_didMoveToWindow));
    });
}


#pragma mark - An a little bit of swizzling (private)

void Swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

- (void)mev_dealloc
{    
    @try {
        [self removeObserver:self forKeyPath:kObserverContentOffset context:nil];
        [self removeObserver:self forKeyPath:kObserverContentSize context:nil];
        [self removeObserver:self forKeyPath:kObserverFrame context:nil];
    } @catch(id exception) {
        // Do nothing, obviously it wasn't attached because an exception was thrown
    }
    
    // This calls original dealloc method
    [self mev_dealloc];
}


- (void)mev_willMoveToWindow:(UIWindow *)newWindow
{
    if (!newWindow) {
        if (self.floatingButton.displayMode != MEVFloatingButtonDisplayModeAlways &&
            self.floatingButton.displayMode != MEVFloatingButtonDisplayModeNone) {
            [self mev_stopTimer];
            [self mev_didDisappear];
        }
    }
    
    [self mev_willMoveToWindow:newWindow];
}

- (void)mev_didMoveToWindow
{
    [self mev_didMoveToWindow];
}


#pragma mark - Setters (Public)

- (void)setFloatingButtonDelegate:(id<MEVFloatingButtonDelegate>)floatingButtonDelegate
{
    objc_setAssociatedObject(self, kFloatingButtonDelegate, floatingButtonDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setFloatingButtonView:(MEVFloatingButton *)floatingButton
{
    objc_setAssociatedObject(self, kFloatingButtonView, floatingButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Add observers
    [self addObserver:self forKeyPath:kObserverContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:kObserverContentSize options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:kObserverFrame options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}


#pragma mark - Getters (Public)

- (id<MEVFloatingButtonDelegate>)floatingButtonDelegate
{
    return objc_getAssociatedObject(self, kFloatingButtonDelegate);
}


#pragma mark - Getters (Private)

- (MEVFloatingButton *)floatingButton
{
   return objc_getAssociatedObject(self, kFloatingButtonView);
}


#pragma mark - Delegate Events (Private)

- (void)mev_willAppear
{
    self.floatingButton.buttonState = MEFloatingButtonStateWillAppear;
    self.floatingButton.hidden = NO;

    if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonWillAppear:)]) {
        [self.floatingButtonDelegate floatingButtonWillAppear:self];
    }
}

- (void)mev_didAppear
{
    self.floatingButton.buttonState = MEFloatingButtonStateDidAppear;

    if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonDidAppear:)]) {
        [self.floatingButtonDelegate floatingButtonDidAppear:self];
    }
}

- (void)mev_willDisappear
{
    self.floatingButton.buttonState = MEFloatingButtonStateWillDisappear;

    if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonWillDisappear:)]) {
        [self.floatingButtonDelegate floatingButtonWillDisappear:self];
    }
}

- (void)mev_didDisappear
{
    self.floatingButton.buttonState = MEFloatingButtonStateDidDisappear;
    self.floatingButton.hidden = YES;
    
    if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonDidDisappear:)]) {
        [self.floatingButtonDelegate floatingButtonDidDisappear:self];
    }
}

- (void)mev_didTapDataButton:(id)sender
{
    if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButton:didTapButton:)]) {
        [self.floatingButtonDelegate floatingButton:self didTapButton:sender];
    }
}


#pragma mark - Layout Methods (Private)

- (BOOL)mev_canDisplay
{
    BOOL canDisplay = NO;
    
    if ([self.floatingButton displayMode] != MEVFloatingButtonDisplayModeNone && [self floatingButton]) {
        canDisplay = YES;
    }
    
    return canDisplay;
}

- (void)mev_validateView
{
    if ([self mev_canDisplay]) {
       
        MEVFloatingButton *view = [self floatingButton];
        
        if (!view.superview) {
            // Send the view all the way to the back, in case a header and/or footer is present, as well as for sectionHeaders or any other content
            [self addSubview:view];
        }
        
        // Configure button
        if (view.image) {
            [view.button setFrame:CGRectMake(0, 0, view.image.size.width + view.imagePadding*2, view.image.size.height + view.imagePadding*2)];
            if (view.imageColor) {
                [view.button setImage:[view.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            } else {
                [view.button setImage:view.image forState:UIControlStateNormal];
            }
            if ([view isRounded]) {
                view.button.layer.cornerRadius = view.button.frame.size.width/2;
            }
        } else {
            NSAssert(NO, @"You must assign a valid UIImage type for -setImage:");
        }
        
        if (view.displayMode == MEVFloatingButtonDisplayModeAlways) {
            [self mev_showFloatingButtonView];
        }
        
        [view setupConstraints];
        
        [self.floatingButton setValid:YES];
    }
}

- (BOOL)mev_isViewValid
{
    return [self.floatingButton valid];
}

-(void)mev_showFloatingButtonView
{
    if (self.floatingButton.buttonState == MEFloatingButtonStateDidDisappear) {
      
        [self mev_willAppear];

        switch (self.floatingButton.animationType) {
            case MEVFloatingButtonAnimationNone:
                [self mev_fadeInView:NO];
                break;
            case MEFloatingButtonAnimationFadeIn:
                [self mev_fadeInView:YES];
                break;
            case MEVFloatingButtonAnimationFromBottom:
                [self mev_animateInView];
                break;
                
            default:
                break;
        }
    }
}

-(void)mev_hideFloatingButtonView
{
    [self mev_stopTimer];

    if (self.floatingButton.buttonState == MEFloatingButtonStateDidAppear) {
        
        [self mev_willDisappear];

        switch (self.floatingButton.animationType) {
            case MEVFloatingButtonAnimationNone:
                [self mev_fadeOutView:NO];
                break;
            case MEFloatingButtonAnimationFadeIn:
                [self mev_fadeOutView:YES];
                break;
            case MEVFloatingButtonAnimationFromBottom:
                [self mev_animateOutView];
                break;
                
            default:
                break;
        }
    }
}

- (void)mev_repositionFloatingButtonViewFrame:(CGPoint)point
{
    [self bringSubviewToFront:self.floatingButton];
    
    CGRect fixedFrame = self.floatingButton.frame;
    fixedFrame.origin.y = point.y;
    [self.floatingButton setFrame:fixedFrame];
}

#pragma mark - Timer Methods (Private)

- (void)mev_stopTimer
{
    [self.floatingButton.fadeOutTimer invalidate];
    self.floatingButton.fadeOutTimer = nil;
}

- (void)mev_startTimer
{
    self.floatingButton.fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:kFloatingButtonDefaultTime target:self selector:@selector(mev_hideFloatingButtonView) userInfo:nil repeats:YES];
}

#pragma mark - Animation Methods (Private)

- (void)mev_fadeInView:(BOOL)animated
{
    [UIView animateWithDuration:animated ? kFloatingButtonDefaultFadingAnimationTime : 0.0f
                     animations:^{
                         [self.floatingButton setAlpha:1];
                     } completion:^(BOOL finished) {
                         [self mev_didAppear];
                     }];
}

- (void)mev_fadeOutView:(BOOL)animated
{
    [UIView animateWithDuration:animated ? kFloatingButtonDefaultFadingAnimationTime : 0.0f
                     animations:^{
                         [self.floatingButton setAlpha:0.0];
                     } completion:^(BOOL finished) {
                     }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animated ? (kFloatingButtonDefaultFadingAnimationTime-0.4) : 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self mev_didDisappear];
    });
}

- (void)mev_animateInView
{
    CGRect frame = self.floatingButton.frame;
    CGPoint finalPosition = CGPointMake(0, self.frame.size.height - self.floatingButton.frame.size.height - self.floatingButton.verticalOffset);
    CGPoint previousPosition = CGPointMake(finalPosition.x, finalPosition.y + self.floatingButton.frame.size.height + self.floatingButton.verticalOffset);
    [self.floatingButton setFrame:CGRectMake(previousPosition.x, previousPosition.y, frame.size.width, frame.size.height)];
    
    [UIView animateWithDuration:kFloatingButtonDefaultFromBottomAnimationTime
                     animations:^{
                         [self.floatingButton setFrame:CGRectMake(finalPosition.x, finalPosition.y, frame.size.width, frame.size.height)];
                     } completion:^(BOOL finished) {
                         [self mev_didAppear];
                     }];
}

- (void)mev_animateOutView
{
    CGRect frame = self.floatingButton.frame;
    frame.origin.y += self.floatingButton.frame.size.height + self.floatingButton.verticalOffset;
    
    [UIView animateWithDuration:kFloatingButtonDefaultFromBottomAnimationTime
                     animations:^{
                         [self.floatingButton setFrame:frame];
                     } completion:^(BOOL finished) {
                     }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (kFloatingButtonDefaultFromBottomAnimationTime-0.4) * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self mev_didDisappear];
    });
}

#pragma mark - KVO Methods (Private)

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kObserverFrame] || [self mev_isViewValid] == NO) {
        [self mev_validateView];
        
    } else if ([keyPath isEqualToString:kObserverContentOffset]) {

        if (!CGRectEqualToRect(self.floatingButton.frame, CGRectZero) && self.window) {
            
            if ([self.floatingButton isHideWhenScrollToTop] && self.contentOffset.y <= 0) {
                [self mev_hideFloatingButtonView];
                
            } else {
                
                switch (self.floatingButton.displayMode) {
                    case MEVFloatingButtonDisplayModeAlways:
                        [self mev_repositionFloatingButtonViewFrame:((UITableView *)object).contentOffset];
                        break;
                        
                    case MEVFloatingButtonDisplayModeWhenScrolling: {
                        
                        CGPoint new = [[change valueForKey:@"new"] CGPointValue];
                        CGPoint old = [[change valueForKey:@"old"] CGPointValue];
                        if (new.y != old.y) {
                            self.floatingButton.scrollThreshold += 1;
                            if (self.floatingButton.scrollThreshold > 10) {
                                self.floatingButton.scrollThreshold = 0;
                                [self mev_showFloatingButtonView];
                            }
                        }
                        
                        if (self.floatingButton.buttonState != MEFloatingButtonStateDidDisappear) {
                            [self mev_stopTimer];
                            [self mev_startTimer];
                            [self mev_repositionFloatingButtonViewFrame:((UITableView *)object).contentOffset];
                        }
                    } break;
                        
                    default:
                        break;
                }
            }
        }
    }
}


@end
