//
//  ChatViewController.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatViewCell.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    [_tableview registerClass:[ChatViewCell class] forCellReuseIdentifier:@"chat"];
    
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
    
    //self.navigationController.navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 170);
    //[self.navigationController.navigationBar addSubview:_search.searchBar];
    self.navigationItem.searchController = _search;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseID = @"chat";
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ChatViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell){
        cell = [[ChatViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseID];
    }
    UIImage* image = [UIImage imageNamed:@"微信"];
    cell.imageView.image = image;
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _chatController = [[ChatController alloc]init];
    _chatController.hidesBottomBarWhenPushed = YES;
    //[_chatController viewDidLoad];
    [self.navigationController pushViewController:_chatController animated:YES];
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
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
