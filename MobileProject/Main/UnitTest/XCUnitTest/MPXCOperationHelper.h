//
//  MPXCOperationHelper.h
//  MobileProject
//
//  Created by wujunyang on 2017/3/30.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPXCOperationHelper : NSObject

@property(nonatomic,copy,readonly)NSArray *nameList;

-(NSInteger)mpSumOperationWith:(NSInteger)leftNum rightNum:(NSInteger)rightNum;


@end
