//
//  TestRacViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/30.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "TestRacViewController.h"

@interface TestRacViewController ()
@property(nonatomic,strong)UITextField *userNameText;
@property(strong,nonatomic)NSString *username;
@property(nonatomic,strong)UIButton *loginButton,*racCommendButton;

@end

@implementation TestRacViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor redColor];
    
    [self loadPage];

    @weakify(self);
    
    //把左边的属性跟右边信号signal的sendNext值绑定  distinctUntilChanged为了当值相同时不执行
    RAC(self,username)=[self.userNameText.rac_textSignal distinctUntilChanged];
    
    //监听username是否有变化,有变化就会执行subscribeNext 这个属性要支持KVO  可变数组就不可以
    [RACObserve(self, username) subscribeNext:^(NSString *x) {
        NSLog(@"你当前输入的值为：%@",x);
    }];
    
    //UIAlertView跟RAC结合
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Alert" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
        if ([indexNumber intValue] == 1) {
            NSLog(@"你点了确定");
        } else {
            NSLog(@"你点了取消");
        }
    }];
    [alertView show];
    
    //Button响应事件
    [[self.loginButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(UIButton *x) {
         @strongify(self);
         [[self testSignal] subscribeNext:^(id x) {
             NSLog(@"当前执行值为：%@",x);
         }];
     }];
    
    
    
    //Button用命令式运行 switchToLatest处理信号中传递的参数为信号
    self.racCommendButton.rac_command=[self testCommend];
    
    //这个绑定要放在executionSignals执行前面 否则只会有一个执行完成会响应
    [self.racCommendButton.rac_command.executing subscribeNext:^(id x) {
        if ([x boolValue]) {
            NSLog(@"rac_command正在执行中");
        }
        else
        {
            NSLog(@"rac_command执行完成");
        }
    }];
    
    //dematerialize处理可以响应处理跟完成的内容
    [self.racCommendButton.rac_command.executionSignals subscribeNext:^(RACSignal *execution) {
        [[[execution dematerialize] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            NSLog(@"提示内容：%@",x);
        } error:^(NSError *error) {
             NSLog(@"racCommend出错了");
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//创建一个信号代码
-(RACSignal *)testSignal
{
    RACSignal *signal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        NSLog(@"创建信号");
        [subscriber sendNext:@"Hi 我是一个信号"];
        [subscriber sendCompleted];
        return nil;
    }];
    return signal;
}

//创建一个命令响应
-(RACCommand *)testCommend
{
    @weakify(self);
    RACCommand *myCommend=[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *authSignal=[RACSignal empty];
        @strongify(self);
    
                  authSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                      //可以根据要求加条件进行判断是否创建信号
                      if ([self.username isEqualToString:@"wjy"]) {
                      NSLog(@"符合要求");
                      [subscriber sendNext:@"我完成的命令响应"];
                      [subscriber sendCompleted];
                      }
                      else
                      {
                          //错误
                          [subscriber sendError:[NSError errorWithDomain:@"报错了" code:1 userInfo:nil]];
                      }
                  return nil;
            }];
        //materialize是为了处理拿不到error的问题
        return [authSignal materialize];
    }];
    
    return myCommend;
}

//RACSubject的运用
-(RACSubject *)testSubject
{
    RACSubject *sub=[RACSubject subject];
    [sub sendNext:@"我是RACSubject"];
    return sub;
}

//布局
-(void)loadPage
{
    if (!self.userNameText) {
        self.userNameText=[[UITextField alloc]init];
        self.userNameText.backgroundColor=[UIColor whiteColor];
        self.userNameText.placeholder=@"输入用户名";
        [self.view addSubview:self.userNameText];
        [self.userNameText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.top.mas_equalTo(self.view.mas_top).with.offset(70);
            make.right.mas_equalTo(self.view.mas_right).with.offset(-15);
            make.height.mas_equalTo(@40);
        }];
    }
    
    if(!self.loginButton)
    {
        self.loginButton=[[UIButton alloc]init];
        [self.loginButton setTitle:@"响应" forState:UIControlStateNormal];
        self.loginButton.backgroundColor=[UIColor blueColor];
        [self.view addSubview:self.loginButton];
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.top.mas_equalTo(self.userNameText.mas_bottom).with.offset(20);
            make.right.mas_equalTo(self.view.mas_right).with.offset(-15);
            make.height.mas_equalTo(@40);
        }];
    }
    
    if(!self.racCommendButton)
    {
        self.racCommendButton=[[UIButton alloc]init];
        [self.racCommendButton setTitle:@"RacCommend测试" forState:UIControlStateNormal];
        self.racCommendButton.backgroundColor=[UIColor blueColor];
        [self.view addSubview:self.racCommendButton];
        [self.racCommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.top.mas_equalTo(self.loginButton.mas_bottom).with.offset(20);
            make.right.mas_equalTo(self.view.mas_right).with.offset(-15);
            make.height.mas_equalTo(@40);
        }];
    }
}
@end
