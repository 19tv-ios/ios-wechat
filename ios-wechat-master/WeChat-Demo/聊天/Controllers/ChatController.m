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
#import "PushToDetail.h"
#import "DetailVc.h"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWeight [UIScreen mainScreen].bounds.size.width
@interface ChatController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,JMessageDelegate,PushToDetail>

@end

@implementation ChatController{
    int cnt;
    UIImage* voicePic;
}

- (void)viewDidLoad {
    cnt = 0;
    voicePic = [UIImage imageNamed:@"声波"];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    // Do any additional setup after loading the view.
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWeight, ScreenHeight-83) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    //去除tableview的横线
    _tableview.separatorStyle = NO;
    //_tableview.backgroundView = [[UIView alloc]init];
    [self.view addSubview:_tableview];
    
    [self setupBottomView];
    //轻点推出键盘
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    [JMessage addDelegate:self withConversation:_conModel];
    

//    _playRecordButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    _playRecordButton.frame = CGRectMake(50 , 200, 300 , 50);
//    [_playRecordButton setTitle:@"播放录音" forState:UIControlStateNormal];
//    [_playRecordButton addTarget:self action:@selector(playRecordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_playRecordButton];
    
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(self->_msgArray.count>0){
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self->_msgArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
    return _msgArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _model = [_msgArray objectAtIndex:indexPath.row];
    [self.tableview useCellFrameCacheWithIndexPath:indexPath tableView:_tableview];
    
    if(_model.contentType == 1){
        JMSGTextContent* textContent = (JMSGTextContent*)_model.content;
        NSString* text = textContent.text;
        if(_model.isReceived == YES){
//            dispatch_semaphore_t sem = dispatch_semaphore_create(1);
//            [_model.fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
//                self->_iconData = data;
//                dispatch_semaphore_signal(sem);
//            }];// 头像
//            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            YouCell* youCell = [tableView dequeueReusableCellWithIdentifier:@"youcell"];
            if(youCell == nil){
                youCell = [[YouCell alloc]initWithText:text andIcon:_otherIcon];
                _cellHeight = youCell.labelHeight + 30;
                youCell.model = _model;
                youCell.delegate = self;
            }
            return youCell;
        }else{
//            dispatch_semaphore_t sem = dispatch_semaphore_create(1);
//            [_model.fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
//                self->_iconData = data;
//                dispatch_semaphore_signal(sem);
//            }];
//            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            JMSGUser* user = [JMSGUser myInfo];
            NSData* data = [NSData dataWithContentsOfFile:[user thumbAvatarLocalPath] ];
            MeCell* meCell = [tableView dequeueReusableCellWithIdentifier:@"mecell"];
            if(meCell == nil){
                meCell = [[MeCell alloc]initWithText:text andIcon:data];
                _cellHeight = meCell.labelHeight + 30;
                meCell.model = _model;
                meCell.delegate = self;
            }
            return meCell;
        }
    }else if(_model.contentType == 2){
        JMSGImageContent* content = (JMSGImageContent*)_model.content;
        if(_model.isReceived){
            YouCell* youCell = [[YouCell alloc]initWithImage:content andIcon:_otherIcon];
            _cellHeight = 210;
            youCell.model = _model;
            youCell.delegate = self;
            return youCell;
        }else{
            JMSGUser* user = [JMSGUser myInfo];
            NSData* data = [NSData dataWithContentsOfFile:[user thumbAvatarLocalPath] ];
            MeCell* meCell = [[MeCell alloc]initWithImage:content andIcon:data];
            _cellHeight = 210;
            meCell.model = _model;
            meCell.delegate = self;
            return meCell;
        }
    }else if(_model.contentType == 3){
        JMSGVoiceContent* content = (JMSGVoiceContent*)_model.content;
        if(_model.isReceived){
            YouCell* youCell = [[YouCell alloc]initWithVoice:content andPic:voicePic andIcon:_otherIcon];
            _cellHeight = 60;
            youCell.model = _model;
            youCell.delegate = self;
            return youCell;
        }else{
            JMSGUser* user = [JMSGUser myInfo];
            NSData* data = [NSData dataWithContentsOfFile:[user thumbAvatarLocalPath] ];
            MeCell* meCell = [[MeCell alloc]initWithVoice:content andPic:voicePic andIcon:data];
            _cellHeight = 60;
            meCell.model = _model;
            meCell.delegate = self;
            //NSLog(@"%@ --- content",content);
            return meCell;
        }
    }
    return [[UITableViewCell alloc]init];
//    meCell.wordLabel.text = text;
}
#pragma mark setup bottomview
-(void)setupBottomView{
    
    _bottomView = [[UIView alloc]init];
    _bottomView = UIView.new;
    [self.view addSubview:_bottomView];
    _bottomView.sd_layout.leftSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).widthIs(ScreenWeight).heightIs(83);
    _bottomView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.95];;
    [_bottomView updateLayout];
    
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
     _recordButton.frame = CGRectMake(10 , self.view.frame.size.height - 75, 28 , 28);
    _recordButton.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.95];;
    [_recordButton setImage:[UIImage imageNamed:@"语音"] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:_recordButton];
    _recordButton.sd_layout.leftSpaceToView(_bottomView, 5).topSpaceToView(_bottomView, 15).widthIs(28).heightIs(28);
    
    _textView = [[UITextField alloc]init];
    _textView = UITextField.new;
    //_textView.frame = CGRectMake(50, ScreenHeight-50, 200, 40);
    _textView.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:_textView];
    _textView.sd_layout.leftSpaceToView(_bottomView, 40).topSpaceToView(_bottomView, 10).widthIs(250).heightIs(40);
    _textView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    _textView.layer.borderWidth = 1;
    _textView.layer.cornerRadius = 7;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.delegate = self;
    [_textView updateLayout];
    
    _emojiBtn = [[UIButton alloc]init];
    _emojiBtn = UIButton.new;
    [self.bottomView addSubview:_emojiBtn];
    _emojiBtn.sd_layout.leftSpaceToView(_textView, 5).topSpaceToView(_bottomView, 15).heightIs(28).widthIs(28);
    [_emojiBtn setImage:[UIImage imageNamed:@"icon_im_face"] forState:UIControlStateNormal];
    
//    [_emojiBtn addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
    
    [_emojiBtn updateLayout];
    
    _plusBtn = [[UIButton alloc]init];
    _plusBtn = UIButton.new;
    [self.bottomView addSubview:_plusBtn];
    _plusBtn.sd_layout.leftSpaceToView(_textView,45).topSpaceToView(_bottomView, 15).heightIs(28).widthIs(28);
    [_plusBtn setImage:[UIImage imageNamed:@"icon_im_more"] forState:UIControlStateNormal];
    [_plusBtn addTarget:self action:@selector(cilckPlus) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark 重写初始化方法
-(instancetype)initWithMsg:(NSMutableArray*)msg{
    self = [super init];
    _msgArray = [[NSMutableArray alloc]init];
    _msgArray = msg;
    //NSLog(@"%@ --- ",_msgArray);
    return self;
}
-(void)cilckPlus{
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_picker animated:YES completion:nil];
}

#pragma mark uiimagepicker协议
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* myImage = info[UIImagePickerControllerOriginalImage];
    NSData* imageData = UIImageJPEGRepresentation(myImage, 0.7);
    JMSGImageContent* imageContent = [[JMSGImageContent alloc]initWithImageData:imageData];
    _freshMsg = [JMSGMessage createSingleMessageWithContent:imageContent username:_otherSide];
    //[JMSGMessage sendMessage:_freshMsg];
    [_conModel sendMessage:_freshMsg];
    [_msgArray addObject:_freshMsg];
    //NSLog(@"%@ --- image %@ --- name ",_freshMsg,_otherSide);
    [_tableview reloadData];
    [_picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark textFiled delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return [self cellHeightForIndexPath:indexPath cellContentViewWidth:self.tableview.contentSize.width tableView:_tableview];
    return _cellHeight+10;
}
//弹出键盘视图上移动画
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:@"弹出键盘" context:nil];
    [UIView setAnimationDuration:0.42];
    //使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    if(_msgArray.count>6){
        self.view.frame = CGRectMake(0, -230, self.view.frame.size.width, self.view.frame.size.height);
        _bottomView.frame = CGRectMake(0, ScreenHeight-170, ScreenWeight, 83);
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
    if(_msgArray.count>6){
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
    [_conModel sendMessage:_freshMsg];
    //[JMSGMessage sendMessage:_freshMsg];
    [_msgArray addObject:_freshMsg];
    [_tableview reloadData];
    _textView.text = @"";
    _lastmsg = _freshMsg;
    //NSLog(@"%@ --- send",_freshMsg);
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
//展示最下方的cell
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark jmessage delegate

- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
    if(error == nil){
        [_msgArray addObject:message];
        [_tableview reloadData];
    }
}
-(void)pushWithUser:(JMSGUser *)user{
    DetailVc* detail = [[DetailVc alloc]init];
    detail.user = user;
    [self.navigationController pushViewController:detail animated:YES];
    //NSLog(@"push  ====  ");
}



//- (void)playRecordButtonTouchUpInside {
//    if (_recordFilePath) {
//        _player = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile:_recordFilePath] error:nil];
//        [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
//        [_player play];
//        NSLog(@"%@",_recordFilePath);
//        NSLog(@"%f",_player.duration);
//    }
//}
//摁住说话
- (void)recordButtonTouchDown {
    //info.plist配置权限
    if (![self canRecord]) {
        NSLog(@"请启用麦克风-设置/隐私/麦克风");
    }
    _volumeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    _volumeImageView.center = self.tableview.center;
    _volumeImageView.image = [UIImage imageNamed:@"麦克风1"];
    [self.view addSubview:_volumeImageView];
    //开始录音
    _countDown = 60;
    //添加定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLabelText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    _session =[AVAudioSession sharedInstance];
    NSError *sessionError = nil;
    [_session setCategory:AVAudioSessionCategoryRecord error:&sessionError];
    if (_session == nil) {
        NSLog(@"Error creating session: %@",[sessionError description]);
    } else {
        [_session setActive:YES error:nil];
    }
    //获取文件沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _recordFilePath = [path stringByAppendingString:@"/rr.wav" ];
    NSLog(@"%@",_recordFilePath);
    //设置参数
    NSDictionary *recordSetting = @{AVFormatIDKey: @(kAudioFormatLinearPCM),
                                    AVSampleRateKey: @8000.00f,
                                    AVNumberOfChannelsKey: @1,
                                    AVLinearPCMBitDepthKey: @16,
                                    AVLinearPCMIsNonInterleaved: @NO,
                                    AVLinearPCMIsFloatKey: @NO,
                                    AVLinearPCMIsBigEndianKey: @NO};
    NSError* err;
    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_recordFilePath] settings:recordSetting error:&err];
    if (err) {
        NSLog(@"[AudioRecorder][Error] %@", err);
    }
    if (_recorder) {
        _recorder.meteringEnabled = YES;
        [self resetEnvironment];
        [_recorder prepareToRecord];
        [_recorder record];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self recordButtonTouchUpInside];
        });
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
    cnt++;
}
- (void)resetEnvironment {
    //check doc path
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_recordFilePath]) {
        NSError *error;
        [fm removeItemAtPath:_recordFilePath error:&error];
        if (error) {
            NSLog(@"[AudioRecorder][FM]ERROR %@", error);
        }
    }
}

- (void)refreshLabelText {
    [_recorder updateMeters];
    float level;
    float minDecibels = -80.0f;
    float decibels = [_recorder averagePowerForChannel:0];
    if (decibels < minDecibels) {
        level = 0.0f;
    } else if (decibels >= 0.0f) {
        level = 1.0f;
    } else {
        float root = 2.0f;
        float minAmp = powf(10.0f, 0.05f * minDecibels);
        float inverseAmpRange = 1.0f / (1.0f - minAmp);
        float amp = powf(10.0f, 0.05f * decibels);
        float adjAmp = (amp - minAmp) * inverseAmpRange;
        level = powf(adjAmp, 1.0f / root);
    }
    NSInteger voice = level*10 + 1;
    voice = voice > 8 ? 8 : voice;
    NSLog(@"%ld",voice);
    NSString *imageIndex = [NSString stringWithFormat:@"voice_%ld", voice];
    if (_isLeaveSpeakBtn) {
        _volumeImageView.image = [UIImage imageNamed:@"rc_ic_volume_cancel"];
    } else {
        _volumeImageView.image = [UIImage imageNamed:imageIndex];
    }
    _countDown --;
    if (_countDown < 10 && _countDown > 0) {
        _volumeLabel.text = [NSString stringWithFormat:@"还剩 %ld 秒",(long)_countDown];
    }
    //超时自动发送
    if (_countDown < 1) {
        [self recordButtonTouchUpInside];
    }
}
//松开发送
- (void)recordButtonTouchUpInside {
    NSLog(@"recordButtonTouchUpInside");
    if (!_timer) {
        return;
    }
    //停止录音 移除定时器
    [_timer invalidate];
    _timer = nil;
    if ([_recorder isRecording]) {
        //float seconds = CMTimeGetSeconds(voiceDuration);
        //NSLog(@"seconds is %f --- ",seconds);
        [_recorder stop];
        _player = [[AVAudioPlayer alloc]initWithData:[NSData dataWithContentsOfFile:_recordFilePath] error:nil];
        [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
        //NSLog(@"%f",_player.duration);
        JMSGVoiceContent* voiceContent = [ [JMSGVoiceContent alloc]initWithVoiceData:[NSData dataWithContentsOfFile:_recordFilePath] voiceDuration:[NSNumber numberWithDouble:_player.duration] ];
        JMSGMessage* voiceMsg = [JMSGMessage createSingleMessageWithContent:voiceContent username:_otherSide];
        [_conModel sendMessage:voiceMsg];
        [_msgArray addObject:voiceMsg];
        [_tableview reloadData];
    }
    [_volumeImageView removeFromSuperview];
}
//检查是否拥有麦克风权限
- (BOOL)canRecord {
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            } else {
                bCanRecord = NO;
            }
        }];
    }
    return bCanRecord;
}
- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures {
    return UIRectEdgeBottom;
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

#pragma mark 表情包键盘
//- (void)clickedEmoji:(UIButton *)sender {
//    if (self.inputBar.textView.inputView == nil) {
//        self.inputBar.textView.inputView = self.emojiKeyboard;
//        [sender setImage:[UIImage imageNamed:@"btn_chat_input_keyborad"] forState:UIControlStateNormal];
//    }else {
//        self.inputBar.textView.inputView = nil;
//        [sender setImage:[UIImage imageNamed:@"btn_chat_input_emoji"] forState:UIControlStateNormal];
//    }
//    [self.inputBar.textView reloadInputViews];
//    [self.inputBar.textView becomeFirstResponder];
//}
@end
