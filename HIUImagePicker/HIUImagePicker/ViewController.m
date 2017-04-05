//
//  ViewController.m
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/21.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "HIUImagePickerViewController.h"
#import <Masonry.h>
#import "testViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //[self.navigationBar setHidden:YES];
    [self pushViewController:[[BaseViewController alloc] init] animated:NO];
    
    //[self presentViewController:[[HIUImagePickerViewController alloc] init] animated:YES completion:nil];
//    testViewController *vc = [[testViewController alloc] init];
//    [vc.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
//    vc.edgesForExtendedLayout = UIRectEdgeNone;
//    [self.navigationController pushViewController:vc animated:NO];
    //[self.view addSubview:vc.view];
//    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.view.mas_centerY);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.height.mas_equalTo(100);
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
