//
//  HIUImagePickerViewController.h
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/24.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface HIUImagePickerViewController : UIViewController

//@property (nonatomic, strong)NSArray <NSValue *> *itemSizeArray;

@property (nonatomic, strong)NSArray <UIImage *> *imageArray;

@property (nonatomic, strong)NSMutableArray *selectedCellArray;

//@property (nonatomic, assign)CGSize *viewSize;

//@property (nonatomic, strong)NSArray <PHAsset *> *assetsArray;

@end
