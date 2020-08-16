//
//  ChatViewController.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatViewCell.h"
#import "PlusMenu.h"
#import "PushToAddFriends.h"
#import "AddFriendsVc.h"
#import "GroupChat.h"
#import <JMessage/JMessage.h>
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,PushToAddFriends,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>

@end
CGFloat height;
@implementation ChatViewController{
    bool hasMenu;
    bool firstTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _filtered = [[NSMutableArray alloc]init];
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    //那么导航栏+状态栏的高度
    height = statusRect.size.height+navRect.size.height;
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc]init];
    [_tableview registerClass:[ChatViewCell class] forCellReuseIdentifier:@"chat"];
    if (@available (iOS 11,*)) {
        _tableview.estimatedRowHeight = 0;
        _tableview.estimatedSectionHeaderHeight = 0;
        _tableview.estimatedSectionFooterHeight = 0;
    }
        
    [self setupSearchBar];
    self.navigationItem.searchController = self->_search;
        
    [self setupBackBtn];
        
    _plusMenu = [[PlusMenu alloc]init];
    _plusMenu.delegate = self;
    hasMenu = NO;
        
    _groupChat = [[GroupChat alloc] init];
    _groupChat.delegate = self;
        
    [self setupPlusBtn];
        
    [self setupRefresh];
        

    if(firstTime == YES){
        [self getConversation];
        firstTime = NO;
    }
    [self getConversation];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.refresh beginRefreshing];
    [self.refresh sendActionsForControlEvents:UIControlEventValueChanged];
}
#pragma mark back button
-(void)setupBackBtn{
    UIButton* btn = [[UIButton alloc]init];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem* back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    //self.navigationItem.backBarButtonItem = back;
    btn.frame = CGRectMake(10, 40, 30, 50);
    [self.navigationController.view addSubview:btn];
    
}
-(void)back{
    dispatch_group_t group2 = dispatch_group_create();
    dispatch_group_enter(group2);
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        self->_conversationArray = resultObject;
        dispatch_group_leave(group2);
    }];
    dispatch_group_notify(group2, dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    });
}
-(void)setupRefresh{
    _refresh = [[UIRefreshControl alloc]init];
    _tableview.refreshControl = _refresh;
    [_refresh addTarget:self action:@selector(fresh) forControlEvents:UIControlEventValueChanged];
}
-(void)fresh{
    //[_refresh beginRefreshing];
    [self getConversation];
    [_tableview reloadData];
    NSLog(@"刷新");
    [_refresh endRefreshing];
}
-(void)setupSearchBar{
    _search = [[UISearchController alloc] initWithSearchResultsController:nil];
    _search.searchResultsUpdater = self;
    _search.delegate = self;
    _search.searchBar.delegate = self;
    _search.dimsBackgroundDuringPresentation = false;
    _search.searchBar.backgroundColor = [UIColor clearColor];
    //设置边框的内部颜色 及边框宽度 圆角
    UIView* searchTextField = [[[_search.searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.layer.borderWidth = 1;
    searchTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchTextField.layer.cornerRadius = 10.0f;
    for(UIView* view in _search.searchBar.subviews)
    {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    _search.searchBar.placeholder = @"搜索";
    [_search.searchBar sizeToFit];
}
#pragma mark 右上角加号
-(void)setupPlusBtn{
    UIBarButtonItem* plus = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"加号-1"] style:UIBarButtonItemStylePlain target:self action:@selector(bringMenu)];
    self.navigationItem.rightBarButtonItem = plus;
}
-(void)bringMenu{
    //[self.navigationController.topViewController.view addSubview:_plusMenu.view];
    //[self.view bringSubviewToFront:_plusMenu.view];
    [self.delegate bringMenu:_plusMenu];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_search.active){
        return _filtered.count;
    }else{
        return _conversationArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!_search.active){
        static NSString* reuseID = @"chat";
        //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ChatViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        _model = [[JMSGConversation alloc]init];
        _model = [_conversationArray objectAtIndex:indexPath.row];
        if(!cell){
            cell = [[ChatViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID andModel:_model];
        }
//        cell.imageView.sd_layout.topSpaceToView(cell.contentView, 8).heightIs(30).widthIs(30);
//        cell.imageView.layer.masksToBounds = YES;
//        cell.imageView.layer.cornerRadius = 5;
        UIImage* image = [UIImage imageNamed:@"微信"];
        cell.iconView.image = image;
        
        cell.wordLabel.text = _model.latestMessageContentText;
        [_model avatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if(error){
                cell.iconView.image = image;
            }else{
                cell.iconView.image = [UIImage imageWithData:data];
            }
        }];
        return cell;
    }else{
        ChatViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        _model = [_filtered objectAtIndex:indexPath.row];
        if(!cell){
            cell = [[ChatViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"chat" andModel:_model];
        }
//        cell.imageView.sd_layout.topSpaceToView(cell.contentView, 13).heightIs(30).widthIs(30);
//        cell.imageView.layer.masksToBounds = YES;
//        cell.imageView.layer.cornerRadius = 5;
        UIImage* image = [UIImage imageNamed:@"微信"];
        cell.iconView.image = image;
        
        cell.wordLabel.text = _model.latestMessageContentText;
        [_model avatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if(error){
                cell.iconView.image = image;
            }else{
                cell.iconView.image = [UIImage imageWithData:data];
            }
        }];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [_filtered removeAllObjects];
    NSString* searchString = _search.searchBar.text;
    for(JMSGConversation* cnt in _conversationArray){
        if([[cnt title] containsString:searchString]){
            [_filtered addObject:cnt];
        }
    }
    [self.tableview reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    JMSGMessage* msg = [_msgArray objectAtIndex:indexPath.row];
    //con.conversationType = kJMSGConversationTypeSingle;
    JMSGConversation* con = [_conversationArray objectAtIndex:indexPath.row];
    _certainMsg = [[NSMutableArray alloc]init];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [con allMessages:^(id resultObject, NSError *error) {
        NSMutableArray* array = resultObject;
        for(int i = (int)array.count-1;i>=0;i--){
            [self->_certainMsg addObject:array[i]];
        }
        //self->_certainMsg = resultObject;
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    [con avatarData:^(NSData *data, NSString *objectId, NSError *error) {
        self->_yourIcon = data;
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self->_chatController = [[ChatController alloc]initWithMsg:self->_certainMsg];
        self->_chatController.otherIcon = self->_yourIcon;
        self->_chatController.hidesBottomBarWhenPushed = YES;
        self->_chatController.title = con.title;
        self->_chatController.otherSide = con.title;
        self->_chatController.conModel = con;
        [self.navigationController pushViewController:self->_chatController animated:YES];
        [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    });
    
}
-(void)getConversationModel{
    _getModel = [[GetConversation alloc]init];
    [_getModel getConversation];
//    _conversationArray = _getModel.allConversation;
//    NSLog(@"conversation --- %@",_getModel.allConversation);
}
-(void)getMsgModel{
    _msgArray = [[NSMutableArray alloc]init];
    for(JMSGConversation* cnt in _conversationArray){
        [cnt allMessages:^(id resultObject, NSError *error) {
            [self->_msgArray addObject:resultObject];
        }];
    }
}
-(void)sendConversation:(NSMutableArray *)array{
    _conversationArray = array;
    [_tableview reloadData];
    //NSLog(@"send成功 --- %@",_conversationArray);
}
-(void)sendMsg:(NSMutableArray *)ary{
    [_msgArray addObject:ary];
    NSLog(@"收到收到");
}
-(void)pushToAddFriends{
    AddFriendsVc* addfriend = [[AddFriendsVc alloc]init];
    [self.navigationController pushViewController:addfriend animated:YES];
}
-(void)pushToGroupChat {
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_groupChat animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)creatConversationWithGroup:(JMSGGroup *)group{
    dispatch_group_t group1 = dispatch_group_create();
    dispatch_group_enter(group1);
    [JMSGConversation createGroupConversationWithGroupId:group.gid completionHandler:^(id resultObject, NSError *error) {
        JMSGConversation* groupConversation = resultObject;
        [self->_conversationArray insertObject:groupConversation atIndex:0];
        NSLog(@"%@ ==== ",resultObject);
        dispatch_group_leave(group1);
    }];
    dispatch_group_notify(group1, dispatch_get_main_queue(), ^{
        NSLog(@"creat group done");
        [self.tableview reloadData];
    });
}
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        JMSGConversation* conToDelete = [self->_conversationArray objectAtIndex:indexPath.row];
        [self->_conversationArray removeObject:conToDelete];
        [self deleteCon:conToDelete.title];
        [self->_tableview reloadData];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}
-(void)deleteCon:(NSString*)name{
    [JMSGConversation deleteSingleConversationWithUsername:name];
}
-(void)getConversation{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    _conversationArray = [[NSMutableArray alloc]init];
    //JMSGConversation* conversation = [[JMSGConversation alloc]init];
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        for(JMSGConversation* ret in resultObject){
            [self->_conversationArray addObject:ret];
        }
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        if(self->_refresh.isRefreshing == YES){
            [self->_refresh endRefreshing];
        }
    });
    
}
-(instancetype)initAndSetup:(NSMutableArray *)con{
    self = [super init];
    _conversationArray = [[NSMutableArray alloc]init];
    _conversationArray =  con;
    firstTime = YES;
    return self;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
