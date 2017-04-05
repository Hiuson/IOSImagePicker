//
//  HIUImagePickerCollectionViewCell.h
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/24.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "HIUImagePickerView.h"
#import "HIUImagePickerFloatButtonView.h"

@interface HIUImagePickerCollectionViewCell : UICollectionViewCell

/* 暴露以供调用的属性 */
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong, readonly) PHAsset *currentAsset;

/* 以下两项需要在cell生成时赋值 */
/* pickerView统一配置 */
@property (nonatomic, weak) PHCachingImageManager *imageManager;
@property (nonatomic, weak) PHImageRequestOptions *requestOptions;

/* 以下两项需要在cell生成时赋值 */
/* cell所在的collectionView的pickerView */
@property (nonatomic, weak) HIUImagePickerView *pickerView;
/* pickerView所在的VC */
@property (nonatomic, weak) UIViewController *viewController;

/* 在floatButtonView生成时为对应cell赋值(必须要有！) */
@property (nonatomic, weak) HIUImagePickerFloatButtonView *floatButtonView;

/* 拖动前(cell自身)的frame */
@property (nonatomic, assign)CGRect startFrame;

/* 通过image初始化使用 */
@property (nonatomic, strong) UIImage *theImage;
/* 通过phAsset初始化使用 */
- (void)updateWithPHAsset:(PHAsset *)phAsset targetSize:(CGSize)targetSize;

@end
