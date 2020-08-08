//
//  ChatController.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "ChatController.h"
#import <SDAutoLayout.h>
#import "MeCell.h"
#import "YouCell.h"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWeight [UIScreen mainScreen].bounds.size.width
@interface ChatController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    //去除tableview的横线
    _tableview.separatorStyle = NO;
    //_tableview.backgroundView = [[UIView alloc]init];
    [self.view addSubview:_tableview];
    
    [self setupBottomView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeCell* meCell = [tableView cellForRowAtIndexPath:indexPath];
    //UITableViewCell* cell = [[UITableViewCell alloc]init];
//    JMSGMessage* msg = [_msgArray objectAtIndex:indexPath.row];
//    JMSGTextContent* textContent = (JMSGTextContent*)msg.content;
//    NSString* text = textContent.text;
//    NSLog(@"%@",text);
    if(!meCell){
        meCell = [[MeCell alloc]init];
    }
//    meCell.wordLabel.text = text;
    return meCell;
}
#pragma mark setup bottomview
-(void)setupBottomView{
    _bottomView = [[UIView alloc]init];
    _bottomView = UIView.new;
    [self.view addSubview:_bottomView];
    _bottomView.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).widthIs(ScreenWeight).heightIs(83);
    _bottomView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    [_bottomView updateLayout];
    
    _textView = [[UITextView alloc]init];
    _textView = UITextView.new;
    //_textView.frame = CGRectMake(50, ScreenHeight-50, 200, 40);
    _textView.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:_textView];
    _textView.sd_layout.leftSpaceToView(_bottomView, 30).topSpaceToView(_bottomView, 10).widthIs(250).heightIs(30);
    _textView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 7;
    
    [_textView updateLayout];
    
//    _sendBtn = [[UIButton alloc]init];
//    _sendBtn = UIButton.new;
//    [self.bottomView addSubview:_sendBtn];
//    _sendBtn.sd_layout.leftSpaceToView(_textView, 15).topEqualToView(_textView).heightIs(30).widthIs(70);
//    _sendBtn.backgroundColor = [UIColor grayColor];
//    _sendBtn.layer.borderWidth = 1;
//    _sendBtn.layer.borderColor = [UIColor grayColor].CGColor;
//    _sendBtn.layer.cornerRadius = 10;
//    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    _emojiBtn = [[UIButton alloc]init];
    _emojiBtn = UIButton.new;
    [self.bottomView addSubview:_emojiBtn];
    _emojiBtn.sd_layout.leftSpaceToView(_textView, 5).topEqualToView(_textView).heightIs(35).widthIs(30);
    [_emojiBtn setImage:[UIImage imageNamed:@"笑脸"] forState:UIControlStateNormal];
    [_emojiBtn updateLayout];
    
    _plusBtn = [[UIButton alloc]init];
    _emojiBtn = UIButton.new;
    [self.bottomView addSubview:_plusBtn];
    _plusBtn.sd_layout.leftSpaceToView(_textView, 45).topEqualToView(_textView).heightIs(30).widthIs(35);
    [_plusBtn setImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
}
#pragma mark 重写初始化方法
-(instancetype)initWithMsg:(JMSGMessage *)msg{
    self = [super init];
    _model = msg;
    NSLog(@"%@ --- ",_model);
    return self;
}
#pragma mark 获取对话信息
//-(void)getAllMsg{
//    _msgArray = [[NSMutableArray alloc]init];
//    __block NSMutableArray* temp = [[NSMutableArray alloc]init];
//    [_model allMessages:^(id resultObject, NSError *error) {
//        for(JMSGMessage* ret in resultObject){
//            [temp addObject:ret];
//        }
//        [self addToArray:temp];
//    }];
//}
-(void)addToArray:(NSMutableArray*)array{
    _msgArray = array;
    NSLog(@"%@ --- ",_msgArray);
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
