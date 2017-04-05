//
//  BaseViewController.m
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/21.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "BaseViewController.h"
#import <Photos/Photos.h>
//#import "HIUImagePickerViewController.h"
#import "HIUImagePickerView.h"
#import <Masonry.h>
#import "theDragView.h"

@interface BaseViewController ()

@property (nonatomic, strong) HIUImagePickerView *pickerView;

@property (nonatomic, strong) NSMutableArray <PHAsset *> *assetsArray;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *selectedImagesIndex;

@property (nonatomic, strong) PHCachingImageManager *phImageManager;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;

@property (nonatomic, assign) BOOL isEnlarge;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialData];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //vc.edgesForExtendedLayout = UIRectEdgeNone;

    HIUImagePickerView *view = [[HIUImagePickerView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 100)];
    view.viewController = self;
    [self.view addSubview:view];
    self.pickerView = view;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(100, 100, 100, 30)];
    [button setTitle:@"touch" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTouch) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];

/*
    theDragView *dragView = [[theDragView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    dragView.backgroundColor = [UIColor redColor];
    [self.view addSubview:dragView];
 */
}

- (void)buttonTouch {
    
    if (_isEnlarge) {
        
//        [UIView animateWithDuration:1 animations:^{
//            [self.pickerView setFrame:CGRectMake(0, 300, self.view.frame.size.width, 100)];
//            //[self.pickerView layoutIfNeeded];
//            //[self.pickerView.collectionView reloadData];
//        }];
        [UIView animateWithDuration:1 animations:^{
            [self.pickerView setFrame:CGRectMake(0, 300, self.view.frame.size.width, 100)];
        } completion:^(BOOL finished) {
            //[self.pickerView.collectionView reloadData];
        }];
        
    } else {
//        [self.pickerView setFrame:CGRectMake(0, 300, self.view.frame.size.width, 200)];
//        [self.pickerView.collectionView reloadData];
//        [UIView animateWithDuration:1 animations:^{
//            [self.pickerView setFrame:CGRectMake(0, 300, self.view.frame.size.width, 50)];
//            //[self.pickerView layoutIfNeeded];
//            //  [self.pickerView.collectionView reloadData];
//        }]; w
        [UIView animateWithDuration:1 animations:^{
            [self.pickerView setFrame:CGRectMake(0, 300, self.view.frame.size.width, 300)];
        } completion:^(BOOL finished) {
            [self.pickerView.collectionView reloadData];
        }];
    }
    _isEnlarge = !_isEnlarge;
}


- (void)initialData {
    
    //[self fetchAssets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
