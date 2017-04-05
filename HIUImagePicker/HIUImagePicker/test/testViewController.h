//
//  ViewController.h
//  CollectionViewTest
//
//  Created by 周淳 on 2017/3/23.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testViewController : UIViewController

@property (nonatomic, strong)NSArray <NSValue *> *itemSizeArray;

@property (nonatomic, strong)NSArray <UIImage *> *imageArray;

@property (nonatomic, assign)CGSize *viewSize;

@end

