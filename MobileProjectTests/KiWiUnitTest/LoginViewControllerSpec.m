//
//  LoginViewControllerSpec.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/31.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Kiwi/Kiwi.h>
//把原本在项目pch中那些第三方插件的头文件也要引入
#import <DDLog.h>
#import <CocoaLumberjack.h>

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"
#import <Masonry/Masonry.h>
#import <JSONModel/JSONModel.h>
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "GVUserDefaults+BBProperties.h"
#import <RealReachability.h>
#import "AppDelegate.h"

//测试LogInViewController
#import "RACTestLoginViewController.h"


SPEC_BEGIN(LoginViewControllerSpec)

describe(@"RACTestLoginViewController", ^{
    __block RACTestLoginViewController *controller = nil;
    
    beforeEach(^{
        controller = [RACTestLoginViewController new];
        [controller view];
    });
    
    afterEach(^{
        controller = nil;
    });
    
    describe(@"Root View", ^{
        
        context(@"when view did load", ^{
            it(@"should bind data", ^{
                controller.userNameText.text=@"wujunyang";
                controller.passWordTest.text=@"123456";
                //
                //一定要调用sendActionsForControlEvents方法来通知UI已经更新 因为RAC是监听这个输入框的变化
                [controller.userNameText sendActionsForControlEvents:UIControlEventEditingChanged];
                [controller.passWordTest sendActionsForControlEvents:UIControlEventEditingChanged];
                
                [[controller.myLoginViewModel.username should] equal:controller.userNameText.text];
                [[controller.myLoginViewModel.password should] equal:controller.passWordTest.text];
            });
        });
        
    });
});

SPEC_END
