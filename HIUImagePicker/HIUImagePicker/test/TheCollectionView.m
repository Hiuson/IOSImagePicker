//
//  TheCollectionView.m
//  CollectionViewTest
//
//  Created by 周淳 on 2017/3/23.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "TheCollectionView.h"
#import "theFlowLayout.h"

@implementation TheCollectionView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame collectionViewLayout:[[theFlowLayout alloc] init]]) {
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

- (instancetype)init {
    
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:[[theFlowLayout alloc] init]]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    
    //self.showsHorizontalScrollIndicator = NO;
}

@end
