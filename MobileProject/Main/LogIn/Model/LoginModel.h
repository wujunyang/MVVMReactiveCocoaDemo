//
//  LoginModel.h
//  MobileProject
//
//  Created by wujunyang on 16/1/5.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface LoginModel : BaseModel
@property(nonatomic,copy)NSString<Optional> *access_token;
@end
