//
//  MPTCountDownViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/27.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTCountDownViewController.h"

@interface MPTCountDownViewController ()
@property(strong,nonatomic)UITextField *myTextField;
@property(strong,nonatomic)UIButton *myButton;
@end

@implementation MPTCountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    //布局
    [self.view addSubview:self.myTextField];
    [self.view addSubview:self.myButton];
    
    [self.myTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.width.mas_equalTo(200);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(44);
    }];
    
    [self.myButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.myTextField);
        make.left.mas_equalTo(self.myTextField.right).offset(10);
        make.height.mas_equalTo(44);
    }];
    
    //绑定RAC
    [self bindRac];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark 绑定RAC

-(void)bindRac
{
    //倒计时的效果
    RACSignal *(^counterSigner)(NSNumber *count)=^RACSignal *(NSNumber *count)
    {
        RACSignal *timerSignal=[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler];
        RACSignal *counterSignal=[[timerSignal scanWithStart:count reduce:^id(NSNumber *running, id next) {
            return @(running.integerValue -1);
        }] takeUntilBlock:^BOOL(NSNumber *x) {
            return x.integerValue<0;
        }];
        
        return [counterSignal startWith:count];
    };
    
    
    RACSignal *enableSignal=[self.myTextField.rac_textSignal map:^id(NSString *value) {
        return @(value.length==11);
    }];
    
    RACCommand *command=[[RACCommand alloc]initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
        return counterSigner(@10);
    }];
    
    RACSignal *counterStringSignal=[[command.executionSignals switchToLatest] map:^id(NSNumber *value) {
        return [value stringValue];
    }];
    
    RACSignal *resetStringSignal=[[command.executing filter:^BOOL(NSNumber *value) {
        return !value.boolValue;
    }] mapReplace:@"点击获得验证码"];
    
    //[self.myButton rac_liftSelector:@selector(setTitle:forState:) withSignals:[RACSignal merge:@[counterStringSignal,resetStringSignal]],[RACSignal return:@(UIControlStateNormal)],nil];
    
    //上面也可以写成下面这样
    @weakify(self);
    [[RACSignal merge:@[counterStringSignal,resetStringSignal]] subscribeNext:^(id x) {
        @strongify(self);
        [self.myButton setTitle:x forState:UIControlStateNormal];
    }];
    
    self.myButton.rac_command=command;
    
    
}

#pragma mark 自定义代码

-(UITextField *)myTextField
{
    if (!_myTextField) {
        _myTextField=[[UITextField alloc]init];
        _myTextField.backgroundColor=[UIColor grayColor];
        _myTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _myTextField.placeholder=@"输入11位手机号";
    }
    return _myTextField;
}

-(UIButton *)myButton
{
    if (!_myButton) {
        _myButton=[UIButton new];
        [_myButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_myButton setTitle:@"获得验证码" forState:UIControlStateNormal];
    }
    return _myButton;
}

@end
