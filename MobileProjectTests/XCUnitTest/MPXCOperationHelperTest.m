//
//  MPXCOperationHelperTest.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/30.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPXCOperationHelper.h"


//简单的一些宏定义，更加方便使用

#define assertTrue(expr) XCTAssertTrue((expr), @"")

#define assertFalse(expr) XCTAssertFalse((expr), @"")

#define assertNil(a1) XCTAssertNil((a1), @"")

#define assertNotNil(a1) XCTAssertNotNil((a1), @"")

#define assertEqual(a1, a2) XCTAssertEqual((a1), (a2), @"")

#define assertEqualObjects(a1, a2) XCTAssertEqualObjects((a1), (a2), @"")

#define assertNotEqual(a1, a2) XCTAssertNotEqual((a1), (a2), @"")

#define assertNotEqualObjects(a1, a2) XCTAssertNotEqualObjects((a1), (a2), @"")

#define assertAccuracy(a1, a2, acc) XCTAssertEqualWithAccuracy((a1),(a2),(acc))


@interface MPXCOperationHelperTest : XCTestCase

@property(nonatomic,strong)MPXCOperationHelper *xcOperationHelper;

@end

//知识点一：
//方法在XCTestCase的测试方法调用之前调用，可以在测试之前创建在test case方法中需要用到的一些对象等
//- (void)setUp ;
//当测试全部结束之后调用tearDown方法，法则在全部的test case执行结束之后清理测试现场，释放资源删除不用的对象等
//- (void)tearDown ;
//测试代码执行性能
//- (void)testPerformanceExample


//知识点二：
//通用断言
//XCTFail(format…)
////为空判断，a1为空时通过，反之不通过；
//XCTAssertNil(a1, format...)
////不为空判断，a1不为空时通过，反之不通过；
//XCTAssertNotNil(a1, format…)
////当expression求值为TRUE时通过；
//XCTAssert(expression, format...)
////当expression求值为TRUE时通过；
//XCTAssertTrue(expression, format...)
////当expression求值为False时通过；
//XCTAssertFalse(expression, format...)
////判断相等，[a1 isEqual:a2]值为TRUE时通过，其中一个不为空时，不通过；
//XCTAssertEqualObjects(a1, a2, format...)
////判断不等，[a1 isEqual:a2]值为False时通过；
//XCTAssertNotEqualObjects(a1, a2, format...)
////判断相等（当a1和a2是 C语言标量、结构体或联合体时使用,实际测试发现NSString也可以）；
//XCTAssertEqual(a1, a2, format...)
////判断不等（当a1和a2是 C语言标量、结构体或联合体时使用）；
//XCTAssertNotEqual(a1, a2, format...)
////判断相等，（double或float类型）提供一个误差范围，当在误差范围（+/-accuracy）以内相等时通过测试；
//XCTAssertEqualWithAccuracy(a1, a2, accuracy, format...)
////判断不等，（double或float类型）提供一个误差范围，当在误差范围以内不等时通过测试；
//XCTAssertNotEqualWithAccuracy(a1, a2, accuracy, format...)
////异常测试，当expression发生异常时通过，反之不通过；
//XCTAssertThrows(expression, format...)
////异常测试，当expression发生specificException异常时通过；反之发生其他异常或不发生异常均不通过
//XCTAssertThrowsSpecific(expression, specificException, format...)
////异常测试，当expression发生具体异常、具体异常名称的异常时通过测试，反之不通过；
//XCTAssertThrowsSpecificNamed(expression, specificException, exception_name, format...)
////异常测试，当expression没有发生异常时通过测试；
//XCTAssertNoThrow(expression, format…)
////异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过；
//XCTAssertNoThrowSpecific(expression, specificException, format...)
////异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过
//XCTAssertNoThrowSpecificNamed(expression, specificException, exception_name, format...)


@implementation MPXCOperationHelperTest

// 在每一个测试用例开始前调用，用来初始化相关数据
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _xcOperationHelper=[MPXCOperationHelper new];
}

// 在测试用例完成后调用，可以用来释放变量等结尾操作
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    _xcOperationHelper=nil;
    
    [super tearDown];
}

// 必须以test为开头且不能带参数
-(void)testWJY
{
   // XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

//期望 异步 特别是网络请求
- (void)testAsynExample {
    XCTestExpectation *exp = [self expectationWithDescription:@"这里可以是操作出错的原因描述。。。"];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperationWithBlock:^{
        //模拟这个异步操作需要2秒后才能获取结果，比如一个异步网络请求
        sleep(2);
        //模拟获取的异步操作后，获取结果，判断异步方法的结果是否正确
        XCTAssertEqual(@"a", @"a");
        //如果断言没问题，就调用fulfill宣布测试满足
        [exp fulfill];
    }];
    //设置延迟多少秒后，如果没有满足测试条件就报错
    [self waitForExpectationsWithTimeout:3 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error); 
        }
    }];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    //故意
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    
    //XCTAssertNil(_xcOperationHelper,@"MPXCOperationHelper初始化有问题");
    
    XCTAssertTrue(_xcOperationHelper.nameList.count>0,@"数组目前没有内容");
    
    XCTAssertEqual([_xcOperationHelper mpSumOperationWith:2 rightNum:4], 6, @"输出相加有问题");
    
    if (_xcOperationHelper.nameList.count==0) {
        XCTFail(@"MPXCOperationHelper 目前的nameList存在问题");
    }
    
}

// 性能测试方法，通过测试block中方法执行的时间，比对设定的标准值和偏差觉得是否可以通过测试
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
