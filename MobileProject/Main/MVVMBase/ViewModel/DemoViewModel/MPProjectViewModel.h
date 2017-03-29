//
//  MPProjectViewModel.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/28.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPBaseViewModel.h"

@interface MPProjectViewModel : MPBaseViewModel

@property (strong, nonatomic,readonly) RACCommand *goToProjectDetailCommand;

@property (strong, nonatomic,readonly) RACCommand *goToProjectOrderCommand;

@end
