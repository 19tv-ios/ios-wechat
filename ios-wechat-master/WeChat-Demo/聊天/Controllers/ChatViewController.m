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
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>

@end

@implementation ChatViewController{
    bool hasMenu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [[UIView alloc]init];
    [_tableview registerClass:[ChatViewCell class] forCellReuseIdentifier:@"chat"];
    
    [self setupSearchBar];
    self.navigationItem.searchController = _search;
    [self setupBackBtn];
    
    _plusMenu = [[PlusMenu alloc]init];
    hasMenu = NO;
    
    [self setupPlusBtn];
}
#pragma mark back button
-(void)setupBackBtn{
    UIBarButtonItem* back = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.backBarButtonItem = back;
}
-(void)back{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self getConversationModel];
    dispatch_group_leave(group);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    });
}
-(void)setupSearchBar{
    _search = [[UISearchController alloc] initWithSearchResultsController:nil];
    _search.searchResultsUpdater = self;
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
    self.search.delegate = self;
}
#pragma mark 右上角加号
-(void)setupPlusBtn{
    UIBarButtonItem* plus = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"加号-1"] style:UIBarButtonItemStylePlain target:self action:@selector(bringMenu)];
    self.navigationItem.rightBarButtonItem = plus;
}
-(void)bringMenu{
    [self.view addSubview:_plusMenu.view];
    [self.view bringSubviewToFront:_plusMenu.view];
    if(hasMenu == NO){
        [UIView animateWithDuration:0.5 animations:^{
            self->_plusMenu.view.alpha = 0;
            self->_plusMenu.view.alpha = 1;
            [self->_plusMenu.view setHidden:NO];
        }];
        hasMenu = YES;
    }else{
        [self->_plusMenu.view setHidden:YES];
        hasMenu = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _conversationArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseID = @"chat";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //ChatViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    _model = [[JMSGConversation alloc]init];
    _model = [_conversationArray objectAtIndex:indexPath.row];
    if(!cell){
        cell = [[ChatViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID andModel:_model];
    }
//    cell.wordLabel.text = _model.latestMessageContentText;
    [_model avatarData:^(NSData *data, NSString *objectId, NSError *error) {
        
        cell.imageView.image = [UIImage imageWithData:data];
    }];
    UIImage* image = [UIImage imageNamed:@"微信"];
    cell.imageView.image = image;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
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
        self->_chatController.otherIcon = data;
        dispatch_group_leave(group);
    }];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        self->_chatController = [[ChatController alloc]initWithMsg:self->_certainMsg];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
