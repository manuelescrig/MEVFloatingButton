//
//  ViewController.m
//  Examples
//
//  Created by Manuel Escrig Ventura on 27/01/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//  Licence: MIT-Licence
//

#import "ViewController.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface ViewController () <MEFloatingButtonSource, MEFloatingButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView.floatingButtonSource = self;
    self.tableView.floatingButtonDelegate = self;
    self.tableView.hideOnTap = YES;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 20;
            break;
        case 2:
            return 20;
            break;
        case 3:
            return 60;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section[%d]", section];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    cell.textLabel.text = [NSString stringWithFormat:@"Cell section [%d] row [%d]", indexPath.section, indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
}


#pragma mark - MEScrollToTopSource Methods

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

- (FloatingButtonAnimationType)animationTypeForFloatingButton:(UIScrollView *)scrollView {
    return FloatingButtonAnimationTypeFromBottom;
}


#pragma mark - MEScrollToTopDelegate Methods

- (BOOL)floatingButtonShouldDisplay:(UIScrollView *)scrollView {
    NSLog(@"floatingButtonShouldDisplay");

    return YES;
}


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
