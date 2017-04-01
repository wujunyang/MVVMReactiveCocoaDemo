//
//  DataValidation.h
//  MobileProject
//
//  Created by wujunyang on 2017/4/1.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataValidation : NSObject

+ (BOOL)isValidEmail:(NSString *)data;
+ (BOOL)isValidPassword:(NSString *)password;

@end
