
//
//  UIViewController+SelectedItem.m
//  BestAssistantForGame
//
//  Created by hanxiaoqing on 16/9/2.
//  Copyright © 2016年 Babeltime. All rights reserved.
//

#import "UIViewController+ActionItem.h"
#import <objc/runtime.h>

static const char itemArrayKey = '\1';
static const char itemDicKey = '\2';

@implementation UIViewController (SelectedItem)

// 存放cell item数据的数组
- (NSMutableArray *)itemMaterialArray {
    NSMutableArray *itemMaterialArray = objc_getAssociatedObject(self, &itemArrayKey);
    if (itemMaterialArray) {
        return itemMaterialArray;
    }
    itemMaterialArray = [NSMutableArray array];
    objc_setAssociatedObject(self, &itemArrayKey, itemMaterialArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return itemMaterialArray;
}
// 存放 item数据 对应控制器 map
- (NSMutableDictionary *)itemControllerDic {
    NSMutableDictionary *itemControllerDic = objc_getAssociatedObject(self, &itemDicKey);
    if (itemControllerDic) {
        return itemControllerDic;
    }
    itemControllerDic = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &itemDicKey, itemControllerDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return itemControllerDic;
}

- (void)addItemMaterial:(id)item actionController:(UIViewController *)controller {
    
    if (![self.itemMaterialArray containsObject:item]) {
        [self.itemMaterialArray addObject:item];
    }
    [self.itemControllerDic setObject:controller forKey:item];
}

- (void)addItemMaterial:(id)item selectionAction:(actonBlcok)block
{
    if (![self.itemMaterialArray containsObject:item]) {
        [self.itemMaterialArray addObject:item];
    }
    [self.itemControllerDic setObject:block forKey:item];
}

- (void)removeItemForIndexRow:(NSInteger)row
{
    [self removeItem:self.itemMaterialArray[row]];
}

- (void)removeItem:(id)item
{
    [self.itemMaterialArray removeObject:item];
    [self.itemControllerDic removeObjectForKey:item];
}


- (NSInteger)actionItemCount
{
    return self.itemMaterialArray.count;
}

- (id)itemMaterialForIndexRow:(NSInteger)row {
    return self.itemMaterialArray[row];
}

- (BOOL)doItemActionForKey:(id)itemKey
{
    id obj = self.itemControllerDic[itemKey];
    // 判断取出值是不是 block类型
    Class cls =  object_getClass(obj);
    NSString *clsString = NSStringFromClass(cls);
    NSRange range = [clsString rangeOfString:@"Block"];
    if (range.location != NSNotFound) {
        actonBlcok block = self.itemControllerDic[itemKey];
        block();
        return YES;
    } else {
        return NO;
    }
}

- (void)doItemPushActionForIndexRow:(NSInteger)row
{
    NSString *itemKey = [self itemMaterialForIndexRow:row];
    if ([self doItemActionForKey:itemKey]) return;
    UIViewController *vc = self.itemControllerDic[itemKey];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)doItemModalActionForIndexRow:(NSInteger)row
{
    NSString *itemKey = [self itemMaterialForIndexRow:row];
    if ([self doItemActionForKey:itemKey]) return;
    UIViewController *vc = self.itemControllerDic[itemKey];
    [self presentViewController:vc animated:YES completion:nil];

}





@end
