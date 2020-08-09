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
@interface ChatController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

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
    //轻点推出键盘
    self.tableview.allowsSelection = NO;
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _msgArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _model = [_msgArray objectAtIndex:indexPath.row];
    JMSGTextContent* textContent = (JMSGTextContent*)_model.content;
    NSString* text = textContent.text;
    NSLog(@"%@",text);
    if(_model.isReceived == YES){
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        [_model.fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            self->_iconData = data;
            dispatch_group_leave(group);
        }];// 头像
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        });
        YouCell* youCell = [[YouCell alloc]initWithText:text andIcon:_iconData];
        _cellHeight = youCell.labelHeight + 30;
        return youCell;
    }else{
        MeCell* meCell = [[MeCell alloc]initWithText:text];
        _cellHeight = meCell.labelHeight + 30;
        return meCell;
    }
//    meCell.wordLabel.text = text;
}
#pragma mark setup bottomview
-(void)setupBottomView{
    _bottomView = [[UIView alloc]init];
    _bottomView = UIView.new;
    [self.view addSubview:_bottomView];
    _bottomView.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).widthIs(ScreenWeight).heightIs(83);
    _bottomView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    [_bottomView updateLayout];
    
    _textView = [[UITextField alloc]init];
    _textView = UITextField.new;
    //_textView.frame = CGRectMake(50, ScreenHeight-50, 200, 40);
    _textView.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:_textView];
    _textView.sd_layout.leftSpaceToView(_bottomView, 30).topSpaceToView(_bottomView, 10).widthIs(250).heightIs(30);
    _textView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 7;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.delegate = self;
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
-(instancetype)initWithMsg:(NSMutableArray*)msg{
    self = [super init];
    _msgArray = [[NSMutableArray alloc]init];
    _msgArray = msg;
    NSLog(@"%@ --- ",_msgArray);
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
//-(void)addToArray:(NSMutableArray*)array{
//    _msgArray = array;
//    NSLog(@"%@ --- ",_msgArray);
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark textFiled delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.tableview.contentSize.width tableView:_tableview];
    return _cellHeight;
}
//弹出键盘视图上移动画
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:@"弹出键盘" context:nil];
    [UIView setAnimationDuration:0.42];
    //使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    if(_msgArray.count>6){
        self.view.frame = CGRectMake(0, -230, self.view.frame.size.width, self.view.frame.size.height);
        _bottomView.frame = CGRectMake(0, ScreenHeight-180, ScreenWeight, 83);
    }else{
        _bottomView.frame = CGRectMake(0, ScreenHeight-390, ScreenWeight, 83);
    }
    [UIView commitAnimations];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:@"收回键盘" context:nil];
    [UIView setAnimationDuration:0.42];
    //使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    if(_msgArray.count>7){
        self.view.frame = [UIScreen mainScreen].bounds;
        _bottomView.frame = CGRectMake(0, ScreenHeight-83, ScreenWeight, 83);
    }else{
        _bottomView.frame = CGRectMake(0, ScreenHeight-83, ScreenWeight, 83);
    }
    [UIView commitAnimations];
}
#pragma mark 键盘发送键
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    JMSGTextContent* textContent = [[JMSGTextContent alloc]initWithText:_textView.text];
    _freshMsg = [JMSGMessage createSingleMessageWithContent:textContent username:_otherSide];
    [JMSGMessage sendMessage:_freshMsg];
    [_msgArray addObject:_freshMsg];
    [_tableview reloadData];
    _textView.text = @"";
    NSLog(@"发送");
    [_textView resignFirstResponder];
    return YES;
}
#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview becomeFirstResponder];
    [_textView resignFirstResponder];
}
-(void)popKeyboard{
    [_textView resignFirstResponder];
}
@end
