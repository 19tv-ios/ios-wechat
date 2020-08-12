//
//  AddressViewController.m
//  demo
//
//  Created by fu00 on 2020/8/7.
//  Copyright © 2020 fu00. All rights reserved.
//

#import "AddressViewController.h"
#import <JMessage/JMessage.h>
#import "DetailVc.h"
#import "AddFriendsVc.h"
#import "newFriendsVc.h"
#import "RemarkVc.h"
@interface AddressViewController ()<JMessageDelegate,UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchResultsUpdating>
//朋友数组
@property (nonatomic,strong) NSMutableArray *userArray;
//排序后的section数组
@property (nonatomic,strong) NSMutableArray *sectionArray;
//首字母数组
@property (nonatomic,strong) NSMutableArray *indexArray;
//行数组
@property (nonatomic,strong) NSMutableArray *rowArray;
//#数组(包括字母、数字)
@property (nonatomic,strong) NSMutableArray *specialArray;
//新的朋友Vc
@property (nonatomic,strong) newFriendsVc *FriendsVc;
//新的朋友tableview
@property (nonatomic,strong) UITableView *tab;

//当前登陆用户
@property (nonatomic,strong) JMSGUser *user;



@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //聊天页
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]  initWithTarget: self  action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
    
   
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"address"];

    //获取当前登陆的用户信息
    self.user = [JMSGUser myInfo];
    
    //导航条右侧按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"添加好友"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonWay) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];

    //新的朋友数组
    if (self.userModelArray == nil) {
        self.userModelArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    
    if (self.userArray == nil) {
        self.userArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    if (self.sectionArray == nil) {
        self.sectionArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    if (self.indexArray == nil) {
        self.indexArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    //添加监听代理
    [JMessage addDelegate:self withConversation:nil];
    
    //同步滑动
    UIScrollView *scrView = [[UIScrollView alloc]init];
    scrView.contentSize = CGSizeMake(self.view.width, [UIScreen mainScreen].bounds.size.height-170);
    scrView.showsVerticalScrollIndicator = NO;
    scrView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrView];
    scrView.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view);
    
    
    //新的朋友tableview
    self.tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.tab.tag = 1;
    self.tab.delegate = self;
    self.tab.dataSource = self;
    self.tab.scrollEnabled = NO;
    [scrView addSubview:self.tab];
    self.tab.sd_layout.topSpaceToView(scrView, 0).leftEqualToView(scrView).rightEqualToView(scrView).heightIs(80);
    
    
    //展示好友的uitableview
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.tableView.tag = 2;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [scrView addSubview:self.tableView];
    self.tableView.sd_layout.topSpaceToView(scrView, 44).leftEqualToView(scrView).rightEqualToView(scrView).bottomEqualToView(scrView);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"address"];
    

    //拿出本地好友请求
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@",path);
    NSString *filePath = [path stringByAppendingPathComponent:[NSString  stringWithFormat:@"%@userModelArray.plist",self.user.username]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.userModelArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //未读好友请求
    self.tabBarItem.badgeValue = nil;
    if (_userModelArray.count != 0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",self.userModelArray.count];
    }
    
    
   //搜索框
    UISearchController *search = [[UISearchController alloc] initWithSearchResultsController:nil];
    search.searchResultsUpdater = self;
    search.dimsBackgroundDuringPresentation = false;
    search.searchBar.backgroundColor = [UIColor clearColor];
    
    //设置边框的内部颜色 及边框宽度 圆角
    UIView* searchTextField = [[[search.searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.layer.borderWidth = 1;
    searchTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchTextField.layer.cornerRadius = 10.0f;
    for(UIView* view in search.searchBar.subviews){
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    search.searchBar.placeholder = @"搜索联系人";
    [search.searchBar sizeToFit];
    search.delegate = self;
    self.navigationItem.searchController = search;
    
    //更新通讯录列表
    [self updateFriendsList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}


//更新通讯录页面
- (void)updateFriendsList{
    //    获取好友列表
    [JMSGFriendManager getFriendList:^(id resultObject, NSError *error) {
        NSArray *array = resultObject;
        self.userArray = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<array.count; i++) {
            JMSGUser *user = array[i];
            [self.userArray addObject:user];
        }
        
        //重置数组
        self.indexArray = [NSMutableArray arrayWithCapacity:0];
        self.sectionArray = [NSMutableArray arrayWithCapacity:0];
        //好友列表排序
        [self FriendsSort];
    }];

    //更新未读数
    [self.tab reloadData];
    self.tabBarItem.badgeValue = nil;
    if (_userModelArray.count != 0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",self.userModelArray.count];
    }
}

// 按首字母分组排序数组
- (void)FriendsSort {
    
    //中文昵称排序
    for (char c='A';c<='Z';c++) {
        NSInteger i = 0;
        self.rowArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger j = 0;j<self.userArray.count; j++) {
            JMSGUser *user = self.userArray[j];
            int a = [user.nickname characterAtIndex:i];
            if( a > 0x4e00 && a < 0x9fff){//判断字符串第一个是否是中文
                NSString *pinyin = [self nameChangePinyin:user.nickname];
                NSString *firstChar = [pinyin substringToIndex:1];
                NSString *str = [NSString stringWithFormat:@"%c",c];//字符转字符串
                if ([firstChar isEqualToString:str]) {//判断第一个字发音是否是当前字母，是的话加入rowArray
                    [self.rowArray addObject:user];
                }
            }
            
           
        }
        if (self.rowArray.count != 0) {
            [self.sectionArray addObject:self.rowArray];
            [self.indexArray addObject:[NSString stringWithFormat:@"%c",c]];
        }
        i+=1;
    }
    
    //特殊昵称排序
    self.specialArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = 0; i<self.userArray.count; i++) {
        JMSGUser *user = self.userArray[i];
        if (user.nickname == nil) {//判断有无昵称，如果没有用username代替
            unichar first = [user.username characterAtIndex:0];
            if (isdigit(first)||isalpha(first)) {//如果首个字符是数字或者字母
                if (self.specialArray == nil) {
                    self.specialArray = [NSMutableArray arrayWithCapacity:0];
                }
                [self.specialArray addObject:user];
            }
        }else{
            unichar first = [user.nickname characterAtIndex:0];
            if (isdigit(first)||isalpha(first)) {//如果首个字符数字或者字母
                if (self.specialArray == nil) {
                    self.specialArray = [NSMutableArray arrayWithCapacity:0];
                }
                [self.specialArray addObject:user];
            }
        }
    }
    
    if (self.specialArray.count != 0) {
        //如果有内容再加入索引
        [self.indexArray addObject:[NSString stringWithFormat:@"#"]];
        //如果有内容，最后再来添加#特殊数组
        [self.sectionArray addObject:self.specialArray];
    }
 
    [self.tableView reloadData];
}

- (NSString *)nameChangePinyin:(NSString *)nickname{//汉字转拼音
    
    if (nickname == nil) {
        return nil;
    }else{
        NSMutableString *pinyin = [nickname mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
        return [pinyin uppercaseString];//[pinyin uppercaseString]
    }
    
}
#pragma mark tableview右侧索引
//索引标题
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView.tag == 2) {
        return self.indexArray;
    }else{
        return nil;
    }
}
//点击索引响应
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index{
    NSLog(@"%ld",index);
    return index;
}

#pragma mark - Table view data source
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 1) {
        return 1;
    }else{
        return self.sectionArray.count ;//self.indexArray.count
    }
    
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return 1;
    }else{
        NSArray *rowArray = self.sectionArray[section];
        return rowArray.count;//rowArray.count
    }
    
}
//表格头
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return nil; 
    }else{
        return self.indexArray[section];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.imageView.image = [UIImage imageNamed:@"新的朋友"];
        cell.textLabel.text = @"新的朋友";
       
        if (self.userModelArray.count != 0) {
            UILabel *countLabel = [[UILabel alloc]init];
            countLabel.text = [NSString stringWithFormat:@"%ld",self.userModelArray.count];
            countLabel.textColor = [UIColor whiteColor];
            countLabel.textAlignment = NSTextAlignmentCenter ;
            countLabel.frame = CGRectMake(0, 0, 20, 20);
            countLabel.layer.masksToBounds = YES;
            countLabel.layer.cornerRadius = 10;
            
            UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(300, 13, 20, 20)];
            backgroundView.backgroundColor = [UIColor redColor];
            backgroundView.layer.masksToBounds = YES;
            backgroundView.layer.cornerRadius = 10;
            [backgroundView addSubview:countLabel];
            [cell.contentView addSubview:backgroundView];
        }

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        static NSString* reuseID = @"address";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }else{
            while ([cell.contentView.subviews lastObject] !=nil) {
                [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
        NSArray *rowArray = self.sectionArray[indexPath.section];
        JMSGUser *user = rowArray[indexPath.row];
        
        cell.imageView.sd_layout.topSpaceToView(cell.contentView, 8).heightIs(30).widthIs(30);
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.cornerRadius = 5;
        if (cell.imageView.image == nil) {
            [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
                if (data == nil) {
                   cell.imageView.image = [UIImage imageNamed:@"未知头像"];
                }else{
                    cell.imageView.image  = [UIImage imageWithData:data];
                }
                //刷新该行
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }
       
        if (user.nickname == nil) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@",user.username];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@",user.nickname];
        }
        
 
        //设置cell为编辑效果
        cell.editingAccessoryType = UITableViewCellAccessoryDetailButton;

        return cell;
    }
    
}



#pragma mark 监听方法
- (void)rightButtonWay{
    AddFriendsVc *Vc = [[AddFriendsVc alloc]init];
    Vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Vc animated:YES];
    
}

- (void)onReceiveFriendNotificationEvent:(JMSGFriendNotificationEvent *)event{
    NSLog(@"reson:%@",event.getReason);
    NSLog(@"username:%@",event.getFromUsername);
    
    //本地取出历史添加请求(先取出、再存进去)
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString  stringWithFormat:@"%@userModelArray.plist",self.user.username]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.userModelArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];//取出来
    if (self.userModelArray == nil) {
        self.userModelArray = [NSMutableArray arrayWithCapacity:0];
    }
    [self.userModelArray addObject:event.getFromUser];
    
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:self.userModelArray];
    [data1 writeToFile:filePath atomically:YES];//存进去
    
    if (self.userModelArray.count != 0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",self.userModelArray.count];
    }
    
    //刷新第一行第一个（新的朋友cell）
    [self.tab reloadData];
    
    //刷新新的朋友Vc
    [self.FriendsVc.tab reloadData];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        self.FriendsVc = [[newFriendsVc alloc]init];
        self.FriendsVc.hidesBottomBarWhenPushed = YES;
        self.FriendsVc.userModelArray = self.userModelArray;
        self.FriendsVc.user = self.user;
        [self.navigationController pushViewController:self.FriendsVc animated:YES];
        NSLog(@"新的朋友页面");
    }else{
        DetailVc *Vc = [[DetailVc alloc]init];
        NSArray *rowArray =  self.sectionArray[indexPath.section];
        Vc.user = rowArray[indexPath.row];
        Vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:Vc animated:YES];
        NSLog(@"%@",Vc.user.username);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    searchController.obscuresBackgroundDuringPresentation = YES;
}
-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - tableView右滑

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        UISwipeActionsConfiguration *config = [[UISwipeActionsConfiguration alloc]init];
        return config;
    }else{
        UIContextualAction *RemarkAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"备注" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            RemarkVc *Vc = [[RemarkVc alloc]init];
            Vc.user = self.user;
            [self.navigationController pushViewController:Vc animated:YES];
        }];
        RemarkAction.backgroundColor = [UIColor grayColor];
        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"确定删除该好友吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [JMSGFriendManager removeFriendWithUsername:self.user.username appKey:@"0a974aa68871f642444ae38b" completionHandler:^(id resultObject, NSError *error) {
                    if (error == nil) {NSLog(@"删除好友成功");}
                    [self updateFriendsList];
                }];
            }];
            UIAlertAction *disagreeAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
            [AlertController addAction:agreeAction];
            [AlertController addAction:disagreeAction];
            [self presentViewController:AlertController animated:YES completion:nil];
        }];
        deleteAction.backgroundColor = [UIColor redColor];
        UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction,RemarkAction]];
        config.performsFirstActionWithFullSwipe = NO;
        return config;
    }
   
}
@end

