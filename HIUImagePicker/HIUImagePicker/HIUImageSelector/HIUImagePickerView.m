//
//  HIUImagePickerView.m
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/24.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "HIUImagePickerView.h"
#import "HIUImagePickerFlowLayout.h"
#import "HIUImagePickerCollectionView.h"
#import "HIUImagePickerCollectionViewCell.h"
#import "HIUImagePickerFloatButtonView.h"

#define kCollectionViewInset 0

@interface HIUImagePickerView ()<UICollectionViewDelegate, UICollectionViewDataSource, HIUImagePickerSelectDelegate>

//@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray <NSValue *> *itemSizeArray;//同上

@property (nonatomic, strong) PHCachingImageManager *phImageManager;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;

@property (nonatomic, strong) NSMutableArray <PHAsset *> *assetsArray;

@property (nonatomic, strong) NSMutableArray <UIImage *> *imageArray;

@property (nonatomic, strong) NSMutableArray <NSNumber *> *buttonSelectedIndexArray;

@end

@implementation HIUImagePickerView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    [self initialData];
    [self initialUI];
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    [self.collectionView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
//    [self.collectionView reloadData];
}

#pragma mark - DATA

- (void)initialData {
    
    self.selectedCellArray = [NSMutableArray array];
    NSMutableArray *tempSizeArray = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        CGSize size = CGSizeMake((i % 3 + 1) * 150, 200);
        NSValue *value = [NSValue valueWithCGSize:size];
        [tempSizeArray addObject:value];
    }
    _itemSizeArray = [tempSizeArray copy];
    self.assetsArray = [NSMutableArray array];
    self.buttonSelectedIndexArray = [NSMutableArray array];
    [self fetchAssets];
    
    //self.imageArray = [NSMutableArray array];
    //[self initialImageArray];
}

- (void)fetchAssets {
    
    //NSInteger fetchLimit = 50;//加载图片数量
    if (!_assetsFetchLimit) {
        _assetsFetchLimit = 50;
    }
    for (int i = 0; i < _assetsFetchLimit; i ++) {
        [self.buttonSelectedIndexArray addObject:@0];
    }
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        /* 若未获得明确授权 */
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self performSelectorOnMainThread:@selector(fetchAssets) withObject:nil waitUntilDone:NO];
                
            } else {
                return;
            }
        }];
        return;
    }
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
        /* 若无授权 */
        return;
    }
    
    _phImageManager = [[PHCachingImageManager alloc] init];
    _requestOptions = [[PHImageRequestOptions alloc] init];
    _requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//图像质量与加载速度均衡
    _requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;//尽快缩放图像
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];//根据图片创建时间降序
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];//获取图片
    if ([options respondsToSelector:@selector(fetchLimit)]) {
        //一个兼容性操作其实我不是很想要
        options.fetchLimit =  _assetsFetchLimit;
    }
    
    PHFetchResult *result = [PHAsset fetchAssetsWithOptions:options];
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_assetsArray.count == (_assetsFetchLimit - 1)) {
            *stop = YES;
        }
        
        if (asset && [asset isKindOfClass:[PHAsset class]]) {
            [_assetsArray addObject:asset];
        }
    }];
    
    return;
    /* 不愿意兼容IOS7及以下 */
}

- (void)initialImageArray {
    
    NSInteger tag = 0;
    __block NSInteger count = 0;
    PHImageRequestID requestID = 0;
    for (PHAsset *asset in _assetsArray) {
        
        [_phImageManager cancelImageRequest:requestID];
        
        requestID = [_phImageManager requestImageForAsset:asset
                                               targetSize:[self sizeForAsset:asset]
                                              contentMode:PHImageContentModeAspectFill
                                                  options:_requestOptions
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                //[_imageArray insertObject:result atIndex:tag];
                                                if(result) {
                                                    [_imageArray addObject:result];
                                                }
                                                NSLog(@"%ld : %@", (long)tag, result);
                                                count ++;
                                                if (count >= 49) {
                                                    //[self.collectionView reloadData];
                                                }
                                            }];
        tag ++;
    }
}

//- (void)setImageArray:(NSArray<UIImage *> *)imageArray {
//    
//    _imageArray = imageArray;
//    self.selectedCellArray = [NSMutableArray array];
//    [self.collectionView reloadData];
//}

#pragma mark - UI

- (void)initialUI {
    
    [self initialCollectionView];
}

- (void)initialCollectionView {
    
    HIUImagePickerFlowLayout *layout = [[HIUImagePickerFlowLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))
                                                          collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.allowsSelection = NO;
    [collectionView registerClass:[HIUImagePickerCollectionViewCell class]
       forCellWithReuseIdentifier:NSStringFromClass([HIUImagePickerCollectionViewCell class])];
    [collectionView registerClass:[HIUImagePickerFloatButtonView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:NSStringFromClass([HIUImagePickerFloatButtonView class])];
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - collectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _assetsArray.count;
    //return _imageArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HIUImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HIUImagePickerCollectionViewCell class]) forIndexPath:indexPath];
    
    PHAsset *asset = _assetsArray[indexPath.section];
    CGSize targetSize = [self targetSizeForAssetOfSize:[self sizeForAsset:asset]];
    cell.imageManager = _phImageManager;
    cell.requestOptions = _requestOptions;
    [cell updateWithPHAsset:asset targetSize:targetSize];
    
    /* 绑定相关指针 */
    cell.pickerView = self;
    cell.viewController = self.viewController;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HIUImagePickerFloatButtonView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                             withReuseIdentifier:NSStringFromClass([HIUImagePickerFloatButtonView class])
                                                                                    forIndexPath:indexPath];
    view.selected = [_selectedCellArray containsObject:@(indexPath.section)];
    view.delegate = self;
    view.collectionViewIndex = indexPath.section;
    view.selectedIndex = [self.buttonSelectedIndexArray[indexPath.section] integerValue];
    
    /* 关联cell与button */
    HIUImagePickerCollectionViewCell *cell = (HIUImagePickerCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    cell.floatButtonView = view;
    
    return view;
}

#pragma mark - floatButtonView Delegate

- (BOOL)clickedAtIndex:(NSInteger)index {

    BOOL ret = NO;
    HIUImagePickerFloatButtonView *headerView = (HIUImagePickerFloatButtonView *)[_collectionView supplementaryViewForElementKind:@"UICollectionElementKindSectionHeader" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    
    if ([_selectedCellArray containsObject:@(index)]) {
        /* 取消选中 */
        NSLog(@"deselected");
        NSInteger removeIndex = [_selectedCellArray indexOfObject:@(index)];
        for (NSInteger i = removeIndex + 1; i < _selectedCellArray.count; i ++) {
            /* 其他选中的button索引-1s */
            HIUImagePickerFloatButtonView *otherHeaderView = (HIUImagePickerFloatButtonView *)[_collectionView supplementaryViewForElementKind:@"UICollectionElementKindSectionHeader" atIndexPath:[NSIndexPath indexPathForRow:0 inSection:[(NSNumber *)_selectedCellArray[i] integerValue]]];
            
            otherHeaderView.selectedIndex = otherHeaderView.selectedIndex - 1;
        }
        headerView.selectedIndex = 0;
        
        for (NSInteger i = 0; i < _buttonSelectedIndexArray.count; i ++) {

            if (removeIndex < [_buttonSelectedIndexArray[i] integerValue]) {
                _buttonSelectedIndexArray[i] = @([_buttonSelectedIndexArray[i] integerValue] - 1);
            }
        }
        _buttonSelectedIndexArray[index] = @0;
        
        [_selectedCellArray removeObject:@(index)];
    } else {
        /* 选中 */
        NSLog(@"selected");
        ret = YES;
        [_selectedCellArray addObject:@(index)];
        headerView.selectedIndex = _selectedCellArray.count;
        self.buttonSelectedIndexArray[index] = @(headerView.selectedIndex);
    }
    
    
    UICollectionViewCell *cell = [self collectionView:_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    if (cell) {
        CGPoint contentOffset = CGPointMake(CGRectGetMidX(cell.frame)-_collectionView.frame.size.width/2.0, 0.0);
        contentOffset.x = MAX(contentOffset.x, -_collectionView.contentInset.left);
        contentOffset.x = MIN(contentOffset.x, _collectionView.contentSize.width - _collectionView.frame.size.width + _collectionView.contentInset.right);
        
        [_collectionView setContentOffset:contentOffset animated:YES];
    }
    
    /* 选中返回YES 取消选中返回NO */
    return ret;
}

#pragma mark - collectionView FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    CGSize size = [_itemSizeArray[indexPath.section] CGSizeValue];
//    CGFloat viewHeight = self.bounds.size.height;
//    CGFloat proportion = size.width / size.height;
//    return CGSizeMake(proportion * viewHeight, viewHeight);
    return [self sizeForAsset:_assetsArray[indexPath.section]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(30, 30);//self.collectionView.bounds.size.height);
}


#pragma mark - UICollectionViewDelegate
/*
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self handelCollectionViewItemTap:indexPath];
    [collectionView reloadData];
    //[collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self handelCollectionViewItemTap:indexPath];
    [collectionView reloadData];
    //[collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)handelCollectionViewItemTap:(NSIndexPath *)indexPath {
    
    if ([_selectedCellArray containsObject:@(indexPath.section)]) {
        NSLog(@"selected");
        [_selectedCellArray removeObject:@(indexPath.section)];
    } else {
        NSLog(@"deselected");
        [_selectedCellArray addObject:@(indexPath.section)];
    }
    UICollectionViewCell *cell = [self collectionView:_collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        CGPoint contentOffset = CGPointMake(CGRectGetMidX(cell.frame)-_collectionView.frame.size.width/2.0, 0.0);
        contentOffset.x = MAX(contentOffset.x, -_collectionView.contentInset.left);
        contentOffset.x = MIN(contentOffset.x, _collectionView.contentSize.width - _collectionView.frame.size.width + _collectionView.contentInset.right);
        //选中之后拉扯cell使其居中。
        
        [_collectionView setContentOffset:contentOffset animated:YES];
    }
    
    [UIView performWithoutAnimation:^{
        [self.collectionView reloadData];
        //[self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    }];
}
*/

#pragma mark - size calculate

- (CGSize)targetSizeForAssetOfSize:(CGSize)size {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    return CGSizeMake(scale*size.width, scale*size.height);
}

- (CGSize)sizeForAsset:(PHAsset *)asset {
    
    CGFloat proportion = 1;
    proportion = (CGFloat)([asset pixelWidth]) / (CGFloat)([asset pixelHeight]);
    CGFloat rowHeight = self.bounds.size.height;
    CGFloat height = rowHeight - 2.0 * kCollectionViewInset;
    //NSLog(@"%f", height);
    return CGSizeMake(proportion * height, height);
}

#pragma mark - 从assets获取图片 - 暂未启用
- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion {
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
        option.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                result = [self fixOrientation:result];
                if (completion) completion(result,info);
            }
        }];
    }
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    if (!self.shouldFixOrientation) return aImage;
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
