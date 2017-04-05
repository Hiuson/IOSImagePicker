//
//  HIUImagePickerReusableView.m
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/22.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "HIUImagePickerReusableView.h"
#import <Masonry.h>

@implementation HIUImagePickerReusableView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

- (void)initial {
    
    _buttonInset = UIEdgeInsetsZero;
    
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.userInteractionEnabled = false;
    //[_button setImage:[[self class] checkmarkImage] forState:UIControlStateNormal];
    //[_button setImage:[[self class] selectedCheckmarkImage] forState:UIControlStateSelected];
    
    [self addSubview:button];
    self.button = button;
    //button.layer.cornerRadius =
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //[_button sizeToFit];
    
//    CGRect frame = _button.frame;
//    frame.origin.x = _buttonInset.left;
//    frame.origin.y = CGRectGetHeight(self.bounds) / 2;
//    _button.frame = frame;
//    _button.layer.cornerRadius = CGRectGetHeight(frame) / 2.0;
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(2);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(self.mas_width).offset(-4);
        make.height.equalTo(_button.mas_width);
    }];
    _button.layer.cornerRadius = (self.bounds.size.width - 4) / 2;
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    _selected = false;
}

- (void)setSelected:(BOOL)selected {
    
    _selected = selected;
    
    self.button.selected = _selected;
    [self reloadButtonBackgroundColor];
}

- (void)reloadButtonBackgroundColor {
    
    self.button.backgroundColor = _selected ? [UIColor greenColor] : [UIColor redColor];
}


@end
