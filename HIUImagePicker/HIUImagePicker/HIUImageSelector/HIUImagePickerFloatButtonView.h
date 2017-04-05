//
//  HIUImagePickerFloatButtonView.h
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/24.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HIUImagePickerSelectDelegate <NSObject>

@optional

- (BOOL)clickedAtIndex:(NSInteger)index;

@end

@interface HIUImagePickerFloatButtonView : UICollectionReusableView

@property (nonatomic, weak) id<HIUImagePickerSelectDelegate> delegate;

@property (nonatomic, assign) NSInteger collectionViewIndex;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) BOOL selected;


@end
