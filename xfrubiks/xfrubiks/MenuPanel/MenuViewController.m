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
#import "XFContext.h"

#define MenueViewWith [ScreenSizeHelper getMenuViewWidth]

@interface MenuViewController ()<IFlySpeechRecognizerDelegate, ButtonMenuViewDelegate>
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, copy) NSString *inputStr;

@property (nonatomic, strong) ButtonMenuView *buttonsView;
@property (nonatomic, strong) UITextView *inputTextView;

@property (nonatomic, strong) NSMutableArray<NSString *> *colors;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _inputStr = @"";
    // Do any additional setup after loading the view.
    _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, MenueViewWith, 120)];
    _inputTextView.editable = NO;
    _inputTextView.selectable = NO;
    [self.view addSubview:_inputTextView];
    
    _colors = [NSMutableArray new];
    
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
    [starBtn_audio setTitle:@"语音" forState:UIControlStateNormal];
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
    [stopBtn_audio setTitle:@"退格" forState:UIControlStateNormal];
    [stopBtn_audio addTarget:self action:@selector(backInputTapped:) forControlEvents:UIControlEventTouchUpInside];
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
//    NSString *testStr = @"白红蓝蓝白绿红白绿黄黄红红红红橙蓝蓝绿红橙橙绿绿蓝黄蓝白蓝黄橙黄白绿橙白绿橙白绿橙绿黄白橙黄黄橙蓝蓝白红黄红";
    NSString *testStr = @"白绿红蓝黄绿红绿蓝橙红黄橙绿黄橙白红白黄黄绿红白白橙黄绿黄绿蓝白红红蓝绿橙白蓝红蓝白白橙橙蓝橙蓝红橙蓝黄黄绿";
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
            
            
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            
            if(solution){
                [alert showSuccess:self
                             title:@"找出来啦"
                          subTitle:solution
                  closeButtonTitle:@"那是什么意思"
                          duration:0.0f];
                
                [[XFContext context].main showGuide:solution];
                
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
    [_iFlySpeechRecognizer stopListening];
//    [self starAudioInput];
    
    [self _clearInputText];
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
    if(_colors.count == 54)return;
    
    NSArray *array = @[@"红", @"蓝", @"黄", @"橙", @"绿", @"白", @"黑"];
    for (NSString *str in array) {
        if ([text rangeOfString:str].location != NSNotFound) {

            if ([str isEqualToString:@"黑"]) {
                [self _pushColor:@"白"];
            }else{
                [self _pushColor:str];
            }
            
            break;
        }
    }
    
    
    if (_colors.count == 9) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"input_arrow" object:@"left"];
    }else if (_colors.count == 18){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"input_arrow" object:@"right"];
    }else if (_colors.count == 27){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"input_arrow" object:@"up"];
    }else if (_colors.count == 36){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"input_arrow" object:@"upleft"];
    }else if (_colors.count == 45){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"input_arrow" object:@"leftright"];
    }else if (_colors.count == 54){
        [self _trySolve:_inputTextView.text];
    }
    
}


- (void)_clearInputText{
    [self _clearColor];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"XFSyncColor" object:@""];
}

- (void)_pushColor:(NSString*)text{
    [_colors addObject:text];
    
    [self _refreshInputTextView];
}

- (void)_popColor{
    if(_colors.count > 0)
        [_colors removeLastObject];
    
    [self _refreshInputTextView];
}

- (void)_clearColor{
    [_colors removeAllObjects];
    
    [self _refreshInputTextView];
}

- (void)_refreshInputTextView{
    NSArray<NSString*> *faceNames = @[
                                      @"上面",
                                      @"右面",
                                      @"前面",
                                      @"底面",
                                      @"左面",
                                      @"后面",
                                      ];
    
    NSMutableString *str = [NSMutableString new];
    [_colors enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendString:obj];
        [str appendString:@" "];
        
        if((idx+1)%9==0){
            [str appendFormat:@" [%@]\n", faceNames[idx/9]];
        }
    }];
    
    _inputTextView.text = [str copy];
    
    //Sync fill color
    [[NSNotificationCenter defaultCenter]postNotificationName:@"XFSyncColor" object:_inputTextView.text];
}

- (void)backInputTapped:(id)sender{
    [self _popColor];
}

@end
