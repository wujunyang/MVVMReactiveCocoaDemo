//
//  RACTestLoginViewController.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/31.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "testLoginViewModel.h"

@interface RACTestLoginViewController : UIViewController

@property(nonatomic,strong,readonly)UITextField *userNameText,*passWordTest;

@property(nonatomic,strong,readonly)testLoginViewModel *myLoginViewModel;

@end
