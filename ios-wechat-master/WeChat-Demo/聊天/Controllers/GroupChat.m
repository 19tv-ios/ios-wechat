//
//  GroupChat.m
//  WeChat-Demo
//
//  Created by MacBook pro on 2020/8/13.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "GroupChat.h"
#import "SDAutoLayout.h"
#import <JMessage/JMessage.h>

@interface GroupChat ()<UITableViewDelegate,UITableViewDataSource>
//uitableview通讯录好友
@property (nonatomic,strong) UITableView *tableView;
//朋友数组
@property (nonatomic,strong) NSMutableArray *userArray;
//首字母数组
@property (nonatomic,strong) NSMutableArray *indexArray;
//排序后的section数组
@property (nonatomic,strong) NSMutableArray *sectionArray;
//行数组
@property (nonatomic,strong) NSMutableArray *rowArray;
//#数组(包括字母、数字)
@property (nonatomic,strong) NSMutableArray *specialArray;
@end

@implementation GroupChat

- (void)viewDidLoad {
    [super viewDidLoad];
   self.view.backgroundColor = [UIColor whiteColor];
    //导航条右侧按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"完成"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    //展示好友的uitableview
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    self.tableView.tag = 2;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.editing = YES;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.topSpaceToView(self.navigationController.navigationBar, 0).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"address"];
    
    
    //更新通讯录列表
    [self updateFriendsList];
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
#pragma mark - 创建群聊
- (void)rightButton {
    
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
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
