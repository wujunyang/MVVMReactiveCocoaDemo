//
//  LoginViewModel.m
//  MobileProject
//
//  Created by wujunyang on 16/1/11.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import "LoginViewModel.h"

@interface LoginViewModel()
@property (nonatomic, strong, readwrite) RACSignal *validLoginSignal;
@property (nonatomic, strong, readwrite) RACCommand *loginCommand;
@end

@implementation LoginViewModel

-(id)init
{
    if (self = [super init] )
    {
        //验证信号
        self.validLoginSignal = [[RACSignal
                                  combineLatest:@[ RACObserve(self, username), RACObserve(self, password) ]
                                  reduce:^(NSString *username, NSString *password) {
                                      return @([self validUserName:username] && [self validPassWord:password]);
                                  }]
                                 distinctUntilChanged];
        
        //登录响应
        self.loginCommand=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [self netWorkRacSignal];
        }];
        
        //绑定access_token
        RAC(self,access_token)=[[[self.loginCommand executionSignals] switchToLatest]deliverOn:[RACScheduler mainThreadScheduler]];
        
        //绑定loading
        RAC(self, loading) =
        [self.loginCommand executing];
        
        //初始化错误处理
        self.errorSubject=[RACSubject subject];
    }
    return self;
}

/**
 *  @author wujunyang, 16-01-11 21:01:12
 *
 *  @brief  验证用户名
 *
 *  @param userName <#userName description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
-(BOOL)validUserName:(NSString *)userName
{
    BOOL result=false;

    if ([userName length]>0) {
         result=true;
    }
    return result;
}

/**
 *  @author wujunyang, 16-01-11 21:01:04
 *
 *  @brief  验证密码
 *
 *  @param passWord <#passWord description#>
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
-(BOOL)validPassWord:(NSString *)passWord
{
    BOOL result=false;
    
    if ([passWord isEqualToString:@"123456"]) {
        result=true;
    }
    return result;
}

/**
 *  @author wujunyang, 16-01-12 23:01:11
 *
 *  @brief  网络请求
 *
 *  @return <#return value description#>
 *
 *  @since <#version number#>
 */
-(RACSignal *)netWorkRacSignal
{
    NSDictionary *userDic=@{
                            @"user_name": self.username,
                            @"user_password": self.password
                            };
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                              initWithBaseURL:[NSURL URLWithString:@"http://private-eda65-blossom.apiary-mock.com/"]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [[manager rac_POST:@"user/login" parameters:userDic] subscribeNext:^(RACTuple *x) {
            LoginModel *model = [[LoginModel alloc]initWithDictionary:x.first error:nil];
            [subscriber sendNext:model.access_token];
        } error:^(NSError *error) {
            [self.errorSubject sendNext:error];
        } completed:^{
            [subscriber sendCompleted];
        }];
    }];
}

@end
