//
//  MPLogInViewControllerTest.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/31.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <XCTest/XCTest.h>
//把原本在项目pch中那些第三方插件的头文件也要引入

#import <ReactiveCocoa/ReactiveCocoa.h>

//测试LogInViewController
#import "RACTestLoginViewController.h"

@interface MPLogInViewControllerTest : XCTestCase

@property(nonatomic,strong)RACTestLoginViewController *logInVC;

@end

@implementation MPLogInViewControllerTest

- (void)setUp {
    [super setUp];
    
    self.logInVC=[RACTestLoginViewController new];
    //初始化完controller之后，controller一定要调用view方法来加载controller的view，否则不会调用viewDidLoad方法。
    [self.logInVC view];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    self.logInVC=nil;
    
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    self.logInVC.userNameText.text=@"wujunyang";
    self.logInVC.passWordTest.text=@"123456";
//
    //一定要调用sendActionsForControlEvents方法来通知UI已经更新 因为RAC是监听这个输入框的变化
    [self.logInVC.userNameText sendActionsForControlEvents:UIControlEventEditingChanged];
    [self.logInVC.passWordTest sendActionsForControlEvents:UIControlEventEditingChanged];
//
    XCTAssertEqual(self.logInVC.myLoginViewModel.username, self.logInVC.userNameText.text,@"绑定用户名出现问题");
    XCTAssertEqual(self.logInVC.myLoginViewModel.password,self.logInVC.passWordTest.text,@"绑定用户名出现问题");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
