//
//  SelectPhotoManager.h
//  CIEX
//
//  Created by K哥 on 2019/9/20.
//  Copyright © 2019 K哥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectPhotoManager : NSObject

@property (nonatomic, copy) void(^completion)(UIImage *selectImage);

+ (instancetype)shareManager;

- (void)takePhotoCompletion:(void (^)(UIImage *selectImage))completion;

- (void)pushTZImagePickerControllerCompletion:(void (^)(UIImage *selectImage))completion;
@end

NS_ASSUME_NONNULL_END
