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
#import "Example4ViewController.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface ViewController () <MEFloatingButtonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MEFloatingButton";
    
    MEFloatingButton *button = [[MEFloatingButton alloc] init];
    button.animationType = MEFloatingButtonAnimationFromBottom;
    button.displayMode = MEFloatingButtonDisplayModeWhenScrolling;
    button.position = MEFloatingButtonPositionBottomCenter;
    button.image = [UIImage imageNamed:@"Icon0"];
    button.imageColor = [UIColor greenColor];
    button.backgroundColor = [UIColor purpleColor];
    button.outlineColor = [UIColor darkGrayColor];
    button.outlineWidth = 2.0f;
    button.imagePadding = 20.0f;
    button.horizontalOffset = 20.0f;
    button.verticalOffset = -30.0f;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
            
        case 3:  {
            Example4ViewController *viewController = [Example4ViewController new];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
        }    break;
        default:
            break;
    }
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
