//
//  HIUImagePickerView.h
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/24.
//  Copyright © 2017年 周淳. All rights reserved.
//

/* 建议布局时横向覆盖满屏幕，以免影响拖动时的动画效果 */

#import <UIKit/UIKit.h>

@interface HIUImagePickerView : UIView

/* 提取image数据时是否修复图像 */
@property (nonatomic, assign)BOOL shouldFixOrientation;

/* 从相册中加载照片的数量 */
@property (nonatomic, assign)NSInteger assetsFetchLimit;

/* 存放选中的cell的索引 */
@property (nonatomic, strong)NSMutableArray <NSNumber *> *selectedCellArray;

/* 就是那个collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

/* 生成此view时请把对应VC赋值给它，谢谢 */
@property (nonatomic, weak) UIViewController *viewController;

@end
