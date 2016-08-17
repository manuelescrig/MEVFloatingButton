//
//  MEVExample5ViewController.m
//  MEVFloatingButton
//
//  Created by Manuel Escrig Ventura on 18/02/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//

#import "MEVExample5ViewController.h"
#import "UIScrollView+FloatingButton.h"


static NSString *CellIdentifier = @"CellIdentifier";

@interface MEVExample5ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, MEVFloatingButtonDelegate>

@property (strong) UICollectionView *collectionView;

@end

@implementation MEVExample5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Example 5";
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100, 100);
    flowLayout.minimumLineSpacing = 10;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:self.collectionView];
    
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
    [self.collectionView setFloatingButtonView:button];
    [self.collectionView setFloatingButtonDelegate:self];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.collectionView setFrame:self.view.frame];
}


#pragma mark - Table view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor lightGrayColor]];
    return cell;
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
