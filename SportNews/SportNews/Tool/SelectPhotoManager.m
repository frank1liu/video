//
//  SelectPhotoManager.m
//  CIEX
//
//  Created by K哥 on 2019/9/20.
//  Copyright © 2019 K哥. All rights reserved.
//

#import "SelectPhotoManager.h"
#import "TZImagePickerController.h" 
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface SelectPhotoManager()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) PHAsset *selectedAsset;

@property (nonatomic, strong) UIImage *selectedPhoto;

@end

@implementation SelectPhotoManager

+ (instancetype)shareManager {
    static SelectPhotoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SelectPhotoManager alloc] init];
    });
    
    return manager;
}

//更换头像
#pragma mark - UIImagePickerController
- (void)takePhotoCompletion:(void (^)(UIImage * _Nonnull))completion {
    
    self.completion = completion;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        [self creatAlertController_alert:@"无法访问相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机"];
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhotoCompletion:self.completion];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        [self creatAlertController_alert:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册"];
        
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhotoCompletion:self.completion];
        }];
    } else {
        [self pushImagePickerController];
    }
}

- (void)pushTZImagePickerControllerCompletion:(void (^)(UIImage * _Nonnull))completion {
    
    self.completion = completion;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.cropRect = CGRectMake(0,(kScreenHeight-kScreenWidth)/2, kScreenWidth, kScreenWidth);
    imagePickerVc.needCircleCrop = NO;
    // 设置横屏下的裁剪尺寸
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    // 设置首选语言 / Set preferred language
    imagePickerVc.preferredLanguage = @"zh-Hans";
    imagePickerVc.modalPresentationStyle = 0;
#pragma mark - 到这里为止
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    }];
    [[CommonTools currentViewController] presentViewController:imagePickerVc animated:YES completion:nil];
}


-(void)creatAlertController_alert:(NSString *)title message:(NSString *)message {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    //相当于之前的[actionSheet show];
    [[CommonTools currentViewController] presentViewController:actionSheet animated:YES completion:nil];
    
    
}
// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        [mediaTypes addObject:(NSString *)kUTTypeImage];
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [[CommonTools currentViewController] presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        KKLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    tzImagePickerVc.sortAscendingByModificationDate = YES;
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:nil completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                KKLog(@"图片保存失败 %@",error);
            } else {
                self->_selectedPhoto = image;
                [self uploadImage];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    
    _selectedAsset = asset;
    _selectedPhoto = image;
    [self uploadImage];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        KKLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//上传头像
- (void)uploadImage {
    if (self.selectedPhoto) {
        if (self.completion) {
            self.completion(self.selectedPhoto);
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // KKLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhoto = photos.firstObject;
    _selectedAsset = assets.firstObject;
    [self uploadImage];
    // 2.图片位置信息
    for (PHAsset *phAsset in assets) {
        KKLog(@"location:%@",phAsset.location);
    }
    
}

// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}
// 决定asset显示与否
- (BOOL)isAssetCanBeDisplayed:(PHAsset *)asset {
    return YES;
}

- (UIImagePickerController *)imagePickerVc {
    
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = [CommonTools currentViewController].navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = [CommonTools currentViewController].navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    
    return _imagePickerVc;
}


@end
