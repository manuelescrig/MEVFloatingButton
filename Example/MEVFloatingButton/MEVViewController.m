//
//  MEVViewController.m
//  MEVFloatingButton
//
//  Created by Manuel Escrig Ventura on 02/23/2016.
//  Copyright (c) 2016 Manuel Escrig Ventura. All rights reserved.
//

#import "MEVViewController.h"
#import "UIScrollView+FloatingButton.h"

// Examples
#import "MEVExample1ViewController.h"
#import "MEVExample2ViewController.h"
#import "MEVExample3ViewController.h"
#import "MEVExample4ViewController.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface MEVViewController () <MEVFloatingButtonDelegate>

@end

@implementation MEVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.title = @"MEVFloatingButton";
    
    MEVFloatingButton *button = [[MEVFloatingButton alloc] init];
    button.animationType = MEVFloatingButtonAnimationFromBottom;
    button.displayMode = MEVFloatingButtonDisplayModeWhenScrolling;
    button.position = MEVFloatingButtonPositionBottomCenter;
    button.image = [UIImage imageNamed:@"Icon0"];
    button.imageColor = [UIColor groupTableViewBackgroundColor];
    button.backgroundColor = [UIColor darkGrayColor];
    button.outlineColor = [UIColor darkGrayColor];
    button.outlineWidth = 0.0f;
    button.imagePadding = 20.0f;
    button.horizontalOffset = 20.0f;
    button.verticalOffset = -30.0f;
    button.rounded = YES;
    button.hideWhenScrollToTop = YES;
    [self.tableView setFloatingButtonView:button];
    [self.tableView setFloatingButtonDelegate:self];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
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
            MEVExample1ViewController *viewController = [MEVExample1ViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }    break;
            
        case 1:  {
            MEVExample2ViewController *viewController = [MEVExample2ViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }    break;
            
        case 2:  {
            MEVExample3ViewController *viewController = [MEVExample3ViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
        }    break;
            
        case 3:  {
            MEVExample4ViewController *viewController = [MEVExample4ViewController new];
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
