//
//  ViewController.m
//  Examples
//
//  Created by Manuel Escrig Ventura on 27/01/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//  Licence: MIT-Licence
//

#import "ViewController.h"
#import "UIScrollView+FloatingButton.h"

// Examples
#import "Example1ViewController.h"
#import "Example2ViewController.h"
#import "Example3ViewController.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface ViewController () <MEFloatingButtonSource, MEFloatingButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MEFloatingButton";
    
    self.tableView.floatingButtonDelegate = self;
    self.tableView.floatingButtonSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"Example [%zd]", indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0: {
            Example1ViewController *viewController = [Example1ViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }    break;
            
        case 1:  {
            Example2ViewController *viewController = [Example2ViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }    break;
            
        case 2:  {
            Example3ViewController *viewController = [Example3ViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }    break;
            
        default:
            break;
    }
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
    return 15;
}

- (CGFloat)verticalOffsetForFloatingButton:(UIScrollView *)scrollView {
    return 15;
}

- (FloatingButtonAnimation)animationTypeForFloatingButton:(UIScrollView *)scrollView {
    return MEFloatingButtonAnimationFromBottom;
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
