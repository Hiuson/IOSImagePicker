//
//  HIUImagePickerCollectionViewCell.m
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/24.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "HIUImagePickerCollectionViewCell.h"
#import "theDragView.h"

@interface HIUImagePickerCollectionViewCell ()

@property (nonatomic, assign) PHImageRequestID requestID;

/* 拖动动作标志位，cell正在进行拖动时标志位为YES */
@property (nonatomic, assign) BOOL isDrag;

@end

@implementation HIUImagePickerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initial];
    }
    return self;
}

- (void)initial {
    
    _isDrag = NO;
    [self initialImageView];
    //[self initialDragView];
}

- (void)initialImageView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor redColor];
    //_startFrame = self.bounds;
    //imageView.frame = _startFrame;
    
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (void)setTheImage:(UIImage *)theImage {
    
    _theImage = theImage;
    self.imageView.image = theImage;
}

- (void)initialDragView {
    
    UIView *dragView = [[UIView alloc] initWithFrame:self.frame];
    dragView.backgroundColor = [UIColor blueColor];
    [self.imageView addSubview:dragView];
}

- (void)updateWithPHAsset:(PHAsset *)phAsset targetSize:(CGSize)targetSize {
    

    
    NSInteger tag = self.tag + 1;
    self.tag = tag;
    
    [_imageManager cancelImageRequest:self.requestID];
    
    _requestID = [_imageManager requestImageForAsset:phAsset
                                          targetSize:targetSize
                                         contentMode:PHImageContentModeAspectFill
                                             options:_requestOptions
                                       resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                           if (self.tag == tag && result) {
                                               _imageView.image = result;
                                           }
                                       }];
    //NSLog(@"%@", _imageView.image);
}

- (void)prepareForReuse {
    /* cell滑出屏幕外则清除出内存 */
    [super prepareForReuse];
    
    _imageView.image = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_isDrag) {
        //进入拖动动作之后不重算imageView的fram
        _startFrame = self.bounds;
        [_imageView setFrame:self.bounds];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    CGRect frame = self.frame;
    UIImageView *imageView = self.imageView;
    
    self.pickerView.collectionView.scrollEnabled = NO;
    _isDrag = YES;
    [_floatButtonView.button setHidden:YES];
    
    //CGPoint contentOffset = self.pickerView.collectionView.contentOffset;
    
    [self.viewController.view addSubview:imageView];
    
    [imageView setFrame:CGRectMake(frame.origin.x - self.pickerView.collectionView.contentOffset.x + self.pickerView.frame.origin.x, //相对坐标减去collectionView自身偏移量
                                   self.pickerView.frame.origin.y, //pickerView相对于VC.view的偏移量
                                   frame.size.width,
                                   frame.size.height)];
    
    //[imageView setFrame:frame];
    _startFrame = self.frame;
    NSLog(@"began");
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    // 获取当前点
    CGPoint curP = [touch locationInView:self];
    // 获取上一个点
    CGPoint preP = [touch previousLocationInView:self];
    // 获取手指x轴偏移量
        //目前限制为垂直拖动
    //CGFloat offsetX = curP.x - preP.x;
    // 获取手指y轴偏移量
    CGFloat offsetY = curP.y - preP.y;
    // 移动当前view
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, 0, offsetY);
    NSLog(@"move");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.imageView setFrame:CGRectMake(0, 0, _startFrame.size.width, _startFrame.size.height)];
    [self addSubview:self.imageView];
    [self setFrame:_startFrame];
    _startFrame = CGRectMake(0, 0, _startFrame.size.width, _startFrame.size.height);
    
    self.pickerView.collectionView.scrollEnabled = YES;
    _isDrag = NO;
    [_floatButtonView.button setHidden:NO];
    NSLog(@"end");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.imageView setFrame:CGRectMake(0, 0, _startFrame.size.width, _startFrame.size.height)];
    [self addSubview:self.imageView];
    [self setFrame:_startFrame];
    _startFrame = CGRectMake(0, 0, _startFrame.size.width, _startFrame.size.height);
    
    self.pickerView.collectionView.scrollEnabled = YES;
    _isDrag = NO;
    [_floatButtonView.button setHidden:NO];
    NSLog(@"cancelled");
}

@end
