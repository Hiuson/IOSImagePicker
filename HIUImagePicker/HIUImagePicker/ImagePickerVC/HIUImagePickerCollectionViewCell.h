//
//  HIUImagePickerCollectionViewCell.h
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/21.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@interface HIUImagePickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PHAsset *currentAsset;

@property (nonatomic, weak) PHCachingImageManager *imageManager;
@property (nonatomic, weak) PHImageRequestOptions *requestOptions;


- (void)updateWithPHAsset:(PHAsset *)phAsset targetSize:(CGSize)targetSize;


@end
