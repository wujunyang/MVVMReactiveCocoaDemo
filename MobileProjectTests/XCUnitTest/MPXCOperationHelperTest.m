//
//  MPXCOperationHelperTest.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/30.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPXCOperationHelper.h"

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
//断言,最基本的测试，如果expression为true则通过，否则打印后面格式化字符串
//XCTAssert(expression, format...)

//Bool测试:
//XCTAssertTrue(expression, format...)
//XCTAssertFalse(expression, format...)

//相等测试
//XCTAssertEqual(expression1, expression2, format...)
//XCTAssertNotEqual(expression1, expression2, format...)

//double float 对比数据测试使用
//XCTAssertEqualWithAccuracy(expression1, expression2, accuracy, format...)
//XCTAssertNotEqualWithAccuracy(expression1, expression2, accuracy, format...)

//Nil测试，XCTAssert[Not]Nil断言判断给定的表达式值是否为nil
//XCTAssertNil(expression, format...)
//XCTAssertNotNil(expression, format...)

//失败断言
//XCTFail(format...)


@implementation MPXCOperationHelperTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _xcOperationHelper=[MPXCOperationHelper new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    _xcOperationHelper=nil;
    
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    //故意
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    
    XCTAssertNil(_xcOperationHelper,@"MPXCOperationHelper初始化有问题");
    
    XCTAssertTrue(_xcOperationHelper.nameList.count>0,@"数组目前没有内容");
    
    XCTAssertEqual([_xcOperationHelper mpSumOperationWith:2 rightNum:4], 6, @"输出相加有问题");
    
    if (_xcOperationHelper.nameList.count==0) {
        XCTFail(@"MPXCOperationHelper 目前的nameList存在问题");
    }
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
