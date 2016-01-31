//
//  TestRacViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/30.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "TestRacViewController.h"
#import "RACReturnSignal.h"

@interface TestRacViewController ()
@property(nonatomic,strong)UITextField *userNameText;
@property(strong,nonatomic)NSString *username;
@property(nonatomic,strong)UIButton *loginButton,*racCommendButton,*errCommendButton,*mainThreadButton,*netWorkButton;

@property(nonatomic,strong)RACCommand *otherMyRaccomand,*mainThreadCommend,*netWorkCommend;
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
    
    
    //关于otherMyRaccomand的方式
    self.errCommendButton.rac_command=self.otherMyRaccomand;
    
    [self.otherMyRaccomand.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"完成了 %@",x);
    }];
    
    //这边要注意是在errors 里面执行subscribeNext   不是执行subscribeError
    [self.otherMyRaccomand.errors subscribeNext:^(NSError *error) {
        NSLog(@"出错了 %@",error);
    }];
    
    
    //主线程上操作
    self.mainThreadButton.rac_command=self.mainThreadCommend;
    [[[self.mainThreadCommend.executionSignals.switchToLatest map:^id(id value) {
        if ([value boolValue]) {
            return @"跳浪帅";
        }
        else
        {
            return @"出太阳好么";
        }
    }] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSString *str) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"我是弹出窗" message:[NSString stringWithFormat:@"%@",str] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
    //网络请求
    //Button响应事件
    [[self.netWorkButton
      rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         [[[self netSignal] flattenMap:^RACStream *(id value) {
              return [RACReturnSignal return:[NSString stringWithFormat:@"%@ 我已经被改变了成为另外一个信号",value]];
         }]
         subscribeNext:^(id x) {
             NSLog(@"输出的内容:%@",x);
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

//创建属性的RACCommand
-(RACCommand *)otherMyRaccomand
{
    if (!_otherMyRaccomand) {
        _otherMyRaccomand=[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSLog(@"执行到新的RACCommand");
            RACSignal *otherSignal=[RACSignal empty];
            otherSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                if ([self.username isEqualToString:@"wjy"]) {
                    [subscriber sendNext:@"我肯定可以运行的"];
                    [subscriber sendCompleted];
                }
                else
                {
                    [subscriber sendError:[NSError errorWithDomain:@"报错了" code:401 userInfo:nil]];
                }
                return nil;
            }];
            return otherSignal;
        }];
    }
    return _otherMyRaccomand;
}


//创建主线程上运行
-(RACCommand *)mainThreadCommend
{
    @weakify(self);
    if (!_mainThreadCommend) {
    _mainThreadCommend=[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *authSignal=[RACSignal empty];
        @strongify(self);
        
        authSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            //可以根据要求加条件进行判断是否创建信号
            if ([self.username isEqualToString:@"wjy"]) {
                [subscriber sendNext:@(YES)];
                [subscriber sendCompleted];
            }
            else
            {
                //错误
                [subscriber sendError:[NSError errorWithDomain:@"报错了" code:1 userInfo:nil]];
            }
            return nil;
        }];
        return authSignal;
    }];
    }
    return _mainThreadCommend;
}

//网络请求
-(RACCommand *)netWorkCommend
{
    @weakify(self);
    if (!_netWorkCommend) {
        _netWorkCommend=[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            RACSignal *authSignal=[RACSignal empty];
            @strongify(self);
            
            authSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                LogInApi *reg = [[LogInApi alloc] initWithUsername:self.username password:@"123456"];
                [reg startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
                    LoginModel *model=[[LoginModel alloc]initWithString:request.responseString error:nil];
                    [subscriber sendNext:model];
                    [subscriber sendCompleted];
                } failure:^(YTKBaseRequest *request) {
                    [subscriber sendError:[NSError errorWithDomain:@"报错了" code:1 userInfo:nil]];
                }];
                return nil;
            }];
            return authSignal;
        }];
    }
    return _netWorkCommend;
}

-(RACSignal *)nettestSignal
{
    RACSignal *authSignal=[RACSignal empty];
    
    authSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        LogInApi *reg = [[LogInApi alloc] initWithUsername:self.username password:@"123456"];
        [reg startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            LoginModel *model=[[LoginModel alloc]initWithString:request.responseString error:nil];
            [subscriber sendNext:model];
            [subscriber sendCompleted];
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:[NSError errorWithDomain:@"报错了" code:1 userInfo:nil]];
        }];
        return nil;
    }];
    return authSignal;
}

-(RACSignal *)netSignal
{
    RACSignal *authSignal=[RACSignal empty];
    authSignal=[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"测试"];
        [subscriber sendCompleted];

        return nil;
    }];
    return authSignal;
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
    
    if(!self.errCommendButton)
    {
        self.errCommendButton=[[UIButton alloc]init];
        [self.errCommendButton setTitle:@"ERROR测试" forState:UIControlStateNormal];
        self.errCommendButton.backgroundColor=[UIColor blueColor];
        [self.view addSubview:self.errCommendButton];
        [self.errCommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.top.mas_equalTo(self.racCommendButton.mas_bottom).with.offset(20);
            make.right.mas_equalTo(self.view.mas_right).with.offset(-15);
            make.height.mas_equalTo(@40);
        }];
    }
    
    if(!self.mainThreadButton)
    {
        self.mainThreadButton=[[UIButton alloc]init];
        [self.mainThreadButton setTitle:@"主线程上运行" forState:UIControlStateNormal];
        self.mainThreadButton.backgroundColor=[UIColor blueColor];
        [self.view addSubview:self.mainThreadButton];
        [self.mainThreadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.top.mas_equalTo(self.errCommendButton.mas_bottom).with.offset(20);
            make.right.mas_equalTo(self.view.mas_right).with.offset(-15);
            make.height.mas_equalTo(@40);
        }];
    }
    
    if(!self.netWorkButton)
    {
        self.netWorkButton=[[UIButton alloc]init];
        [self.netWorkButton setTitle:@"属性测试" forState:UIControlStateNormal];
        self.netWorkButton.backgroundColor=[UIColor blueColor];
        [self.view addSubview:self.netWorkButton];
        [self.netWorkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.top.mas_equalTo(self.mainThreadButton.mas_bottom).with.offset(20);
            make.right.mas_equalTo(self.view.mas_right).with.offset(-15);
            make.height.mas_equalTo(@40);
        }];
    }
}
@end
