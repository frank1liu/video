//
//  MineInfoViewController.m
//  SportNews
//
//  Created by kkk on 2020/12/4.
//

#import "MineInfoViewController.h"
#import "MineInfoTableViewCell.h"
#import "KKActionSheet.h"
#import "SelectPhotoManager.h"
#import "ChangeNameAndSignController.h"
#import "ChangeGenderViewController.h"
#import "ChangeSetPasswordViewController.h"
#import "SNChangeNameView.h"


UIImage *gChangedImage = nil;


@interface MineInfoViewController ()
 
@end


@implementation MineInfoViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
     
    [self setupSubViews];
      
}

- (void)setupSubViews {
          
    self.titleString = @"用户信息";
    self.datasArray = @[@[@"更换头像",@"手机号",@"微信",@"用户ID",@"昵称"]/*,@[@"修改密码"]*/].mutableCopy;
    self.navView.hiddenLineView = NO;
    self.tableView.frame = CGRectMake(0, NavHeight, kScreenWidth, kScreenHeight-NavHeight-100-xBottomHeight);
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsZero;
    
    if (self.isLeftPush) {
        UIButton *outBtn = [[UIButton alloc] initWithFrame:CGRectMake(15.5, kScreenHeight-15-50-xBottomHeight, kScreenWidth-31, 50)];
        [outBtn addTarget:self action:@selector(outLoginAction) forControlEvents:UIControlEventTouchUpInside];
        [outBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [outBtn setBackgroundImage:[UIImage imageNamed:@"Rectanglebeijng"] forState:UIControlStateNormal];
        outBtn.layer.cornerRadius = 25;
        [self.view addSubview:outBtn];
    }

}
 
- (void)saveAction:(NSString *)text {
     
    [KYRemindView show];
    LoginUserModel *loginModel = [UserModelTool loginModel];
    NSDictionary *param = @{
        @"uid":loginModel.userinfo.ids,
        @"token":loginModel.token,
        @"value":text,
        @"edittype":@(2),
    };
    [KYApiHttpTool GET:URL_ChangeInfo withParams:param success:^(NSDictionary * _Nonnull response) {
        [MBProgressHUD showSuccess:@"修改成功" toView:nil];
        loginModel.userinfo.nickname = text;
        [UserModelTool save:loginModel];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
       
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datasArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.datasArray[section] count];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MineInfoTableViewCell *cell = [MineInfoTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    cell.arrowImageView.hidden = NO;
    cell.iconImageView.hidden = YES;
    cell.subTitleLabel.hidden = NO;
    cell.lineView.hidden = NO;
    cell.titleLeft.constant = 15;
    cell.subRight.constant = 26;
    cell.backView.layer.cornerRadius = 0;
    cell.backView.layer.mask = nil;
    LoginUserModel *loginModel = [UserModelTool loginModel];
    NSArray *array = self.datasArray[indexPath.section];
    NSString *title = array[indexPath.row];
    cell.titleLabel.text = title;
    cell.backView.width = kScreenWidth-30;
    cell.backView.height = 50;
    if ([title isEqualToString:@"更换头像"]) {
        cell.arrowImageView.hidden = YES;
        cell.iconImageView.hidden = NO;
        cell.subTitleLabel.hidden = YES;
        cell.titleLeft.constant = 72.5;
        if (self.iconImage) {
            cell.iconImageView.image = self.iconImage;
        }else {
            if (gChangedImage != nil) {
                cell.iconImageView.image = gChangedImage;
            } else {
                [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:loginModel.userinfo.head] placeholderImage:UIImageMake(@"personDef")];
            }
        }
        cell.backView.height = 72;
        [cell.backView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(8, 8)];
    }else if ([title isEqualToString:@"手机号"]) {
        cell.arrowImageView.hidden = YES;
        cell.subRight.constant = 15;
        cell.subTitleLabel.text = loginModel.userinfo.mobile;
    }else if ([title isEqualToString:@"微信"]) {
        cell.arrowImageView.hidden = YES;
        cell.subRight.constant = 15;
        cell.subTitleLabel.text = @"快直播";
    }else if ([title isEqualToString:@"用户ID"]) {
        cell.arrowImageView.hidden = YES;
        cell.subRight.constant = 15;
        cell.subTitleLabel.text = loginModel.uid;
    }else if ([title isEqualToString:@"昵称"]) {
        cell.lineView.hidden = YES;
        // cell.arrowImageView.hidden = NO;
        // cell.subRight.constant = 15;
        cell.subTitleLabel.text = loginModel.userinfo.nickname;
        [cell.backView addRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(8, 8)];
    }else if ([title isEqualToString:@"修改密码"]) {
        cell.arrowImageView.hidden = YES;
        cell.subTitleLabel.hidden = YES;
        cell.lineView.hidden = YES;
        cell.backView.layer.cornerRadius = 8;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.datasArray[indexPath.section];
    NSString *title = array[indexPath.row];
    if ([title isEqualToString:@"更换头像"]) {
        // [self showSheetView];
        [self openImageAction];
    }else if ([title isEqualToString:@"手机号"]) {
        
    }else if ([title isEqualToString:@"微信"]) {
        
    }else if ([title isEqualToString:@"昵称"]) {
        SNChangeNameView *nameView = [[SNChangeNameView alloc] initWithFrame:self.view.bounds];
        WeakSelf
        nameView.updateNameBlock = ^(NSString * _Nonnull text) {
            [weakSelf saveAction:text];
        };
        [nameView showView];
//        ChangeNameAndSignController *VC = [[ChangeNameAndSignController alloc] init];
//        VC.whichOne = 2;
//        VC.changeSuccess = ^{
//            [tableView reloadData];
//        };
//        [self.navigationController pushViewController:VC animated:YES];
    }else if ([title isEqualToString:@"修改密码"]) {
//        ChangeSetPasswordViewController *VC = [[ChangeSetPasswordViewController alloc] init];
//        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.datasArray[indexPath.section];
    NSString *title = array[indexPath.row];
    if ([title isEqualToString:@"更换头像"]) {
        return 72;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
  
- (void)showSheetView {
    
    WeakSelf
    [KKActionSheet showWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从相册选择"] selectedBlock:^(NSInteger index) {
        if (index == 1) {
            [[SelectPhotoManager shareManager] takePhotoCompletion:^(UIImage * _Nonnull selectImage) {
                [weakSelf uploadImageView:selectImage];
            }];
        }else if (index == 2) {
            [[SelectPhotoManager shareManager] pushTZImagePickerControllerCompletion:^(UIImage * _Nonnull selectImage) {
                [weakSelf uploadImageView:selectImage];
            }];
        }
    }];
}

- (void)uploadImageView:(UIImage *)image {
    self.iconImage = image;
    [MBProgressHUD showLoadToView:self.view title:@"上传图片..."];
    LoginUserModel *loginModel = [UserModelTool loginModel];

    // 用post method
    NSDictionary *param = @{
        @"uid"      : loginModel.userinfo.ids,
        @"token"    : loginModel.token,
        @"edittype" : @"1",           // edittype 为1是 修改头像 ，2为修改昵称
        @"pid"      : @"1"
    };
    
    [KYApiHttpTool UploadImage:URL_UploadImage withParams:param withImages:@[image] success:^(NSDictionary * _Nonnull response) {
        [MBProgressHUD showSuccess:@"修改成功" toView:nil];
        [KYImageTool SaveImageToLocal:image Keys:[NSString stringWithFormat:@"%@%@",loginModel.userinfo.ids,headImageFilePath]];
        self.iconImage = image;
        [self.tableView reloadData];
        if (self.successUploadImage) {
            self.successUploadImage(image);
        }
        
    } failure:^(NSError * _Nullable error) {
        
    }];
    
}

- (void)outLoginAction {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertT = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self loginOutAction];
    }];
    UIAlertAction *alertF = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [[actionSheet popoverPresentationController] setSourceView:self.view];
    [[actionSheet popoverPresentationController] setSourceRect:CGRectMake(0,0,1,1)];
    [[actionSheet popoverPresentationController] setPermittedArrowDirections:UIPopoverArrowDirectionUp];
    [actionSheet addAction:alertT];
    [actionSheet addAction:alertF];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)loginOutAction {
    [KYRemindView show];
    LoginUserModel *loginModel = [UserModelTool loginModel];
    NSDictionary *param = @{
        @"uid":loginModel.userinfo.ids,
        @"token":loginModel.token
    };

//    [UserModelTool save:nil];
//    [self.navigationController popViewControllerAnimated:YES];

    [KYApiHttpTool GET:URL_LoginOut withParams:param success:^(NSDictionary * _Nonnull response) {
        NSLog(@"[Adam][退出登入]请求：%@", URL_LoginOut);
        if ([response[@"code"] isEqualToString:@"0"]) {
            NSLog(@"[Adam][退出登入] 失敗");
            [UserModelTool save:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
        }else{
            NSLog(@"[Adam][退出登入] 成功");
            [MBProgressHUD showSuccess:@"退出登录失败!" toView:nil];
        }
    } failure:^(NSError * _Nonnull error) {
       
    }];

}

- (void)openImageAction {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"请选择照片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertC = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // [self loginOutAction];
        [self takePhoto];
    }];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // [self loginOutAction];
        [self selectPhoto];
    }];
    UIAlertAction *alertF = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [actionSheet addAction:alertC];
    [actionSheet addAction:alertA];
    [actionSheet addAction:alertF];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.iconImage = chosenImage;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];

    //now try to access cell object by passing cell indexPath
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    // MineInfoTableViewCell *cell = [MineInfoTableViewCell cellWithTableView:tableView];
    MineInfoTableViewCell *cell2 = (MineInfoTableViewCell *)cell;
    cell2.iconImageView.image = self.iconImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    // [self uploadImageView:self.iconImage];
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"ChangedIconNotification" object:@{@"icon": self.iconImage} userInfo:nil];
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(self.iconImage) forKey:@"gChangedImage"];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
  
@end
