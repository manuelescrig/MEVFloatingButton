//
//  Example2ViewController.m
//  Examples
//
//  Created by Manuel Escrig Ventura on 09/02/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//

#import "Example2ViewController.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface Example2ViewController () <MEVFloatingButtonDelegate>

@end

@implementation Example2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Example 2";

    MEVFloatingButton *button = [[MEVFloatingButton alloc] init];
    button.displayMode = MEVFloatingButtonDisplayModeWhenScrolling;
    button.animationType = MEVFloatingButtonAnimationNone;
    button.position = MEVFloatingButtonPositionBottomLeft;
    button.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9];
    button.horizontalOffset = 30.0f;
    button.verticalOffset = -30.0f;
    button.image = [UIImage imageNamed:@"Icon2"];
    button.rounded = NO;
    button.hideOnTap = YES;
    [self.tableView setFloatingButtonView:button];
    [self.tableView setFloatingButtonDelegate:self];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    DLog(@"");
    
}

- (void)viewDidAppear:(BOOL)animated {
    DLog(@"");
    
}

- (void)viewWillDisappear:(BOOL)animated {
    DLog(@"");
    
}

- (void)viewDidDisappear:(BOOL)animated {
    DLog(@"");
    
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