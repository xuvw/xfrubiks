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

@interface MenuViewController ()<IFlySpeechRecognizerDelegate, ButtonMenuViewDelegate>
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic, copy) NSString *inputStr;

@property (nonatomic, strong) ButtonMenuView *buttonsView;
@property (nonatomic, strong) UITextView *inputTextView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 70)];
    _inputTextView.editable = NO;
    [self.view addSubview:_inputTextView];
    
    {
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH/2, 0.5)];
        sep.backgroundColor = [UIColor grayColor];
        [self.view addSubview:sep];
    }
    
    _buttonsView = [[ButtonMenuView alloc]initWithFrame:CGRectMake(0,71, SCREEN_WIDTH/2, 130)];
    _buttonsView.delegate = self;
    [self.view addSubview:_buttonsView];
    
    {
        UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 71 + 131, SCREEN_WIDTH/2, 0.5)];
        sep.backgroundColor = [UIColor grayColor];
        [self.view addSubview:sep];
    }
    
    UIView *audioInputView = [[UIView alloc]init];
    audioInputView.frame = CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH/2, 100);
    [self.view addSubview:audioInputView];
    
    UIButton *starBtn_audio = [UIButton buttonWithType:UIButtonTypeSystem];
    starBtn_audio.layer.cornerRadius = 5;
    starBtn_audio.layer.masksToBounds = YES;
    starBtn_audio.titleLabel.font = [UIFont systemFontOfSize: 18];
    [starBtn_audio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    starBtn_audio.frame = CGRectMake(20, 20, 80, 50);
    [starBtn_audio setTitle:@"开始" forState:UIControlStateNormal];
    [starBtn_audio addTarget:self action:@selector(starAudioInput) forControlEvents:UIControlEventTouchUpInside];
    [audioInputView addSubview:starBtn_audio];
    
    UIButton *stopBtn_audio = [UIButton buttonWithType:UIButtonTypeSystem];
    stopBtn_audio.layer.cornerRadius = 5;
    stopBtn_audio.layer.masksToBounds = YES;
    stopBtn_audio.titleLabel.font = [UIFont systemFontOfSize: 18];
    [stopBtn_audio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    stopBtn_audio.frame = CGRectMake(120, 20, 80, 50);
    [stopBtn_audio setTitle:@"停止" forState:UIControlStateNormal];
    [stopBtn_audio addTarget:self action:@selector(stopAudioInput) forControlEvents:UIControlEventTouchUpInside];
    [audioInputView addSubview:stopBtn_audio];
    
    UIButton *reStarBtn_audio = [UIButton buttonWithType:UIButtonTypeSystem];
    reStarBtn_audio.layer.cornerRadius = 5;
    reStarBtn_audio.layer.masksToBounds = YES;
    reStarBtn_audio.titleLabel.font = [UIFont systemFontOfSize: 18];
    [reStarBtn_audio setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    reStarBtn_audio.frame = CGRectMake(220, 20, 80, 50);
    [reStarBtn_audio setTitle:@"重新输入" forState:UIControlStateNormal];
    [reStarBtn_audio addTarget:self action:@selector(reStarInput) forControlEvents:UIControlEventTouchUpInside];
    [audioInputView addSubview:reStarBtn_audio];
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
    [self starAudioInput];
    
}

#pragma mark IFlySpeechRecognizerDelegate
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _inputStr =[NSString stringWithFormat:@"%@%@", _inputTextView.text,resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    
    [self _addInputText:resultFromJson];
    
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.inputStr);
    }
    NSLog(@"_result=%@",_inputStr);
    NSLog(@"resultFromJson=%@",resultFromJson);
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
    
    BOOL isright = NO;
    NSArray *array = @[@"红", @"蓝", @"黄", @"橙", @"绿", @"白"];
    for (NSString *str in array) {
        if ([text rangeOfString:str].location != NSNotFound) {
            NSLog(@"%@", str);
            _inputTextView.text = [NSString stringWithFormat:@"%@%@ ", _inputTextView.text,str];
            isright = YES;
            break;
        }
    }
    
    if (isright == NO) {
        NSString *tips = @"语音输入错误，请重新输入";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:tips preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self starAudioInput];
        }];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
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
