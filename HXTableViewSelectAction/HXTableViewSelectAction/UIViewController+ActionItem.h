//
//  UIViewController+SelectedItem.h
//  BestAssistantForGame
//
//  Created by hanxiaoqing on 16/9/2.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 这个功能分类是为了给TableView代理方法 didSelectRowAtIndexPath 瘦身
 
 业务场景：TableView有几个项目item cell，并且有点击item跳转控制器的操作，通常的代码是：
 if (indexPath.row == 0) {
    // action.....
 }
 if (indexPath.row == 1) {
    // action.....
 }
 if (indexPath.row == 2) {
    // action.....
 }
 
 当item数量特别多的时候 if else 就显得特别恶心了。。
 为了解决这个问题，给TableView，给控制器瘦身，本分类实现didSelectRowAtIndexPath里面一句话实现item的action
 如：
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
 {
    [self doItemPushActionForIndexRow:indexPath.row];
 }
 具体的使用的方法:
 参考 ViewController里面 viewDidLoad 以及tableView 相关的方法
 
 **/


typedef void(^actonBlcok)();

@interface UIViewController (ActionItem)

/**
 *  添加cell数据 以及对应要跳转的控制器
 *
 *  @param item       cell对应的的数据（可以是模型可以是字符串）
 *  @param controller 每一个cell对应要跳转的控制器实例
 */
- (void)addItemMaterial:(id)item actionController:(UIViewController *)controller;

/**
 *  添加cell数据 以及点击选中cell要做的操作（block）
 *
 *  @param item  cell对应的的数据（可以是模型可以是字符串）
 *  @param block 每一个cell对应的选中操作代码块
 */
- (void)addItemMaterial:(id)item selectionAction:(actonBlcok)block;


/**
 *  添加的cell 以及item的个数，与addItemMaterial..方法添加次数关联
    addItemMaterial几次actionItemCount就有几次
    注意：!!!!!!!!!!!!!!!!!!!!!!
    一定要在numberOfRowsInSection方法里面返回actionItemCount
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
       return self.actionItemCount;
    }
 */
- (NSInteger)actionItemCount;

/**
 *  根据行号，返回对应添加的cell item的数据（可以是模型可以是字符串）
 *  用作- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    给cell赋值的模型数据
 */
- (id)itemMaterialForIndexRow:(NSInteger)row;

/**
 * 点击cell push 一开始addItemMaterial:actionController:的控制器
 * 注意: 被点击cell当初是添加的blcok，就会执行blcok，
 *  @param row  行号indexPath.row
 */
- (void)doItemPushActionForIndexRow:(NSInteger)row;

/**
 *  点击cell modal 一开始addItemMaterial:actionController:的控制器
 *  注意: 被点击cell当初是添加的blcok，就会执行blcok，
 *  @param row 行号indexPath.row
 */

- (void)doItemModalActionForIndexRow:(NSInteger)row;


/**
 *  删除对应行的item数据
 *
 *  @param row 行号indexPath.row
 */
- (void)removeItemForIndexRow:(NSInteger)row;


@end
