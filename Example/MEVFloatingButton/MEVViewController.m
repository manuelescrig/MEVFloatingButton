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

    [self.tableView setBackgroundColor:[UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1]];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setBackgroundColor:[UIColor colorWithRed:236/255.0f green:236/255.0f blue:236/255.0f alpha:1]];
    cell.textLabel.text = [NSString stringWithFormat:@"Example %zd", indexPath.row+1];
    cell.textLabel.textColor = [UIColor colorWithRed:44/255.0f green:62/255.0f blue:80/255.0f alpha:1];
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




@end
