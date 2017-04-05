//
//  HIUImagePickerCollectionView.m
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/24.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "HIUImagePickerCollectionView.h"
#import "HIUImagePickerFlowLayout.h"

@implementation HIUImagePickerCollectionView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame collectionViewLayout:[[HIUImagePickerFlowLayout alloc] init]]) {
        [self initialize];
    }
    return self;
}

- (instancetype)init {
    
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:[[HIUImagePickerFlowLayout alloc] init]]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    
    //self.showsHorizontalScrollIndicator = NO;
}

@end
