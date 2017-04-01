//
//  DataValidationSpec.m
//  MobileProject
//
//  Created by wujunyang on 2017/4/1.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "DataValidation.h"


SPEC_BEGIN(DataValidationSpec)

describe(@"DataValidation", ^{
    context(@"when email is saSmlSau@163.com", ^{
        it(@"should return YES", ^{
            BOOL result = [DataValidation isValidEmail:@"saSmlSau@163.com"];
            [[theValue(result) should] beYes];
        });
    });
    
    context(@"when email is saSmlSau@.com", ^{
        it(@"should return YES", ^{
            BOOL result = [DataValidation isValidEmail:@"saSmlSau@.com"];
            [[theValue(result) should] beNo];
        });
    });
    
    context(@"when password is sam", ^{
        it(@"should return NO", ^{
            BOOL result = [DataValidation isValidPassword:@"sam"];
            [[theValue(result) should] beNo];
        });
    });
    
    context(@"when password is samlau", ^{
        it(@"should return YES", ^{
            BOOL result = [DataValidation isValidPassword:@"samlau"];
            [[theValue(result) should] beYes];
        });
    });
});

SPEC_END
