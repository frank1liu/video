//
//  SNOtherLiveModel.h
//  SportNews
//
//  Created by kkk on 2021/5/6.
//

#import <Foundation/Foundation.h>
#import "LiveCartoonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNOtherLiveModel : NSObject

@property(nonatomic, assign) NSInteger islive;

@property(nonatomic, assign) NSInteger sports_type;

@property(nonatomic, assign) NSInteger ids;

@property(nonatomic, assign) NSInteger status;

@property(nonatomic, copy) NSString *matchtime;
@property(nonatomic, copy) NSString *ateam;
@property(nonatomic, copy) NSString *coverurl;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *hteam;
@property(nonatomic, copy) NSString *cname;

@property(nonatomic, strong) NSArray<LiveCartoonModel *> *live_urls;

 
@end

NS_ASSUME_NONNULL_END
