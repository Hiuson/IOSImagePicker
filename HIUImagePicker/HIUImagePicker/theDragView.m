//
//  theDragView.m
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/30.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "theDragView.h"

@implementation theDragView

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // 拿到UITouch就能获取当前点
    UITouch *touch = [touches anyObject];
    // 获取当前点
    CGPoint curP = [touch locationInView:self];
    // 获取上一个点
    CGPoint preP = [touch previousLocationInView:self];
    // 获取手指x轴偏移量
    CGFloat offsetX = curP.x - preP.x;
    // 获取手指y轴偏移量
    CGFloat offsetY = curP.y - preP.y;
    // 移动当前view
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self setFrame:CGRectMake(100, 100, 100, 100)];
}

@end
