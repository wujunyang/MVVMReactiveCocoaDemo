//
//  LogInViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()
@property(nonatomic,strong)UITextField *userNameText,*passWordTest;
@property(nonatomic,strong)UILabel *myTokenLabel;
@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)LoginViewModel *myLoginViewModel;
@end

@implementation LogInViewController

#pragma mark 控制器生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
    
    //加载布局
    [self layoutPage];
    
    if (!self.myLoginViewModel) {
        self.myLoginViewModel=[[LoginViewModel alloc]init];
    }
    
    //绑定
    @weakify(self);
    RAC(self.myLoginViewModel,username) = self.userNameText.rac_textSignal;
    RAC(self.myLoginViewModel,password) = self.passWordTest.rac_textSignal;
  //  RAC(self.loginButton,enabled) = [self.myLoginViewModel validLoginSignal];

    
    [RACObserve(self.myLoginViewModel, access_token) subscribeNext:^(NSString *accessToken) {
        @strongify(self);
        if ([accessToken length]>0) {
            self.myTokenLabel.text=accessToken;
        }
    }];
    
    //处理响应事件
    
    [[self.loginButton.rac_command executing] subscribeNext:^(id x) {
        NSLog(@"loading 是：%d",[x intValue]);
        if ([x boolValue]) {
            DDLogError(@"正在请求中...");
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
        else
        {
            DDLogError(@"请求完成");
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
    
    self.loginButton.rac_command=self.myLoginViewModel.loginCommand;
    
    [[self.loginButton.rac_command.executionSignals switchToLatest] subscribeNext:^(id x) {
        //成功登录
        NSLog(@"成功登录");
        [((AppDelegate*)AppDelegateInstance) setupHomeViewController];
    }];
    
    //处理错误
    [[self.myLoginViewModel errorSubject] subscribeNext:^(NSError *error) {
        @strongify(self)
        NSDictionary *errDic=error.userInfo;
        DDLogError(@"详细错误信息：%@",errDic);
        DDLogError(@"出现错误了：%@",[error localizedDescription]);
        self.myTokenLabel.text=[error localizedDescription];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 自定义代码


/**
 *  @author wujunyang, 16-01-11 17:01:29
 *
 *  @brief  进行页面布局
 *
 *  @since <#version number#>
 */
-(void)layoutPage
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
    
    if (!self.passWordTest) {
        self.passWordTest=[[UITextField alloc]init];
        self.passWordTest.backgroundColor=[UIColor whiteColor];
        self.passWordTest.placeholder=@"输入密码";
        [self.view addSubview:self.passWordTest];
        [self.passWordTest mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.top.mas_equalTo(self.userNameText.mas_bottom).with.offset(10);
            make.right.mas_equalTo(self.view.mas_right).with.offset(-15);
            make.height.mas_equalTo(@40);
        }];
    }
    
    if(!self.loginButton)
    {
        self.loginButton=[[UIButton alloc]init];
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        self.loginButton.backgroundColor=[UIColor blueColor];
        [self.view addSubview:self.loginButton];
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.top.mas_equalTo(self.passWordTest.mas_bottom).with.offset(20);
            make.right.mas_equalTo(self.view.mas_right).with.offset(-15);
            make.height.mas_equalTo(@40);
        }];
    }
    
    if (!self.myTokenLabel) {
        self.myTokenLabel=[[UILabel alloc]init];
        self.myTokenLabel.text=@"当前还没有登录";
        [self.view addSubview:self.myTokenLabel];
        [self.myTokenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.top.mas_equalTo(self.loginButton.mas_bottom).with.offset(20);
            make.right.mas_equalTo(self.view.mas_right).with.offset(-15);
            make.height.mas_equalTo(@40);
        }];
    }
}

@end
