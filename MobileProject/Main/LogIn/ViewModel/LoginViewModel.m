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
@property (nonatomic, strong) RACDisposable *currentDisposable;
@end

@implementation LoginViewModel

-(id)init
{
    if (self = [super init] )
    {
        self.validLoginSignal = [[RACSignal
                                  combineLatest:@[ RACObserve(self, username), RACObserve(self, password) ]
                                  reduce:^(NSString *username, NSString *password) {
                                      return @([self validUserName:username] && [self validPassWord:password]);
                                  }]
                                 distinctUntilChanged];
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

    if ([userName isEqualToString:@"wujunyang"]) {
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
    
    return [manager rac_POST:@"user/login" parameters:userDic];
//    return [[manager rac_POST:@"user/login" parameters:userDic] subscribeNext:^(RACTuple *JSONAndHeaders) {
//        @strongify(self)
//        LoginModel *model=[[LoginModel alloc]initWithDictionary:JSONAndHeaders.first error:nil];
//        self.access_token=model.access_token;
//        DDLogError(@"%@",model.access_token);
//    }];
}

@end
