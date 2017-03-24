//
//  BaseModel.h
//  MobileProject
//
//  Created by wujunyang on 16/1/13.
//  Copyright © 2016年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : JSONModel

@property(nonatomic,strong)NSString<Optional> *status;
@property(nonatomic,strong)NSString<Optional> *message;

@end
