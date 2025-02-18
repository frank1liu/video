//
//  SNFootBallImportantEventsCell.h
//  SportNews
//
//  Created by yang on 2021/1/22.
//

#import <UIKit/UIKit.h>
#import "SNFootBallResult.h"

typedef NS_ENUM(NSInteger,FBImportantEventsCellType) {
    FBImportantEventsCellTypeNeutral,  //中立
    FBImportantEventsCellTypeHome,     //主队
    FBImportantEventsCellTypeVisit,    //客队
    FBImportantEventsCellTypeTime,    //上面的时间
    FBImportantEventsCellTypeShaoZi,    //哨子
};
@class SNFootBallIncidentsModel;

NS_ASSUME_NONNULL_BEGIN

@interface SNFootBallImportantEventsCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(FBImportantEventsCellType )cellType;

//足球直播
@property(nonatomic, strong) SNFootBallResult *resultFootObj;

@property (nonatomic, strong) SNFootBallIncidentsModel     *model;  //

@property(nonatomic, assign) NSInteger position;

@end

@interface SNFootBallImportantTitleView : UIView

- (instancetype)initWithFrame:(CGRect)frame cellType:(FBImportantEventsCellType )cellType;
@property (nonatomic, strong) SNFootBallIncidentsModel     *model;  //

@end


@interface SNFootBallImportantEventsSubCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(FBImportantEventsCellType )cellType indexPathRow:(NSInteger)row ;

@property (nonatomic, strong) SNFootBallIncidentsModel     *model;  //


@end


@interface SNFootBallImportantEventsCenterImageCell : UITableViewCell
 

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
