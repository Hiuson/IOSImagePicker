//
//  HIUImagePickerFloatButtonView.m
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/24.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "HIUImagePickerFloatButtonView.h"

#define kButtonInset 2

@implementation HIUImagePickerFloatButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    
    self.backgroundColor = [UIColor clearColor];
    //self.userInteractionEnabled = NO;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    //button.titleLabel.textColor = [UIColor greenColor];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    //button.userInteractionEnabled = YES;//图片点击有效 button点击无效
    
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    self.button = button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _button.frame = CGRectMake(kButtonInset, kButtonInset, (CGRectGetWidth(self.bounds) - 2 * kButtonInset), (CGRectGetWidth(self.bounds) - 2 * kButtonInset));
    _button.layer.cornerRadius = (CGRectGetWidth(self.bounds) - 2 * kButtonInset) / 2.0;
}

- (void)setSelected:(BOOL)selected {
    
    _selected = selected;
    
    _button.selected = _selected;
    //[self reloadButton];//修改为其他动画效果
    _button.backgroundColor = _selected ? [UIColor redColor] : [UIColor whiteColor];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    _selectedIndex = selectedIndex;
    if (selectedIndex) {
        self.selected = YES;
    } else {
        self.selected = NO;
    }
    NSString *str = [NSString stringWithFormat:@"%ld", _selectedIndex];
    if (_selectedIndex == 0) {
        str = @"";
    }
    [self.button setTitle:str forState:normal];
}

//- (void)reloadButton {
//    
//    _button.backgroundColor = _selected ? [UIColor redColor] : [UIColor whiteColor];
//}

- (void)buttonClicked {
    
    if ([self.delegate respondsToSelector:@selector(clickedAtIndex:)]) {
        [self setSelected:[self.delegate clickedAtIndex:_collectionViewIndex]];
    }
}

@end
