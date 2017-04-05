//
//  ViewController.m
//  CollectionViewTest
//
//  Created by 周淳 on 2017/3/23.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "testViewController.h"
#import "theTestViewController.h"
#import "theFlowLayout.h"
#import "TheCollectionView.h"
#import "TheCollectionReusableView.h"

#define kCollectionViewContentHeightInset 5

@interface testViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)TheCollectionView *collectionView;

@property (nonatomic, strong)NSArray *colorArray;

@property (nonatomic, strong)NSMutableArray *selectedCellArray;

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialData];
    [self initialUI];
}

#pragma mark - DATA

- (void)initialData {
    
    self.selectedCellArray = [NSMutableArray array];
    self.colorArray = @[[UIColor blueColor], [UIColor greenColor], [UIColor grayColor]];
    NSMutableArray *tempSizeArray = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        CGSize size = CGSizeMake((i % 3 + 1) * 150, 200);
        NSValue *value = [NSValue valueWithCGSize:size];
        [tempSizeArray addObject:value];
    }
    _itemSizeArray = [tempSizeArray copy];
}

- (void)setImageArray:(NSArray<UIImage *> *)imageArray {
    
    _imageArray = imageArray;
    self.selectedCellArray = [NSMutableArray array];
    [self.collectionView reloadData];
}

#pragma mark - UI

- (void)initialUI {
    
    [self initialCollectionView];
}

- (void)initialCollectionView {
    
    TheCollectionView *collectionView = [[TheCollectionView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[TheCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"floatView"];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - collectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 20;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = self.colorArray[indexPath.section % 3];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    TheCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                         withReuseIdentifier:@"floatView"
                                                                                forIndexPath:indexPath];
    view.selected = [_selectedCellArray containsObject:@(indexPath.section)];
    
    return view;
}

#pragma mark - collectionView FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = [_itemSizeArray[indexPath.section] CGSizeValue];
    CGFloat viewHeight = 100;//self.view.bounds.size.height - 2 * kCollectionViewContentHeightInset;
    CGFloat proportion = size.width / size.height;
    return CGSizeMake(proportion * viewHeight, viewHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(30, 100);
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self handelCollectionViewItemTap:indexPath];
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self handelCollectionViewItemTap:indexPath];
    [collectionView reloadData];
}

- (void)handelCollectionViewItemTap:(NSIndexPath *)indexPath {
    
    NSLog(@"selected");
    if ([_selectedCellArray containsObject:@(indexPath.section)]) {
        [_selectedCellArray removeObject:@(indexPath.section)];
    } else {
        [_selectedCellArray addObject:@(indexPath.section)];
    }
    UICollectionViewCell *cell = [self collectionView:_collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        CGPoint contentOffset = CGPointMake(CGRectGetMidX(cell.frame)-_collectionView.frame.size.width/2.0, 0.0);
        contentOffset.x = MAX(contentOffset.x, -_collectionView.contentInset.left);
        contentOffset.x = MIN(contentOffset.x, _collectionView.contentSize.width - _collectionView.frame.size.width + _collectionView.contentInset.right);
        //选中之后拉扯cell使其居中。
        
        [_collectionView setContentOffset:contentOffset animated:YES];
    }
}

@end
