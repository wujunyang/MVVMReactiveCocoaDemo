//
//  MPRouter.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/28.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPRouter.h"

@interface MPRouter()

@property (nonatomic, copy) NSDictionary *viewModelViewMappings; // viewModel到view的映射

@end

@implementation MPRouter

+ (instancetype)sharedInstance {
    static MPRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (MPBaseViewController *)viewControllerForViewModel:(MPBaseViewModel *)viewModel {
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    
//    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:[MPBaseViewController class]]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

- (NSDictionary *)viewModelViewMappings {
    return @{
             @"MPProjectViewModel": @"MPProjectViewController",
             @"MPProjectDetailViewModel":@"MPProjectDetailViewController",
             @"MPSystemViewModel":@"MPSystemViewController",
             @"MPHomePageViewModel":@"MPTTableViewController",
             @"MPTTheoryViewModel":@"MPTTheoryViewController",
             @"MPProjectOrderViewModel":@"MPProjectOrderViewController",
             @"MPSettingViewModel":@"MPSettingViewController"
             };
}

@end
