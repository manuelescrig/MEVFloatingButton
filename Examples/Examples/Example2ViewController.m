//
//  Example2ViewController.m
//  Examples
//
//  Created by Manuel Escrig Ventura on 09/02/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//

#import "Example2ViewController.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface Example2ViewController () <MEFloatingButtonSource, MEFloatingButtonDelegate>

@end

@implementation Example2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Example 2";

    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.floatingButtonDelegate = self;
    self.tableView.floatingButtonSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"Cell section [%zd] row [%zd]", indexPath.section, indexPath.row];
    return cell;
}


#pragma mark - MEScrollToTopSource Methods

- (BOOL)floatingButtonShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)floatingButtonHideOnTap:(UIScrollView *)scrollView {
    return YES;
}
- (UIImage *)buttonImageForFloatingButton:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [UIImage imageNamed:@"UpArrow"];
}

- (UIColor *)buttonTintColorForFloatingButton:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

- (UIColor *)buttonBackgroundColorForFloatingButton:(UIScrollView *)scrollView {
    return [UIColor colorWithRed:147/255.0 green:193/255.0 blue:49/255.0 alpha:1];
}

- (CGFloat)buttonImagePaddingForFloatingButton:(UIScrollView *)scrollView {
    return 10;
}

- (CGFloat)verticalOffsetForFloatingButton:(UIScrollView *)scrollView {
    return 10;
}

- (MEFloatingButtonAnimation)animationTypeForFloatingButton:(UIScrollView *)scrollView {
    return MEFloatingButtonAnimationFadeIn;
}

- (MEFloatingButtonDisplayMode)displayModeForFloatingButton:(UIScrollView *)scrollView {
    return MEFloatingButtonDisplayModeWhenScrolling;
}


#pragma mark - MEScrollToTopDelegate Methods

- (void)floatingButton:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    NSLog(@"didTapButton");
    [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
}

- (void)floatingButtonWillAppear:(UIScrollView *)scrollView {
    NSLog(@"floatingButtonWillAppear");
}

- (void)floatingButtonDidAppear:(UIScrollView *)scrollView {
    NSLog(@"floatingButtonDidAppear");
}

- (void)floatingButtonWillDisappear:(UIScrollView *)scrollView {
    NSLog(@"floatingButtonWillDisappear");
}

- (void)floatingButtonDidDisappear:(UIScrollView *)scrollView; {
    NSLog(@"floatingButtonDidDisappear");
}

@end