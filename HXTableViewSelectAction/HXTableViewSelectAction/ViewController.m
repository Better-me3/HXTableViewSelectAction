//
//  ViewController.m
//  HXTableViewSelectAction
//
//  Created by hanxiaoqing on 16/9/2.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+ActionItem.h"

static NSString * const Id = @"usercell";

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *userItemList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.userItemList registerClass:[UITableViewCell class] forCellReuseIdentifier:Id];
    
    [self addCellItems];
}

- (void)addCellItems {
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor whiteColor];
    vc1.title = @"修改密码";
    [self addItemMaterial:@"修改密码" actionController:vc1];
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor whiteColor];
    vc2.title = @"绑定手机";
    [self addItemMaterial:@"绑定手机" actionController:vc2];
    
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.view.backgroundColor = [UIColor whiteColor];
    vc3.title = @"个人收藏";
    [self addItemMaterial:@"个人收藏" actionController:vc3];
    
    __weak typeof(self) weakSelf = self;
    [self addItemMaterial:@"分享给朋友" selectionAction:^{
        [weakSelf alertWithMessage:@"确定要分享吗"];
    }];
    
}


- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actionItemCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    cell.textLabel.text = [self itemMaterialForIndexRow:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self doItemPushActionForIndexRow:indexPath.row];
}

@end
