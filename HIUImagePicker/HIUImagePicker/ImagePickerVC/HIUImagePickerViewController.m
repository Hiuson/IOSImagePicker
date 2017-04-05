//
//  HIUImagePickerViewController.m
//  HIUImagePicker
//
//  Created by 周淳 on 2017/3/21.
//  Copyright © 2017年 周淳. All rights reserved.
//

#import "HIUImagePickerViewController.h"
#import "HIUImagePickerReusableView.h"
#import "HIUImagePickerCollectionViewCell.h"
#import "ImagePreviewFlowLayout.h"
#import "ImagePickerCollectionView.h"
#import "HIUTestLayout.h"
#import <Photos/Photos.h>
#import <Masonry.h>

#define VIEWHEIGHT 300
#define kCollectionViewInset 2

@interface HIUImagePickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray <PHAsset *> *assetsArray;
@property (nonatomic, strong)NSMutableArray <NSNumber *> *selectedImagesIndex;

@property (nonatomic, strong) PHCachingImageManager *phImageManager;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;

@property (nonatomic, strong) UICollectionView *collectionView;



@end

@implementation HIUImagePickerViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initial];
    }
    return self;
}

- (void)initial {
    
    self.assetsArray = [NSMutableArray array];
    
    [self fetchAssets];
}

- (void)fetchAssets {
    
    NSInteger fetchLimit = 50;//加载图片数量
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        /* 若未获得明确授权 */
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self performSelectorOnMainThread:@selector(fetchAssets) withObject:nil waitUntilDone:NO];
                //[self performSelectorOnMainThread:@selector(reloadLayoutAndData) withObject:nil waitUntilDone:NO];
            } else {
                [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
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
        options.fetchLimit =  fetchLimit;
    }
    
    PHFetchResult *result = [PHAsset fetchAssetsWithOptions:options];
    [result enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
        if (_assetsArray.count == (fetchLimit-1)) {
            *stop = YES;
        }
        
        if (asset && [asset isKindOfClass:[PHAsset class]]) {
            [_assetsArray addObject:asset];
        }
    }];
    
    return;
    /* 不愿意兼容IOS7及以下 */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialUI];
}

- (void)initialUI {
    
    [self initialCollectionView];
}

- (void)initialCollectionView {
    
    //[self.navigationController.navigationBar setHidden:YES];
    
    CGFloat topInset = -64;
    if ([self.navigationController.navigationBar isHidden]) {
        topInset = -20;
    }
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(topInset, kCollectionViewInset, 0, kCollectionViewInset);
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing = 5;
//    layout.minimumInteritemSpacing = 5;

    
//    HIUTestLayout *layout = [[HIUTestLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(topInset, kCollectionViewInset, 0, kCollectionViewInset);
//    layout.minimumLineSpacing = 5;
//    layout.minimumInteritemSpacing = 5;
    
    //UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    ImagePickerCollectionView *collectionView = [[ImagePickerCollectionView alloc] init];
    collectionView.imagePreviewLayout.sectionInset = UIEdgeInsetsMake(0, kCollectionViewInset, 0, kCollectionViewInset);
    collectionView.imagePreviewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.allowsMultipleSelection = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.alwaysBounceHorizontal = YES;//这样它就可以被拉的很长很长？
    //collectionView.scrollsToTop = NO;
    [collectionView registerClass:[HIUImagePickerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HIUImagePickerCollectionViewCell class])];
    [collectionView registerClass:[HIUImagePickerReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HIUImagePickerReusableView class])];
    
    UIView *collectionContentView = [[UIView alloc] initWithFrame:CGRectZero];
    collectionContentView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:collectionContentView];
    [collectionContentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(VIEWHEIGHT + 100);
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(collectionContentView).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
}

#pragma mark - collectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _assetsArray.count;
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
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HIUImagePickerReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:NSStringFromClass([HIUImagePickerReusableView class])
                                                                                 forIndexPath:indexPath];
    
    view.userInteractionEnabled = NO;
    view.buttonInset = UIEdgeInsetsMake(0.0, 3.5, 3.5, 0.0);
    view.selected = [_selectedImagesIndex containsObject:@(indexPath.section)];
    
    return view;
}

#pragma mark - collectionView FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self sizeForAsset:_assetsArray[indexPath.section]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize size = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    
    return CGSizeMake(50, size.height);
    //return CGSizeMake(50, 80);
}


#pragma mark - size calculate

- (CGSize)targetSizeForAssetOfSize:(CGSize)size {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    return CGSizeMake(scale*size.width, scale*size.height);
}

- (CGSize)sizeForAsset:(PHAsset *)asset {
    
    CGFloat proportion = 1;
    proportion = (CGFloat)([asset pixelWidth]) / (CGFloat)([asset pixelHeight]);
    CGFloat rowHeight = VIEWHEIGHT;//要改
    CGFloat height = rowHeight - 2.0 * kCollectionViewInset;
    //NSLog(@"%f", height);
    return CGSizeMake(proportion * height, height);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
