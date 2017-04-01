//
//  RACTestLoginViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/31.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "RACTestLoginViewController.h"

@interface RACTestLoginViewController ()

@property(nonatomic,strong,readwrite)UITextField *userNameText,*passWordTest;
@property(nonatomic,strong,readwrite)testLoginViewModel *myLoginViewModel;
@property(nonatomic,strong)UIButton *loginButton;

@end

@implementation RACTestLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor grayColor];
    
    //加载布局
    [self layoutPage];
    
    if (!self.myLoginViewModel) {
        self.myLoginViewModel=[[testLoginViewModel alloc]init];
    }
    
    //绑定
    RAC(self.myLoginViewModel,username) = self.userNameText.rac_textSignal;
    RAC(self.myLoginViewModel,password) = self.passWordTest.rac_textSignal;
    
    self.loginButton.rac_command=self.myLoginViewModel.loginCommand;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
}

@end
