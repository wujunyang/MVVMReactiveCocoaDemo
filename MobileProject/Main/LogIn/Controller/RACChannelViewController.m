//
//  RACChannelViewController.m
//  MobileProject
//
//  Created by wujunyang on 16/2/3.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "RACChannelViewController.h"

@interface RACChannelViewController ()
@property(nonatomic,strong)UITextField *userNameText;
@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,copy)NSString *valueA,*valueB;
@end

@implementation RACChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor redColor]];
    
    [self layoutPage];
    
    [self bindWithTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bindWithTest
{
    RACChannelTerminal *channelA = RACChannelTo(self, valueA);
    RACChannelTerminal *channelB = RACChannelTo(self, valueB);
    [[channelA map:^id(NSString *value) {
        if ([value isEqualToString:@"西"]) {
            return @"东";
        }
        return value;
    }] subscribe:channelB];
    [[channelB map:^id(NSString *value) {
        if ([value isEqualToString:@"左"]) {
            return @"右";
        }
        return value;
    }] subscribe:channelA];
    [[RACObserve(self, valueA) filter:^BOOL(id value) {
        return value ? YES : NO;
    }] subscribeNext:^(NSString* x) {
        NSLog(@"你向%@", x);
    }];
    [[RACObserve(self, valueB) filter:^BOOL(id value) {
        return value ? YES : NO;
    }] subscribeNext:^(NSString* x) {
        NSLog(@"他向%@", x);
    }];
    self.valueA = @"西";
    self.valueB = @"左";
    
    
    RACChannelTerminal *characterRemainingTerminal = RACChannelTo(_loginButton, titleLabel.text);
    
    [[self.userNameText.rac_textSignal map:^id(NSString *text) {
        return [@(100 - (NSInteger)text.length) stringValue];
    }] subscribe:characterRemainingTerminal];
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

    
    if(!self.loginButton)
    {
        self.loginButton=[[UIButton alloc]init];
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        self.loginButton.backgroundColor=[UIColor blueColor];
        [self.view addSubview:self.loginButton];
        [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).with.offset(15);
            make.top.mas_equalTo(self.userNameText.mas_bottom).with.offset(20);
            make.right.mas_equalTo(self.view.mas_right).with.offset(-15);
            make.height.mas_equalTo(@40);
        }];
    }
}

@end
