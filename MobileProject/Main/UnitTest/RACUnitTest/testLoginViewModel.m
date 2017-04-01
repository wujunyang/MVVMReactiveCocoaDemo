//
//  testLoginViewModel.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/31.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "testLoginViewModel.h"
#import "DataValidation.h"

@interface testLoginViewModel()

@property (nonatomic, strong, readwrite) RACCommand *loginCommand;

@end

@implementation testLoginViewModel

-(RACCommand *)loginCommand
{
    if (_loginCommand==nil) {
        
        _loginCommand=[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }
    
    return _loginCommand;
}

#pragma mark - Methods
- (RACSignal *)isValidUsernameAndPasswordSignal
{  
    return [RACSignal combineLatest:@[RACObserve(self, username), RACObserve(self, password)] reduce:^(NSString *username, NSString *password) {
        return @([DataValidation isValidEmail:username] && [DataValidation isValidPassword:password]);
    }];
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
    
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return [[manager rac_POST:@"user/login" parameters:userDic] subscribeNext:^(RACTuple *x) {
            
            //成功时返回的值 也可以用一个实体进行接回
            //{
            // "access_token": "560afa6d-2fb1-488f-8e08-7eb4296abaf6"
            //}
            
            [subscriber sendNext:x];
        } error:^(NSError *error) {
        } completed:^{
            [subscriber sendCompleted];
        }];
    }];
}

@end
