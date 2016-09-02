# HXTableViewSelectAction



TableView和控制器瘦身利器，一句话搞定TableView代理方法 didSelectRowAtIndexPath 拒绝一坨坨恶心的 if else







##业务场景：
TableView有几个项目item cell，并且有点击item跳转控制器或者执行一些其他代码的操作，通常的代码是：
```objc
 if (indexPath.row == 0) {
    // action.....
 }
 if (indexPath.row == 1) {
    // action.....
 }
 if (indexPath.row == 2) {
    // action.....
 }
``` 

当item数量特别多的时候 if else 就显得特别恶心了。。

为了解决这个问题，给TableView，给控制器瘦身，本分类实现didSelectRowAtIndexPath里面一句话实现item的action
如：
```objc
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
 {
    [self doItemPushActionForIndexRow:indexPath.row];
 }
``` 







## 设计思路
为控制器UIViewController增加一个分类（UIViewController+ActionItem.h）

利用runtime 关联对象，分类内部添加一个数组存放cell item对应的数据（字符串或者数据模型）

还有一个字典key是cell item对应的数据，value对应控制器类或者想要执行的代码块（block）

当点击某个cell didSelectRowAtIndexPath方法被调用的时候取出cell对应的item控制器进行push或者modal,或者执行保存的代码块block










## 使用
```objc


viewDidLoad 里面直接调用控制器分类方法addItemMaterial 确定好每个cell的数据以及对应的要跳转的控制器或者执行的代码
    
    [self.userItemList registerClass:[UITableViewCell class] forCellReuseIdentifier:Id];
    
  
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


```

```objc
**注意**：
addItemMaterial调用几次就会有几个cell 以及对应的item数据。
因此numberOfRowsInSection直接返回UIViewController+ActionItem分类提供的
self.actionItemCount方法即可！

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actionItemCount;
  }

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    // itemMaterialForIndexRow: 返回当初addItemMaterial传进的item数据，这里cell只展示字符串
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
    **精华部分**： 只需一行cell就知道自己应该去做什么
    [self doItemPushActionForIndexRow:indexPath.row];
}

```
## 附加说明
作为tabview 瘦身的初步目的，初步想到这个方案，故简单实现此框架，
肯定会有考虑不周，在某些业务场景下使用出现坑或者不灵活的地方，希望大家多多提意见，
引导此框架健壮发展！thank you！




