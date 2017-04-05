//
//  HIUImagePickerReusableView.h
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/22.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HIUImagePickerReusableView : UICollectionReusableView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) UIEdgeInsets buttonInset;

@end
