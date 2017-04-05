//
//  HIUImagePickerCollectionViewCell.m
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/21.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "HIUImagePickerCollectionViewCell.h"

@interface HIUImagePickerCollectionViewCell ()

@property (nonatomic, assign) PHImageRequestID requestID;

@end


@implementation HIUImagePickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initial];
    }
    return self;
}

- (void)initial {
    
    [self initialImageView];
}

- (void)initialImageView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor redColor];
    
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (void)updateWithPHAsset:(PHAsset *)phAsset targetSize:(CGSize)targetSize {
    
    NSInteger tag = self.tag + 1;
    self.tag = tag;
    
    [_imageManager cancelImageRequest:self.requestID];
    
    _requestID = [_imageManager requestImageForAsset:phAsset
                                            targetSize:targetSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:_requestOptions
                                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                             if (self.tag == tag && result) {
                                                 _imageView.image = result;
                                             }
                                         }];
}

- (void)prepareForReuse {
    /* cell滑出屏幕外则清除出内存 */
    [super prepareForReuse];
    
    _imageView.image = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}

@end
