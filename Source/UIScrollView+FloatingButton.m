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
@property (nonatomic, strong) NSTimer *fadeOutTimer;
@property (nonatomic, assign) FloatingButtonState buttonState;

- (void)setupConstraints;
- (void)prepareForReuse;

@end

#pragma mark - MEFloatingButton

@implementation MEFloatingButton
@synthesize contentView = _contentView;
@synthesize button = _button;

#pragma mark - Initialization Methods

- (instancetype)init
{
    DLog(@"");

    self =  [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}


#pragma mark - Getters

- (UIView *)contentView
{
    DLog(@"");

    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor redColor];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UIButton *)button
{
    DLog(@"");

    if (!_button) {
        _button = [[UIButton alloc] init];
//        _button.backgroundColor = _backgroundColor;
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.accessibilityIdentifier = @"floating button";
        _button.userInteractionEnabled = YES;
        [_button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_button];
    }
    return _button;
}



#pragma mark - Action Methods

- (void)didTapButton:(id)sender
{
    DLog(@"");

    SEL selector = NSSelectorFromString(@"me_didTapDataButton:");
    
    if ([self.superview respondsToSelector:selector]) {
        [self.superview performSelector:selector withObject:sender afterDelay:0.0f];
    }
}


#pragma mark - Layout Configuration

- (void)setupConstraints
{
    DLog(@"");

    self.frame = self.superview.bounds;
    [self.button.layer setCornerRadius:_button.frame.size.width/2];
    [self.contentView setFrame:CGRectMake(0, 0, _button.frame.size.width, _button.frame.size.width)];
    [self.contentView setCenter:CGPointMake(self.center.x, self.frame.size.height - self.button.frame.size.height - self.verticalOffset)];
}

- (void)prepareForReuse
{
    DLog(@"");

    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _button = nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    DLog(@"");

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


@implementation UIScrollView (FloatingButton)

+ (void)load
{
    DLog(@"load");
    
    Method origMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method newMethod = class_getInstanceMethod([self class], @selector(my_dealloc));
    method_exchangeImplementations(origMethod, newMethod);
}

- (void)my_dealloc {
    DLog(@"my_dealloc");
    
    @try {
        [self removeObserver:self forKeyPath:kObserverContentOffset context:nil];
        [self removeObserver:self forKeyPath:kObserverFrame context:nil];
    } @catch(id exception) {
        //do nothing, obviously it wasn't attached because an exception was thrown
        DLog(@"exception - %@", exception);
    }
    
    // This calls original dealloc method
    [self my_dealloc];
}


#pragma mark - Setters (Public)

- (void)setFloatingButtonSource:(id<MEFloatingButtonSource>)floatingButtonSource
{
    DLog(@"");

    if (!floatingButtonSource) {
        [self me_invalidateView];
    }
    
    objc_setAssociatedObject(self, kFloatingButtonSource, floatingButtonSource, OBJC_ASSOCIATION_ASSIGN);
    
    [self me_validateView];
}

- (void)setFloatingButtonDelegate:(id<MEFloatingButtonDelegate>)floatingButtonDelegate
{
    DLog(@"");

    if (!floatingButtonDelegate) {
        [self me_invalidateView];
    }
    
    objc_setAssociatedObject(self, kFloatingButtonDelegate, floatingButtonDelegate, OBJC_ASSOCIATION_ASSIGN);
    
    // Add observer to be notified when scrolling
    [self addObserver:self forKeyPath:kObserverContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    // Add observer to be notified when frame changes
    [self addObserver:self forKeyPath:kObserverFrame options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)setFloatingButtonView:(MEFloatingButton *)view
{
    DLog(@"");
    objc_setAssociatedObject(self, kFloatingButtonView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



#pragma mark - Getters (Public)

- (id<MEFloatingButtonSource>)floatingButtonSource
{
    DLog(@"");

    return objc_getAssociatedObject(self, kFloatingButtonSource);
}

- (id<MEFloatingButtonDelegate>)floatingButtonDelegate
{
    DLog(@"");

    return objc_getAssociatedObject(self, kFloatingButtonDelegate);
}


#pragma mark - Getters (Private)

- (MEFloatingButton *)floatingButton
{
    DLog(@"");

    MEFloatingButton *view = objc_getAssociatedObject(self, kFloatingButtonView);

    if (view == nil) {
        
        view = [MEFloatingButton new];
        view.hidden = YES;
        [self setFloatingButtonView:view];
    }
    
    return view;
}


#pragma mark - DataSource Getters (Private)

- (BOOL)me_shouldDisplay
{
    DLog(@"");

    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(floatingButtonShouldDisplay:)]) {
        return [self.floatingButtonSource floatingButtonShouldDisplay:self];
    }
    return YES;
}

- (BOOL)me_hideOnTap
{
    DLog(@"");

    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(floatingButtonShouldDisplay:)]) {
        return [self.floatingButtonSource floatingButtonHideOnTap:self];
    }
    return NO;
}

- (UIImage *)me_buttonImageForState:(UIControlState)state
{
    DLog(@"");

    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(buttonImageForFloatingButton:forState:)]) {
        UIImage *image = [self.floatingButtonSource buttonImageForFloatingButton:self forState:state];
        if (image) NSAssert([image isKindOfClass:[UIImage class]], @"You must return a valid UIImage object for -buttonImageForFloatingButton:forState:");
        return image;
    }
    return nil;
}

- (UIColor *)me_buttonTintColor
{
    DLog(@"");

    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(buttonTintColorForFloatingButton:)]) {
        UIColor *color = [self.floatingButtonSource buttonTintColorForFloatingButton:self];
        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object for -buttonTintColorForFloatingButton:");
        return color;
    }
    return nil;
}

- (UIColor *)me_buttonBackgroundColor
{
    DLog(@"");

    
   return [self floatingButton].backgroundColor;
   
    
//    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(buttonBackgroundColorForFloatingButton:)]) {
//        UIColor *color = [self.floatingButtonSource buttonBackgroundColorForFloatingButton:self];
//        if (color) NSAssert([color isKindOfClass:[UIColor class]], @"You must return a valid UIColor object for -buttonBackgroundColorForFloatingButton:");
//        return color;
//    }
//    return nil;
}

- (CGFloat)me_buttonImagePadding
{
    DLog(@"");

    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(buttonImagePaddingForFloatingButton:)]) {
        CGFloat size = [self.floatingButtonSource buttonImagePaddingForFloatingButton:self];
        if (size) NSAssert(size >= 0, @"You must return a valid CGFloat object for -buttonImagePaddingForFloatingButton:");
        return size;
    }
    return kFloatingButtonDefaultImagePadding;
}


- (CGFloat)me_verticalOffset
{
    DLog(@"");

    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(verticalOffsetForFloatingButton:)]) {
        CGFloat offset = [self.floatingButtonSource verticalOffsetForFloatingButton:self];
        if (offset) NSAssert(offset >= 0, @"You must return a valid CGFloat object for -verticalOffsetForFloatingButton:");
        return offset;
    }
    return kFloatingButtonDefaultOffset;
}

- (FloatingButtonAnimation)me_animationType
{
    DLog(@"");

    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(animationTypeForFloatingButton:)]) {
        return [self.floatingButtonSource animationTypeForFloatingButton:self];
    }
    return MEFloatingButtonAnimationFadeIn;
}

- (MEFloatingButtonDisplayMode)me_displayMode
{
    DLog(@"");

    if (self.floatingButtonSource && [self.floatingButtonSource respondsToSelector:@selector(displayModeForFloatingButton:)]) {
        return [self.floatingButtonSource displayModeForFloatingButton:self];
    }
    return MEFloatingButtonDisplayModeWhenScrolling;
}


#pragma mark - Delegate Events (Private)

- (void)me_willAppear
{
    DLog(@"self.floatingButtonDelegate = %@", self.floatingButtonDelegate);
    self.floatingButton.buttonState = FloatingButtonStateWillAppear;
    self.floatingButton.hidden = NO;

    if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonWillAppear:)]) {
        [self.floatingButtonDelegate floatingButtonWillAppear:self];
    }
}

- (void)me_didAppear
{
    DLog(@"self.floatingButtonDelegate = %@", self.floatingButtonDelegate);
    self.floatingButton.buttonState = FloatingButtonStateDidAppear;

    if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonDidAppear:)]) {
        [self.floatingButtonDelegate floatingButtonDidAppear:self];
    }
}

- (void)me_willDisappear
{
    DLog(@"self.floatingButtonDelegate = %@", self.floatingButtonDelegate);
    self.floatingButton.buttonState = FloatingButtonStateWillDisappear;

    if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonWillDisappear:)]) {
        [self.floatingButtonDelegate floatingButtonWillDisappear:self];
    }
}

- (void)me_didDisappear
{
    DLog(@"self.floatingButtonDelegate = %@", self.floatingButtonDelegate);
    self.floatingButton.buttonState = FloatingButtonStateDidDisappear;
    self.floatingButton.hidden = YES;

    if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButtonDidDisappear:)]) {
        [self.floatingButtonDelegate floatingButtonDidDisappear:self];
    }
}

- (void)me_didTapDataButton:(id)sender
{
    DLog(@"self.floatingButtonDelegate = %@", self.floatingButtonDelegate);
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
        
        
        // Configure floating button userInteraction permission
        view.userInteractionEnabled = YES;
        
        // Configure animation type
        view.animationType = [self me_animationType];
        
        // Configure display mode
        view.displayMode = [self me_displayMode];
        
        [view setupConstraints];
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

    // State
    [self me_willAppear];
    

    [self me_didAppear];
}

-(void)me_hideFloatingButtonView
{
    DLog(@"");
    
    // State
    [self me_willDisappear];
    

    [self me_didDisappear];
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
     
        [self me_invalidateView];
        [self me_validateView];

    } else if ([keyPath isEqualToString:kObserverContentOffset]) {
        DLog(@"kObserverContentOffset");

        [self bringSubviewToFront:self.floatingButton];
        self.floatingButton.hidden = NO;
        [self me_repositionFloatingButtonViewFrame:((UITableView *)object).contentOffset];
    }
}



@end
