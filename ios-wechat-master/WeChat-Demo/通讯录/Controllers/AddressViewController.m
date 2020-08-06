//
//  AddressViewController.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "AddressViewController.h"

#import "AddressViewController.h"
#import <JMessage/JMessage.h>
#import "DetailVc.h"
#import "AddFriendsVc.h"
#import "newFriendsVc.h"
@interface AddressViewController ()<JMessageDelegate>
//组数组
@property (nonatomic,strong) NSMutableArray *nameSectionsArray;
//模型数组
@property (nonatomic,strong) NSMutableArray *userArray;
//新的朋友的数组模型
@property (nonatomic,strong) NSMutableArray *userModelArray;
//新的朋友Vc
@property (nonatomic,strong) newFriendsVc *FriendsVc;
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *leftButton = [[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"添加好友"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonWay) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    //新的朋友数组
    if (self.userModelArray == nil) {
        self.userModelArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    
    if (self.userArray == nil) {
        self.userArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    //    获取好友列表
    [JMSGFriendManager getFriendList:^(id resultObject, NSError *error) {
        NSArray *array = resultObject;
        for (int i=0; i<array.count; i++) {
            JMSGUser *user = array[i];
            [self.userArray addObject:user];
        }
    }];
    
        //添加监听代理
        [JMessage addDelegate:self withConversation:nil];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"address"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)nameArrange{
    // 按首字母分组排序数组
    
    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = 27;
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    _nameSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [_nameSectionsArray addObject:array];
    }
    
    //        //将每个名字分到某个section下
    //        for (PersonModel *personModel in _contactsArr) {
    //            //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
    //            NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:@selector(name)];
    //            //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
    //            NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
    //            [sectionNames addObject:personModel];
    //        }
    
    //        //对每个section中的数组按照name属性排序
    //        for (NSInteger index = 0; index < sectionTitlesCount; index++) {
    //            NSMutableArray *personArrayForSection = newSectionsArray[index];
    //            NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(name)];
    //            newSectionsArray[index] = sortedPersonArrayForSection;
    //        }
    
    //删除空的数组
    //            NSMutableArray *finalArr = [NSMutableArray new];
    //            for (NSInteger index = 0; index < sectionTitlesCount; index++) {
    //                if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
    //                    [finalArr addObject:newSectionsArray[index]];
    //                }
    //            }
    //            return finalArr;
    
}

#pragma mark - Table view data source
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;//self.nameSectionsArray.count
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSArray *array = self.nameSectionsArray[section];
    return 1;//array.count
}
//表格头
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"A";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseID = @"address";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    
    if(!cell){
        cell = [[UITableViewCell alloc]init];
    }
    
    
//    NSArray *sectionArray = _nameSectionsArray[indexPath.section];
//    id model = sectionArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"微信"];
    cell.textLabel.text = @"1111";
    
    if ((indexPath.section == 0)&&(indexPath.row == 0)) {
        cell.imageView.image = [UIImage imageNamed:@"新的朋友"];
        cell.textLabel.text = @"新的朋友";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.section == 0)&&(indexPath.row == 0)) {
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
        Vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:Vc animated:YES];
        NSLog(@"%ld---%ld",indexPath.section,indexPath.row);
    }
    
}


#pragma mark 监听方法
- (void)leftButtonWay{
    AddFriendsVc *Vc = [[AddFriendsVc alloc]init];
    Vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Vc animated:YES];
    
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
