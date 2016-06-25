//
//  MenuViewController.m
//  xfrubiks
//
//  Created by everettjf on 16/6/25.
//  Copyright © 2016年 xfteam. All rights reserved.
//

#import "MenuViewController.h"
#import "iflyMSC/IFlyMSC.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"
#import "ButtonMenuView.h"
#import <xfsolver/xfsolver.h>
#import "ScreenSizeHelper.h"
#import "Utility.h"
#import <SVProgressHUD.h>
#import <SCLAlertView.h>

#define MenueViewWith [ScreenSizeHelper getMenuViewWidth]
@interface MenuViewController ()<IFlySpeechRecognizerDelegate, ButtonMenuViewDelegate>
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, copy) NSString *inputStr;

@property (nonatomic, strong) ButtonMenuView *buttonsView;
@property (nonatomic, strong) UITextView *inputTextView;
@property (nonatomic, assign) int inputCount;
@property (nonatomic, assign) BOOL isInputComplete;
@property (nonatomic, assign) int completeCount;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _inputCount = 0;
    _completeCount = 0;
    _inputStr = @"";
    _isInputComplete = NO;
    // Do any additional setup after loading the view.
    _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, MenueViewWith, 120)];
    _inputTextView.editable = NO;
    [self.view addSubview:_inputTextView];
    
    {
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 120, MenueViewWith, 0.5)];
        sep.backgroundColor = [UIColor grayColor];
        [self.view addSubview:sep];
    }
    
    _buttonsView = [[ButtonMenuView alloc]initWithFrame:CGRectMake(0,121, MenueViewWith, 130)];
    _buttonsView.delegate = self;
    [self.view addSubview:_buttonsView];
    
    {
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 121 + 131, MenueViewWith, 0.5)];
        sep.backgroundColor = [UIColor grayColor];
        [self.view addSubview:sep];
    }
    
    UIView *audioInputView = [[UIView alloc]init];
    audioInputView.frame = CGRectMake(0, SCREEN_HEIGHT - 70, MenueViewWith, 70);
    [self.view addSubview:audioInputView];
    
    float witdth = (MenueViewWith-40)/3;
    UIButton *starBtn_audio = [UIButton buttonWithType:UIButtonTypeSystem];
    starBtn_audio.layer.cornerRadius = 5;
    starBtn_audio.layer.masksToBounds = YES;
    starBtn_audio.layer.borderColor = [UIColor grayColor].CGColor;
    starBtn_audio.layer.borderWidth = 1.0;
    starBtn_audio.titleLabel.font = [UIFont systemFontOfSize: 14];
    [starBtn_audio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    starBtn_audio.frame = CGRectMake(10, 15, witdth, 35);
    [starBtn_audio setTitle:@"开始" forState:UIControlStateNormal];
    [starBtn_audio addTarget:self action:@selector(starAudioInput) forControlEvents:UIControlEventTouchUpInside];
    [audioInputView addSubview:starBtn_audio];
    
    UIButton *stopBtn_audio = [UIButton buttonWithType:UIButtonTypeSystem];
    stopBtn_audio.layer.cornerRadius = 5;
    stopBtn_audio.layer.masksToBounds = YES;
    stopBtn_audio.layer.borderWidth = 1.0;
    stopBtn_audio.titleLabel.font = [UIFont systemFontOfSize: 14];
    stopBtn_audio.titleLabel.font = [UIFont systemFontOfSize: 14];
    [stopBtn_audio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    stopBtn_audio.frame = CGRectMake(witdth+20, 15, witdth, 35);
    [stopBtn_audio setTitle:@"停止" forState:UIControlStateNormal];
    [stopBtn_audio addTarget:self action:@selector(stopAudioInput) forControlEvents:UIControlEventTouchUpInside];
    [audioInputView addSubview:stopBtn_audio];
    
    UIButton *reStarBtn_audio = [UIButton buttonWithType:UIButtonTypeSystem];
    reStarBtn_audio.layer.cornerRadius = 5;
    reStarBtn_audio.layer.masksToBounds = YES;
    reStarBtn_audio.layer.borderWidth = 1.0;
    reStarBtn_audio.titleLabel.font = [UIFont systemFontOfSize: 14];
    reStarBtn_audio.titleLabel.font = [UIFont systemFontOfSize: 13];
    [reStarBtn_audio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    reStarBtn_audio.frame = CGRectMake(witdth*2+30, 15, witdth, 35);
    [reStarBtn_audio setTitle:@"重新输入" forState:UIControlStateNormal];
    [reStarBtn_audio addTarget:self action:@selector(reStarInput) forControlEvents:UIControlEventTouchUpInside];
    [audioInputView addSubview:reStarBtn_audio];
    
}
- (void)fillTestData{
    NSString *testStr = @"绿蓝白红蓝蓝白橙红蓝红蓝蓝橙绿红橙黄红蓝黄橙黄白白白蓝绿绿白白绿绿蓝红绿红绿绿橙红白黄红橙橙黄黄黄白黄橙黄橙";
    _inputTextView.text = testStr;
    
    
    [self _trySolve:_inputTextView.text];
}

- (void)_trySolve:(NSString*)input{
    NSString *filtered = [RubiksConvertor convertColorToPostion:input];
    
    [SVProgressHUD showWithStatus:@"计算中..."];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CFTimeInterval start = CACurrentMediaTime();
        
//        NSString *solution = [RubiksSolver solve:@"DRLUUBFBRBLURRLRUBLRDDFDLFUFUFFDBRDUBRUFLLFDDBFLUBLRBD"];
        NSLog(@"--------------------------------------------------");
        NSLog(@"begin to solve : %@",filtered);
        
        NSString *solution = [RubiksSolver solve:filtered];
        
        NSLog(@"solution = %@ , %@",@(CACurrentMediaTime() - start),solution);
        NSLog(@"--------------------------------------------------");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            
            if(solution){
                [alert showSuccess:self
                             title:@"找出来啦"
                          subTitle:solution
                  closeButtonTitle:@"那是什么意思"
                          duration:0.0f];
            }else{
                [alert showError:self
                             title:@"我的天呐"
                          subTitle:@"一定是你的魔方坏掉了……暴力强拆吧"
                  closeButtonTitle:@"好的，我强拆去了"
                          duration:0.0f];
            }
        });
    });
}


- (void)initRecognizer
{
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
    
    if (_iFlySpeechRecognizer != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
    
}

//开始语音输入
- (void)starAudioInput{
    
    NSLog(@"开始输入");

    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (!ret) {
        NSLog(@"error");
    }

}
//停止语音输入
- (void)stopAudioInput{
    NSLog(@"停止输入");
    [_iFlySpeechRecognizer stopListening];
}
//重新语音输入
- (void)reStarInput{
    NSLog(@"重新输入");
    _inputTextView.text = @"";
    [_iFlySpeechRecognizer stopListening];
//    [self starAudioInput];
    
}

#pragma mark IFlySpeechRecognizerDelegate
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];

    [self _addInputText:resultFromJson];
    
}
- (void) onError:(IFlySpeechError *) errorCode{
    NSLog(@"%@", errorCode);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonMenuViewColorTapped:(NSString *)tagColor{
    NSLog(@"button tap : %@", tagColor);
    
    [self _addInputText:tagColor];
}

- (void)_addInputText:(NSString*)text{
    
    NSArray *array = @[@"红", @"蓝", @"黄", @"橙", @"绿", @"白", @"黑"];
    for (NSString *str in array) {
        if ([text rangeOfString:str].location != NSNotFound) {

            [RubiksConvertor convertColorToHanZi:_inputTextView.text];
            _inputTextView.text = [NSString stringWithFormat:@"%@%@ ", _inputTextView.text,str];
            
            //Sync fill color
            [[NSNotificationCenter defaultCenter]postNotificationName:@"XFSyncColor" object:_inputTextView.text];
            
            _inputCount++;
            break;
        }
    }
    
    if (_isInputComplete == NO) {
        NSString *tips = @"";
        if (_inputCount == 9) {
            if (_completeCount < 1) {
                tips = @"上面输入完成，请输入右面";
                [self showInputAlert:tips tag:0];
                _completeCount++;
            }
        }else if (_inputCount == 18){
            if (_completeCount < 2) {
                tips = @"右面输入完成，请输入前面";
                [self showInputAlert:tips tag:1];
                _completeCount++;
            }
        }else if (_inputCount == 27){
            if (_completeCount < 3) {
                tips = @"前面输入完成，请输入底面";
                [self showInputAlert:tips tag:2];
                _completeCount++;
            }
        }else if (_inputCount == 36){
            if (_completeCount < 4) {
                tips = @"底面输入完成，请输入左面";
                [self showInputAlert:tips tag:3];
                _completeCount++;
            }

        }else if (_inputCount == 45){
            if (_completeCount < 5) {
                tips = @"左面输入完成，请输入后面";
                [self showInputAlert:tips tag:4];
                _completeCount++;
            }
        }else if (_inputCount == 54){
            if (_completeCount < 6) {
                tips = @"魔方输入完成";
                [self showInputAlert:tips tag:5];
                
                [self _trySolve:_inputTextView.text];
                
                _isInputComplete = YES;
                _completeCount++;
            }
        }
    }
}

- (void)showInputAlert:(NSString *)tips tag:(int)tag{
//    [Utility barInfo:tips];
    
    [self starAudioInput];
    
    if (tag == 0) {
        _inputTextView.text = [NSString stringWithFormat:@"%@(%@)\n", _inputTextView.text, @"上面"];
    }else if (tag == 1){
        _inputTextView.text = [NSString stringWithFormat:@"%@(%@)\n", _inputTextView.text, @"右面"];
    }else if (tag == 2){
        _inputTextView.text = [NSString stringWithFormat:@"%@(%@)\n", _inputTextView.text, @"前面"];
    }else if (tag == 3){
        _inputTextView.text = [NSString stringWithFormat:@"%@(%@)\n", _inputTextView.text, @"底面"];
    }else if (tag == 4){
        _inputTextView.text = [NSString stringWithFormat:@"%@(%@)\n", _inputTextView.text, @"左面"];
    }else if (tag == 5){
        _inputTextView.text = [NSString stringWithFormat:@"%@(%@)\n", _inputTextView.text, @"后面"];
    }
}
- (void)_clearInputText{
    _inputTextView.text = @"";
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
