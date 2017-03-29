//
//  MPProjectOrderViewModel.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/29.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPProjectOrderViewModel.h"


@interface MPProjectOrderViewModel()

@property (nonatomic, copy, readwrite) NSString *projectName;

@end


@implementation MPProjectOrderViewModel


- (instancetype)initWithServices:(id<MPBaseViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.projectName = params[@"projectName"];
    }
    return self;
}

- (void)initialize {
    [super initialize];
}


@end
