//
//  MPProjectViewModel.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/28.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPProjectViewModel.h"
#import "MPProjectDetailViewModel.h"
#import "MPProjectOrderViewModel.h"
#import "MPBaseViewModelServicesImpl.h"


@interface MPProjectViewModel()

@property (strong, nonatomic,readwrite) RACCommand *goToProjectDetailCommand;

@property (strong, nonatomic,readwrite) RACCommand *goToProjectOrderCommand;

@end


@implementation MPProjectViewModel

- (void)initialize {
    [super initialize];
    
    @weakify(self)
    self.goToProjectDetailCommand = [[RACCommand alloc] initWithSignalBlock:^(id input) {
        @strongify(self)
        
        MPProjectDetailViewModel *viewModel = [[MPProjectDetailViewModel alloc] initWithServices:self.services params:nil];
        
        viewModel.callback = ^(NSString *code) {
            @strongify(self)
            NSLog(@"%@",code);
            [self.services popViewModelAnimated:YES];
        };
        
        [self.services pushViewModel:viewModel animated:YES];
        
        return [RACSignal empty];
    }];
    
    
    self.goToProjectOrderCommand = [[RACCommand alloc] initWithSignalBlock:^(id input) {
        @strongify(self)
        
        NSDictionary *params = @{@"projectName":@"产品名称1"};
        
        MPProjectOrderViewModel *viewModel = [[MPProjectOrderViewModel alloc] initWithServices:self.services params:params];
        
        
        [self.services pushViewModel:viewModel animated:YES];
        
        return [RACSignal empty];
    }];
}

@end
