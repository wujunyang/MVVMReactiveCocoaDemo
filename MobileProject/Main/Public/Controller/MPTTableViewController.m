//
//  MPTTableViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/1.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTTableViewController.h"
#import "MPNoticeListViewModel.h"
#import "MPNoticeServiceImp.h"
#import "MPNoticeService.h"
#import "AppDelegate.h"


@interface MPTTableViewController ()

@property(nonatomic,strong)MPHomePageViewModel *viewModel;

@end

@implementation MPTTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupTabBarController];
        
        self.tabBar.selectedImageTintColor =RGB(182, 65, 65);
        
        //显示未读
        UINavigationController  *discoverNav =(UINavigationController *)self.viewControllers[1];
        UITabBarItem *curTabBarItem=discoverNav.tabBarItem;
        [curTabBarItem setBadgeValue:@"2"];
    }
    return self;
}

- (instancetype)initWithViewModel:(MPHomePageViewModel *)viewModel
{
    self=[super init];
    if (self) {
        _viewModel=viewModel;
        
        [self setupTabBarController];
    }
    return self;
}


- (void)setupTabBarController {
    /// 设置TabBar属性数组
    self.tabBarItemsAttributes =[self tabBarItemsAttributesForController];
    
    /// 设置控制器数组
    self.viewControllers =[self mpViewControllers];
    
    self.delegate = self;
    self.moreNavigationController.navigationBarHidden = YES;
    
    
    [((AppDelegate*)AppDelegateInstance).navigationControllerStack pushNavigationController:(UINavigationController *)self.viewControllers[0]];
    
    [[self
      rac_signalForSelector:@selector(tabBarController:shouldSelectViewController:)
      fromProtocol:@protocol(UITabBarControllerDelegate)]
     subscribeNext:^(RACTuple *tuple) {
         [((AppDelegate*)AppDelegateInstance).navigationControllerStack popNavigationController];
         [((AppDelegate*)AppDelegateInstance).navigationControllerStack pushNavigationController:tuple.second];
     }];
}


//控制器设置
- (NSArray *)mpViewControllers {
    //HomeViewController *firstViewController = [[HomeViewController alloc] init];
    
    MPProjectViewController *firstViewController=[[MPProjectViewController alloc]initWithViewModel:self.viewModel.projectViewModel];
    
    UINavigationController *firstNavigationController = [[MPTBaseNavigationViewController alloc]
                                                         initWithRootViewController:firstViewController];
    
    MPTTheoryViewController *secondViewController = [[MPTTheoryViewController alloc] initWithViewModel:self.viewModel.theoryViewModel];
    UINavigationController *secondNavigationController = [[MPTBaseNavigationViewController alloc]
                                                          initWithRootViewController:secondViewController];
    
    MPSystemViewController *thirdViewController = [[MPSystemViewController alloc] initWithViewModel:self.viewModel.systemViewModel];
    UINavigationController *thirdNavigationController = [[MPTBaseNavigationViewController alloc]
                                                         initWithRootViewController:thirdViewController];
    
    
    NSArray *viewControllers = @[
                                 firstNavigationController,
                                 secondNavigationController,
                                 thirdNavigationController
                                 ];
    return viewControllers;
}

//TabBar文字跟图标设置
- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"home_normal",
                                                 CYLTabBarItemSelectedImage : @"home_highlight",
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"基础",
                                                  CYLTabBarItemImage : @"mycity_normal",
                                                  CYLTabBarItemSelectedImage : @"mycity_highlight",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"网络",
                                                 CYLTabBarItemImage : @"message_normal",
                                                 CYLTabBarItemSelectedImage : @"message_highlight",
                                                 };
    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}


#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController*)tabBarController shouldSelectViewController:(UINavigationController*)viewController {
    /// 特殊处理 - 是否需要登录
    BOOL isBaiDuService = [viewController.topViewController isKindOfClass:[MPTTheoryViewController class]];
    if (isBaiDuService) {
        NSLog(@"你点击了TabBar第二个");
    }
    return YES;
}


@end
