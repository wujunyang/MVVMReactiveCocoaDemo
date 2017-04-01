//
//  testLoginViewModelSpec.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/31.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Kiwi/Kiwi.h>
//把原本在项目pch中那些第三方插件的头文件也要引入
#import <ReactiveCocoa.h>
#import "testLoginViewModel.h"


//spec_begin 就是当前spec这个的文件名 别写成要测试的那个类名 会出现：Duplicate interface definition for class的错误
SPEC_BEGIN(testLoginViewModelSpec)

describe(@"testLoginViewModel", ^{
    __block testLoginViewModel* viewModel = nil;
    
    beforeEach(^{
        viewModel = [testLoginViewModel new];
    });
    
    afterEach(^{
        viewModel = nil;
    });
    
    context(@"when username is wujunyang and password is freedom", ^{
        __block BOOL result = NO;
        
        it(@"should return signal that value is YES", ^{
            viewModel.username = @"wujunyang@126.com";
            viewModel.password = @"123456";
            
            [[viewModel isValidUsernameAndPasswordSignal] subscribeNext:^(id x) {
                result = [x boolValue];
            }];
            
             [[theValue(result) should] beYes];
        });
    });
    
    context(@"when username is samlau and password is freedom", ^{
        __block BOOL result = YES;
        
        it(@"should return signal that value is NO", ^{
            viewModel.username = @"samlau";
            viewModel.password = @"freedom";
            
            [[viewModel isValidUsernameAndPasswordSignal] subscribeNext:^(id x) {
                result = [x boolValue];
            }];
            
            [[theValue(result) should] beNo];
        });
    });
    
    context(@"when username is wujunyang@126.com and password is 12345", ^{
        __block BOOL result = YES;
        
        it(@"should return signal that value is NO", ^{
            viewModel.username = @"wujunyang@126.com";
            viewModel.password = @"12345";
            
            [[viewModel isValidUsernameAndPasswordSignal] subscribeNext:^(id x) {
                result = [x boolValue];
            }];
            
            [[theValue(result) should] beNo];
        });
    });
    
    
    //asynchronousFirstOrDefault运用
    context(@"when username is wujunyang@126 and password is samlau", ^{
        __block BOOL success = NO;
        __block NSError *error = nil;
        
        it(@"should login successfully", ^{
            viewModel.username = @"wujunyang@126.com";
            viewModel.password = @"12345";
            
            RACTuple *tuple = [[viewModel netWorkRacSignal] asynchronousFirstOrDefault:nil success:&success error:&error];
            
            //成功时返回的值 也可以用一个实体进行接回
            //{
            // "access_token": "560afa6d-2fb1-488f-8e08-7eb4296abaf6"
            //}
            
            NSDictionary *result = tuple.first;
            
            [[theValue(success) should] beYes];
            [[error should] beNil];
            [[result[@"access_token"] should] equal:@"560afa6d-2fb1-488f-8e08-7eb4296abaf6"];
        });
    });
    
   
//    也可以给请求列表进行单元测试    
//    context(@"when fetch food list ", ^{
//        __block BOOL successful = NO;
//        __block NSError *error = nil;
        
//        it(@"should receive data", ^{
//            RACSignal *result = [FoodListClient fetchFoodList];
//            RACTuple *tuple = [result asynchronousFirstOrDefault:nil success:&successful error:&error];
//            NSArray *foodList = tuple.first;
            
//            [[theValue(successful) should] beYes];
//            [[error should] beNil];
//            [[foodList shouldNot] beEmpty];
//        });
//    });
    
    
//    Block场景和Thread场景  shouldEventually默认是1秒  如果要设置时间可以用shouldEventuallyBeforeTimingOutAfter
//    it(@"can hook thread", ^{
//        [vc changeNameByThread];
//        [[expectFutureValue(vc.name) shouldEventually] equal:@"kiki"];
//    });
    
//    it(@"can hook blocks",^{
//        __weak NimoViewController *wVC = vc;
//        [vc changeNameWithBlock:^(NSString *name) {
//            wVC.name = name;
//        }];
//        [[expectFutureValue(vc.name) shouldEventually] equal:@"nimo for Block Function"];
//    });
    
    
//    测试是否真的执行到了Notification的方式来执行
//    it(@"can hook notification", ^{
//        [[@"Notify" should] bePosted];
        
//        NSNotification *myNotification = [NSNotification notificationWithName:@"Notify" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:myNotification];
//    });
    
    
});

SPEC_END
