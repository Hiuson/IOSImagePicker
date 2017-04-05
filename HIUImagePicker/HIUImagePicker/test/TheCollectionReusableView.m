//
//  TheCollectionReusableView.m
//  CollectionViewTest
//
//  Created by 周淳 on 2017/3/23.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "TheCollectionReusableView.h"

#define kButtonDiameter 26

@implementation TheCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    button.userInteractionEnabled = NO;//图片点击有效 button点击无效
    
    [self addSubview:button];
    self.button = button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _button.frame = CGRectMake((self.frame.size.width - kButtonDiameter) / 2.0,
                               (self.frame.size.width - kButtonDiameter) / 2.0,
                               kButtonDiameter,
                               kButtonDiameter);
    _button.layer.cornerRadius = kButtonDiameter / 2.0;
}

- (void)setSelected:(BOOL)selected {
    
    _selected = selected;
    
    _button.selected = _selected;
    [self reloadButtonBackgroundColor];
}

- (void)reloadButtonBackgroundColor {
    
    _button.backgroundColor = _selected ? [UIColor redColor] : [UIColor whiteColor];
}

@end
