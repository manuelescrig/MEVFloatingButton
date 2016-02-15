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

static float const kMEFlatingButtonDefaultOutlineWidth = 0.0f;
static float const kMEFlatingButtonDefaultImagePadding = 10.0f;
static float const kMEFlatingButtonDefaultHorizontalOffset = 0.0f;
static float const kMEFlatingButtonDefaultVerticalOffset = -20.0f;

typedef NS_ENUM(NSInteger, FloatingButtonState) {
    FloatingButtonStateWillAppear,
    FloatingButtonStateDidAppear,
    FloatingButtonStateWillDisappear,
    FloatingButtonStateDidDisappear
};


@interface MEFloatingButton ()

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIButton *button;
@property (nonatomic, strong) NSTimer *fadeOutTimer;
@property (nonatomic, assign) FloatingButtonState buttonState;

@end

#pragma mark - MEFloatingButton

@implementation MEFloatingButton
@synthesize contentView = _contentView;
@synthesize button = _button;

#pragma mark - Initialization Methods

- (instancetype)init
{
    self =  [super init];
    if (self) {
        
        // Default values
        _displayMode = MEFloatingButtonDisplayModeAlways; // TODO: to be  re-implemented.
        _animationType = MEFloatingButtonAnimationNone; // TODO: to be  re-implemented.
        _position = MEFloatingButtonPositionBottomCenter;
        _imageColor = [UIColor whiteColor];
        _backgroundColor = [UIColor blueColor];
        _outlineColor = [UIColor blueColor];
        _outlineWidth = kMEFlatingButtonDefaultOutlineWidth;
        _imagePadding = kMEFlatingButtonDefaultImagePadding;
        _horizontalOffset = kMEFlatingButtonDefaultHorizontalOffset;
        _verticalOffset = kMEFlatingButtonDefaultVerticalOffset;
        
        [self addSubview:self.contentView];
    }
    return self;
}

#pragma mark - Setters (Public)

- (void)setDisplayMode:(MEFloatingButtonDisplayMode)displayMode {
    if (displayMode == MEFloatingButtonDisplayModeNone ||
        displayMode == MEFloatingButtonDisplayModeAlways ||
        displayMode == MEFloatingButtonDisplayModeWhenScrolling) {
        _displayMode = displayMode;
    } else {
        NSAssert(NO, @"You must assign a valid MEFloatingButtonDisplayMode type for -setDisplayMode:");
    }
}
- (void)setAnimationType:(MEFloatingButtonAnimation)animationType {
    if (animationType == MEFloatingButtonAnimationNone ||
        animationType == MEFloatingButtonAnimationFadeIn ||
        animationType == MEFloatingButtonAnimationFromBottom) {
        _animationType = animationType;
    } else {
        NSAssert(NO, @"You must assign a valid MEFloatingButtonAnimation type for -setAnimationType:");
    }
}

- (void)setPosition:(MEFloatingButtonPosition)position {
    if (position == MEFloatingButtonPositionBottomCenter ||
        position == MEFloatingButtonPositionBottomLeft ||
        position == MEFloatingButtonPositionBottomRight) {
        _position = position;
    } else {
        NSAssert(NO, @"You must assign a valid MEFloatingButtonPosition type for -setPosition:");
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
    SEL selector = NSSelectorFromString(@"me_didTapDataButton:");
    
    if ([self.superview respondsToSelector:selector]) {
        [self.superview performSelector:selector withObject:sender afterDelay:0.0f];
    }
}


#pragma mark - Layout Methods (Private)

- (void)setupConstraints
{
    DLog(@"MEFloatingButton");

    self.frame = self.superview.bounds;
    _button.layer.cornerRadius = _button.frame.size.width/2;
    _contentView.frame = CGRectMake(0, 0, _button.frame.size.width, _button.frame.size.width);
    
    switch (_position) {
        case MEFloatingButtonPositionBottomCenter:
            _contentView.center = CGPointMake(self.center.x, self.frame.size.height - (_button.frame.size.height/2) + _verticalOffset);
            break;
        case MEFloatingButtonPositionBottomRight:
            _contentView.center = CGPointMake(self.frame.size.width - (_button.frame.size.width/2) + _horizontalOffset, self.frame.size.height - (_button.frame.size.height/2) + _verticalOffset);
            break;
        case MEFloatingButtonPositionBottomLeft:
            _contentView.center = CGPointMake(self.frame.origin.x + (_button.frame.size.width/2) + _horizontalOffset, self.frame.size.height - (_button.frame.size.height/2) + _verticalOffset);
            break;
        default:
            break;
    }
}


#pragma mark - Gestures Methods (Private)

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    DLog(@"MEFloatingButton");

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
static NSString *const kObserverFrame = @"frame";


@implementation UIScrollView (FloatingButton)

+ (void)load
{
    DLog(@"");
    
    Method origMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method newMethod = class_getInstanceMethod([self class], @selector(my_dealloc));
    method_exchangeImplementations(origMethod, newMethod);
}

- (void)my_dealloc {
    DLog(@"");
    
    @try {
        [self removeObserver:self forKeyPath:kObserverContentOffset context:nil];
        [self removeObserver:self forKeyPath:kObserverFrame context:nil];
    } @catch(id exception) {
        // Do nothing, obviously it wasn't attached because an exception was thrown
        DLog(@"exception - %@", exception);
    }
    
    // This calls original dealloc method
    [self my_dealloc];
}


#pragma mark - Setters (Public)

- (void)setFloatingButtonDelegate:(id<MEFloatingButtonDelegate>)floatingButtonDelegate
{
    DLog(@"");
    
    objc_setAssociatedObject(self, kFloatingButtonDelegate, floatingButtonDelegate, OBJC_ASSOCIATION_ASSIGN);
    
    // Add observer to be notified when scrolling
    [self addObserver:self forKeyPath:kObserverContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    // Add observer to be notified when frame changes
    [self addObserver:self forKeyPath:kObserverFrame options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)setFloatingButtonView:(MEFloatingButton *)floatingButton
{
    DLog(@"floatingButton = %@", floatingButton);
    
    objc_setAssociatedObject(self, kFloatingButtonView, floatingButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Getters (Public)

- (id<MEFloatingButtonDelegate>)floatingButtonDelegate
{
    DLog(@"");

    return objc_getAssociatedObject(self, kFloatingButtonDelegate);
}


#pragma mark - Getters (Private)

- (MEFloatingButton *)floatingButton
{
    MEFloatingButton *floatingButton = objc_getAssociatedObject(self, kFloatingButtonView);

    if (floatingButton == nil) {
        floatingButton = [[MEFloatingButton alloc] init];

        [self setFloatingButtonView:floatingButton];
    }
    
    return floatingButton;
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
//    if ([self me_hideOnTap] && self.floatingButton.displayMode != MEFloatingButtonDisplayModeAlways) {
//        [self me_hideFloatingButtonView];
//    }
    
    if (self.floatingButtonDelegate && [self.floatingButtonDelegate respondsToSelector:@selector(floatingButton:didTapButton:)]) {
        [self.floatingButtonDelegate floatingButton:self didTapButton:sender];
    }
}


#pragma mark - Layout Methods (Private)

- (void)me_validateView
{
    DLog(@"me_validateView");
    
    MEFloatingButton *view = [self floatingButton];
    if (view.displayMode != MEFloatingButtonDisplayModeNone) {
       
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
        } else {
            NSAssert(NO, @"You must assign a valid UIImage type for -setImage:");
        }

        [view setupConstraints];
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
     
        [self me_validateView];

    } else if ([keyPath isEqualToString:kObserverContentOffset]) {
        DLog(@"kObserverContentOffset");

        [self bringSubviewToFront:self.floatingButton];
        self.floatingButton.hidden = NO;
        [self me_repositionFloatingButtonViewFrame:((UITableView *)object).contentOffset];
    }
}



@end
