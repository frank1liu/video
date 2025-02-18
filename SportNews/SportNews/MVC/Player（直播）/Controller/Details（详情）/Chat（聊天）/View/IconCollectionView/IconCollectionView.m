//
//  HomeCategoryViewController.m
//  innerEcommerce
//
//  Created by Frank Liu on 2017/8/17.
//  Copyright © 2017年 Frank Liu. All rights reserved.
//

#import "IconCollectionView.h"
#import "IconCell.h"

static NSString * const CellIdentifier = @"ProductCell";

@interface IconCollectionView ()
{
    UIView  *collFoot;
}
@end

@implementation IconCollectionView
@synthesize produtModelAry;
@synthesize categoryID;
@synthesize showMode;
@synthesize listModel;
@synthesize collectView;
@synthesize listTableView;
@synthesize isMore;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.collectView registerNib:nib forCellWithReuseIdentifier:CellIdentifier];
}

- (void)refresh:(UIRefreshControl *)refreshControl
{
    if (rc.refreshing) {
        [self refreshProductList];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (showMode == INNERPPRODUCTMODE) {
        
        self.collectView.frame = CGRectMake(self.collectView.frame.origin.x,
                                            self.collectView.frame.origin.y,
                                            self.collectView.frame.size.width,
                                            self.collectView.frame.size.height +
                                            self.app.tabBarController.tabBar.frame.size.height);
    }
}

- (void)refreshProductList
{
    if (showMode == PRODUCTMODE || showMode == INNERPPRODUCTMODE) {
        NSDictionary *dic = @{@"category_id" : categoryID};
        
        [[APIManager singleton].apiProduct getProduct:YES data:dic callBack:^(id JSON) {
            NSDictionary *dic = JSON[@"data"];
            ProductCategoryListModel *productModel = [MTLJSONAdapter modelOfClass:[ProductCategoryListModel class] fromJSONDictionary:dic error:nil];
            [produtModelAry removeAllObjects];
            for (ProductInfoModel *info in productModel.products) {
                [produtModelAry addObject:info];
            }
            [self.collectView reloadData];
            if (rc) {
                [rc endRefreshing];
            }
            isMore = YES;
            page = 1;
        }];
    }
    else{
        
    }
}

- (void)setNextPage
{
    NSDictionary *dic = @{@"category_id" : @([self.categoryID intValue]),
                          @"page"        : @(page)};
    
    [[APIManager singleton].apiProduct getProduct:YES data:dic callBack:^(id JSON) {
        NSDictionary *dic = JSON[@"data"];
        ProductCategoryListModel *productModel = [MTLJSONAdapter modelOfClass:[ProductCategoryListModel class] fromJSONDictionary:dic error:nil];
        if (productModel.products.count == 0)
            isMore = NO;
        else{
            for (ProductInfoModel *info in productModel.products) {
                [self.produtModelAry addObject:info];
            }
        }
        [self.collectView reloadData];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height)
    {
        if (isMore) {
            page++;
            [self setNextPage];
        }
    }
    else if(showMode == INNERPPRODUCTMODE){
        if (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height) == 49) {
            if (isMore) {
                page++;
                [self setNextPage];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.produtModelAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dic = self.produtModelAry[indexPath.row];
    ProductInfoModel *info = [MTLJSONAdapter modelOfClass:[ProductInfoModel class] fromJSONDictionary:dic error:nil];
    if(info.photos.count > 0){
        NSDictionary *dict = info.photos[0];
        ProductPhotosModel *photo = [MTLJSONAdapter modelOfClass:[ProductPhotosModel class] fromJSONDictionary:dict error:nil];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@/%@", BaseURL, photo.path]]];
    }
    cell.labInfo.text = info.productName;
    [cell.labPriceOrig setText:[NSString stringWithFormat:@"¥%@", info.listPrice]];
    [cell setStrikeThrough:cell.labPriceOrig];
    [cell.labPriceNew setText:[NSString stringWithFormat:@"¥%@", [CommonUtility formatCurrencyWithString:info.employeePrice]]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    UICollectionReusableView *reusableview = nil;
    
    /*
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *fview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview = (UICollectionReusableView*)fview;
        
        //[reusableview addSubview:headerImgView];
    }
    */
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *fview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        reusableview = (UICollectionReusableView*)fview;
        
        if (self.produtModelAry.count >= 5) {
            [reusableview addSubview:collFoot];
        }
    }
    
    return reusableview;
}

/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320.0f, 40.0f);
}
*/

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (!isMore || self.produtModelAry.count == 0) {
        return CGSizeMake(0, 0);
    }else {
        return CGSizeMake(320, 40);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.produtModelAry[indexPath.row];
    ProductInfoModel *info = [MTLJSONAdapter modelOfClass:[ProductInfoModel class] fromJSONDictionary:dic error:nil];
    ProductInfoViewController *infoView = [[ProductInfoViewController alloc]init];
    infoView.infoModel = info;
    [self.navigationController pushViewController:infoView animated:YES];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)cv layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5,5,5,5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(152, 235);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *ary = self.listModel.children;
    return ary.count;
}

- (void)deselect
{
    [self.listTableView deselectRowAtIndexPath:[self.listTableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
    
    NSArray *ary = self.listModel.children;
    NSDictionary *dic = ary[indexPath.row];
    ProductModel *dataModel = [MTLJSONAdapter modelOfClass:[ProductModel class] fromJSONDictionary:dic error:nil];
    NSDictionary *dicData = @{@"category_id" : dataModel._id};
    
    [[APIManager singleton].apiProduct getProduct:YES data:dicData callBack:^(id JSON) {
        NSDictionary *dic = JSON[@"data"];
        ProductCategoryListModel *productModel = [MTLJSONAdapter modelOfClass:[ProductCategoryListModel class] fromJSONDictionary:dic error:nil];
        HomeCategoryViewController *vc = [[HomeCategoryViewController alloc]init];
        vc.categoryID = [dataModel._id stringValue];

        vc.collectView.hidden = NO;
        vc.listTableView.hidden = YES;
        vc.showMode = INNERPPRODUCTMODE;
        vc.produtModelAry = [NSMutableArray new];
        for (ProductInfoModel *info in productModel.products) {
            [vc.produtModelAry addObject:info];
        }
        vc.title = dataModel.productCategory;
        [vc.collectView reloadData];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = HexColor(GrayColor, 1.0);
    NSArray *ary = self.listModel.children;
    NSDictionary *dic = ary[indexPath.row];
    cell.textLabel.text = dic[@"productCategory"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentInfoModel *info = [self.dataArray objectAtIndex:indexPath.row];
    
    NSArray *fullRule = @[@"unpaid",@"contact",@"pending",@"paid",@"failed"];
    if ([fullRule containsObject:info.status])
        return 180;
    else
        return 130;
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
