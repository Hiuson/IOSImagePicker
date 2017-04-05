//
//  HIUImagePickerFlowLayout.m
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/24.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "HIUImagePickerFlowLayout.h"

@interface HIUImagePickerFlowLayout ()

@property(nonatomic, strong)NSMutableArray *layoutAttributes;
@property(nonatomic, assign)CGSize contentSize;

@end

@implementation HIUImagePickerFlowLayout

- (id)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);
}

- (void)setShowsSupplementaryViews:(BOOL)showsSupplementaryViews {
    
    _showsSupplementaryViews = showsSupplementaryViews;
    
    if (_showsSupplementaryViews) {
        [self invalidateLayout];
    }
}

- (CGSize)collectionViewContentSize {
    
    return _contentSize;
    //去掉了headerView的宽度的contentSize
}

- (void)prepareLayout {
    
    [super prepareLayout];
    
    _contentSize = CGSizeZero;
    _layoutAttributes = [NSMutableArray array];
    
    CGPoint origin = CGPointMake(self.sectionInset.left, self.sectionInset.top);
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    
    id delegate = self.collectionView.delegate;
    
    for (int s=0; s<numberOfSections; s++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:s];
        CGSize size = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
        attributes.zIndex = 0;
        
        [_layoutAttributes addObject:attributes];
        
        origin.x = CGRectGetMaxX(attributes.frame) + self.sectionInset.right;
    }
    _contentSize = CGSizeMake(origin.x, self.collectionView.frame.size.height);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *filteredArray = [NSMutableArray array];
    [_layoutAttributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        if(CGRectIntersectsRect(attributes.frame, rect)){
            [filteredArray addObject:attributes];
        }
    }];
    
    NSMutableArray *reducedArray = [NSMutableArray array];
    [filteredArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        [reducedArray addObject:attributes];
        
        attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:attributes.indexPath];
        [reducedArray addObject:attributes];
    }];
    
    return reducedArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return _layoutAttributes[indexPath.section];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    id delegate = self.collectionView.delegate;
    
    UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    
    UIEdgeInsets inset = self.collectionView.contentInset;
    CGRect bounds = self.collectionView.bounds;
    
    CGPoint contentOffset = self.collectionView.contentOffset;
    contentOffset.x += inset.left;
    contentOffset.y += inset.top;
    
    CGSize visibleSize = bounds.size;
    visibleSize.width -= inset.left + inset.right;
    
    CGRect visibleFrame = CGRectMake(contentOffset.x, contentOffset.y, visibleSize.width, visibleSize.height);
    
    CGSize size = [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:indexPath.section];
    CGFloat originX = MAX(CGRectGetMinX(itemAttributes.frame), MIN(CGRectGetMaxX(itemAttributes.frame)-size.width, CGRectGetMaxX(visibleFrame)-size.width));
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    attributes.zIndex = 1;
    attributes.hidden = NO;//!_showsSupplementaryViews;
    attributes.frame = CGRectMake(originX, CGRectGetMinY(itemAttributes.frame), size.width, size.height);
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return [self layoutAttributesForItemAtIndexPath:itemIndexPath];
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return [self layoutAttributesForItemAtIndexPath:itemIndexPath];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    
    /* 怀疑是为了放大工作服务的算法 */
    CGPoint contentOffset = proposedContentOffset;
    NSIndexPath *indexPath = _invalidationCenteredIndexPath;
    
    if (indexPath) {
        if (self.collectionView) {
            CGRect frame = [(UICollectionViewLayoutAttributes *)_layoutAttributes[indexPath.section] frame];
            contentOffset.x = CGRectGetMidX(frame) - self.collectionView.frame.size.width/2.0;
            
            contentOffset.x = MAX(contentOffset.x, -self.collectionView.contentInset.left);
            contentOffset.x = MIN(contentOffset.x, self.collectionViewContentSize.width-self.collectionView.frame.size.width+self.collectionView.contentInset.right);
        }
        
        _invalidationCenteredIndexPath = nil;
    }
    
    return [super targetContentOffsetForProposedContentOffset:contentOffset];
}

@end
