//
//  theFlowLayout.h
//  CollectionViewTest
//
//  Created by 周淳 on 2017/3/23.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface theFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSIndexPath *invalidationCenteredIndexPath;

@property (nonatomic, assign) BOOL showsSupplementaryViews;

@end
