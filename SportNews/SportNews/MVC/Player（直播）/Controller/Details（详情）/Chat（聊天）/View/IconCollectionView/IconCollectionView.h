//
//  HomeCategoryViewController.h
//  innerEcommerce
//
//  Created by Frank Liu on 2017/8/17.
//  Copyright © 2017年 Frank Liu. All rights reserved.
//

@interface IconCollectionView : UIViewController
{
    UIRefreshControl    *rc;
    int                 page;
}

@property (nonatomic, weak) IBOutlet UICollectionView *collectView;
@property (nonatomic, weak) IBOutlet UITableView      *listTableView;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, assign) ShowMode showMode;
@property (nonatomic, strong) NSMutableArray *produtModelAry;
@property (nonatomic, strong) ProductModel *listModel;
@property (nonatomic, assign) BOOL isMore;

- (void)setNextPage;

@end
