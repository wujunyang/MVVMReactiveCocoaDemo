//
//  MpDataOperationHelperSpec.m
//  MobileProject  异步测试
//
//  Created by wujunyang on 2017/4/1.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "MpDataOperationHelper.h"
#import "MpMockDataHelper.h"


//对于 Kiwi 的 stub，需要注意的是它不是永久有效的，在每个 it block 的结尾 stub 都会被清空，超出范围的方法调用将不会被 stub 截取到。


SPEC_BEGIN(MpDataOperationHelperSpec)

describe(@"MpDataOperationHelper", ^{
    context(@"测试block 等了五秒后再回调出来", ^{
        it(@"should return abcd", ^{
            __block NSString *result = @"";
            __block MpDataOperationHelper *helper=[[MpDataOperationHelper alloc]init];
            
            [helper startWithErrorBlcok:^(NSString *name) {
                result=name;
            }];
            
            //上面的block中代码故意让它是5秒后返回，如果要异步测试就要用到shouldEventuallyBeforeTimingOutAfter可以给它设置一个时间点，最好是可以设置长一点，毕竟现实的网络请求是不一定速度 

            [[expectFutureValue(result) shouldEventuallyBeforeTimingOutAfter(6) ] equal:@"abcd"];
            
        });
    });
    
    
    context(@"桩程序 (stub) 的运用 把某个属性设置成固定值", ^{
        it(@"should return abcd", ^{
            
            __block MpDataOperationHelper *helper=[[MpDataOperationHelper alloc]init];
            
            [helper stub:@selector(userName) andReturn:@"Tom"];
            
            helper.userName=@"wujunyang";
            
            NSString *testName = [helper userName];
            
            [[testName should] equal:@"Tom"];
        });
    });
    
    
    context(@"桩程序 (stub) 的运用 把sunTwoNum个方法设置成桩 运行时可以直接跳过 返回给定的值", ^{
        it(@"should return abcd", ^{
            
            __block MpDataOperationHelper *helper=[[MpDataOperationHelper alloc]init];
        
            NSInteger someResult=50;
            
            NSInteger leftNum=23;
            NSInteger rightNum=50;
            
            //theValue 是转化数据类型 一定要用 否则上面那个NSInteger是会有问题
            [helper stub:@selector(sunTwoNum:rightNum:)
                          andReturn:theValue(someResult)
                      withArguments:theValue(leftNum),theValue(rightNum)];
            
            //下面这两个参数的值 要跟上面桩两参数一样 才会用桩去替代掉 否则还是会去执行程序中的代码
            NSInteger result=[helper writeResultToDatabaseWithNum:leftNum heightNum:rightNum];
            
            [[theValue(result) should] equal:@60];
        });
    });
    
    
    context(@"mock 的运用 运行时可以直接跳过 返回给定的值", ^{
        it(@"should return abcd", ^{
            
            __block MpDataOperationHelper *helper=[[MpDataOperationHelper alloc]init];
            
            NSInteger numValue=20;
            
            //类MpMockDataHelper是MpDataOperationHelper中的一个属性，被调用
            id mockDataHelper=[MpMockDataHelper mock];
            
            //替换sunOneNum返回的值
            [[mockDataHelper should] receive:@selector(sunOneNum:) andReturn:theValue(10) withArguments:theValue(numValue)];
    
            //mockHelper是MpDataOperationHelper中关于MpMockDataHelper的属性名，用脏Stub取代掉成mockDataHelper
            [helper stub:@selector(mockHelper) andReturn:mockDataHelper];
            
            //下面这个numValue跟上面是一样  testMockResultToDataBaseWith是在从sunOneNum得到的结果中再加5 所以得到是15
            NSInteger result=[helper testMockResultToDataBaseWith:numValue];
            
            [[theValue(result) should] equal:@15];
        });
    });
});

SPEC_END
