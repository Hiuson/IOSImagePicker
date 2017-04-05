//
//  HIUImagePickerFlowLayout.h
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/24.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIUImagePickerFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSIndexPath *invalidationCenteredIndexPath;

/* 是否展示浮动按钮的开关 */
@property (nonatomic, assign) BOOL showsSupplementaryViews;

@end
