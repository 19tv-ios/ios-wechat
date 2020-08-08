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
@interface AddressViewController ()<JMessageDelegate,UITableViewDataSource,UITableViewDelegate>
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
//新的朋友的数组模型
@property (nonatomic,strong) NSMutableArray *userModelArray;
//新的朋友Vc
@property (nonatomic,strong) newFriendsVc *FriendsVc;
//uitableview
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航条右侧按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"添加好友"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonWay) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    //导航条左侧按钮
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setImage:[UIImage imageNamed:@"新的朋友"] forState:UIControlStateNormal];
//    [leftButton setTitle:@"新的朋友" forState:UIControlStateNormal];
//    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(leftButtonWay) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
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
    
    //    获取好友列表
    [JMSGFriendManager getFriendList:^(id resultObject, NSError *error) {
        NSArray *array = resultObject;
        for (int i=0; i<array.count; i++) {
            JMSGUser *user = array[i];
            [self.userArray addObject:user];
        }
        //好友列表排序
        [self FriendsSort];
    }];
    
    
    //添加监听代理
    [JMessage addDelegate:self withConversation:nil];
    
    
    //新的朋友tableview
    UITableView *tab = [[UITableView alloc]init];
    tab.tag = 1;
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
    tab.sd_layout.topSpaceToView(self.view, 50).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(80);
    
    
    //展示好友的uitableview
    self.tableView = [[UITableView alloc]init];
    self.tableView.tag = 2;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.topSpaceToView(tab, 0).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view );
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"address"];
    
    //设置tableview的右侧索引
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// 按首字母分组排序数组
- (void)FriendsSort {
    
    //中文昵称排序
    for (char c='A';c<='Z';c++) {
        NSInteger i = 0;
        self.rowArray = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger j = 0;j<self.userArray.count; j++) {
            JMSGUser *user = self.userArray[j];
            NSString *pinyin = [self nameChangePinyin:user.nickname];
            NSString *firstChar = [pinyin substringToIndex:1];
            NSString *str = [NSString stringWithFormat:@"%c",c];//字符转字符串
            if ([firstChar isEqualToString:str]) {//判断第一个字发音是否是当前字母，是的话加入rowArray
                [self.rowArray addObject:user];
            }
        }
        if (self.rowArray.count != 0) {
            [self.sectionArray addObject:self.rowArray];
            [self.indexArray addObject:[NSString stringWithFormat:@"%c",c]];
        }
        i+=1;
    }
    
    //特殊昵称排序
    for (NSInteger i = 0; i<self.userArray.count; i++) {
        JMSGUser *user = self.userArray[i];
        if (user.nickname == nil) {//判断有无昵称，如果没有用username代替
            unichar first = [user.username characterAtIndex:0];
            if (isdigit(first)||isalpha(first)) {//如果首个字符数字或者字母
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
    
    
    
    NSLog(@"section的数量:%ld",self.sectionArray.count);
    NSLog(@"表格头的数量:%ld",self.indexArray.count);
    [self.tableView reloadData];
}

- (NSString *)nameChangePinyin:(NSString *)nickname{//没懂
    
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
        return nil;//[NSString stringWithFormat:@"功能"]
    }else{
        return self.indexArray[section];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.imageView.image = [UIImage imageNamed:@"新的朋友"];
        cell.textLabel.text = @"新的朋友";
        return cell;
    }else{
        static NSString* reuseID = @"address";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
        
        if(!cell){
            cell = [[UITableViewCell alloc]init];
        }
        
        
        NSArray *rowArray = self.sectionArray[indexPath.section];
        JMSGUser *user = rowArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"微信"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",user.nickname];
        
        
        return cell;
    }
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        self.FriendsVc = [[newFriendsVc alloc]init];
        self.FriendsVc.hidesBottomBarWhenPushed = YES;
        
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [path stringByAppendingPathComponent:@"userModelArray.plist"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        self.userModelArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSLog(@"11%@",self.userModelArray);
        self.FriendsVc.userModelArray = self.userModelArray;
        [self.navigationController pushViewController:self.FriendsVc animated:YES];
        NSLog(@"新的朋友页面");
    }else{
        DetailVc *Vc = [[DetailVc alloc]init];
        NSArray *rowArray =  self.sectionArray[indexPath.section];
        Vc.user = rowArray[indexPath.row];
        NSLog(@"%@",Vc.user.username);
        Vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:Vc animated:YES];
        NSLog(@"%ld---%ld",indexPath.section,indexPath.row);
    }
   
  
    
}


#pragma mark 监听方法
- (void)rightButtonWay{
    AddFriendsVc *Vc = [[AddFriendsVc alloc]init];
    Vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Vc animated:YES];
    
}
- (void)leftButtonWay{
    self.FriendsVc = [[newFriendsVc alloc]init];
    self.FriendsVc.hidesBottomBarWhenPushed = YES;
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"userModelArray.plist"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.userModelArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.FriendsVc.userModelArray = self.userModelArray;
    [self.navigationController pushViewController:self.FriendsVc animated:YES];
    NSLog(@"新的朋友页面");
}
- (void)onReceiveFriendNotificationEvent:(JMSGFriendNotificationEvent *)event{
    NSLog(@"reson:%@",event.getReason);
    NSLog(@"username:%@",event.getFromUsername);
    [self.userModelArray addObject:event.getFromUser];
    
    //本地储存历史添加请求
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"userModelArray.plist"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userModelArray];
    [data writeToFile:filePath atomically:YES];
    
    //刷新新的朋友Vc
    [self.FriendsVc.tab reloadData];
    
    
}

@end

