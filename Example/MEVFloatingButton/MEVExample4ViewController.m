//
//  MEVExample4ViewController.m
//  MEVFloatingButton
//
//  Created by Manuel Escrig Ventura on 18/02/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//

#import "MEVExample4ViewController.h"
#import "UIScrollView+FloatingButton.h"


static NSString *CellIdentifier = @"CellIdentifier";

@interface MEVExample4ViewController () <MEVFloatingButtonDelegate>

@end

@implementation MEVExample4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Example 4";
    
    MEVFloatingButton *button = [[MEVFloatingButton alloc] init];
    button.animationType = MEFloatingButtonAnimationFadeIn;
    button.displayMode = MEVFloatingButtonDisplayModeAlways;
    button.position = MEVFloatingButtonPositionBottomRight;
    button.image = [UIImage imageNamed:@"Icon3"];
    button.imageColor = [UIColor colorWithRed:43/255.0f green:204/255.0f blue:113/255.0f alpha:1];
    button.backgroundColor = [UIColor colorWithRed:154/255.0f green:18/255.0f blue:197/255.0f alpha:1];
    button.outlineWidth = 0.0f;
    button.imagePadding = 15.0f;
    button.horizontalOffset = -30.0f;
    button.verticalOffset = -30.0f;
    button.rounded = YES;
    button.shadowColor = [UIColor lightGrayColor];
    button.shadowOffset = CGSizeMake(3, 3);
    button.shadowOpacity = 0.6f;
    button.shadowRadius = 3.0f;
    [self.tableView setFloatingButtonView:button];
    [self.tableView setFloatingButtonDelegate:self];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.leftBarButtonItem = barButton;
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
    cell.textLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


#pragma mark - MEScrollToTopDelegate Methods

- (void)floatingButton:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    NSLog(@"didTapButton");
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - UIBarButtonItem Methods

- (void)done:(id)snder {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
