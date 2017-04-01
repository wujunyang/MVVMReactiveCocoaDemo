//
//  MpDataOperationHelper.h
//  MobileProject
//
//  Created by wujunyang on 2017/4/1.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MpMockDataHelper.h"

typedef void(^blockSuccessHandle)(NSString *name);

@interface MpDataOperationHelper : NSObject


@property(nonatomic,strong)NSString *userName;

@property(nonatomic,strong) MpMockDataHelper *mockHelper;

//测试异步回调
-(void)startWithErrorBlcok:(blockSuccessHandle)errorBlock;

-(NSString *)getCurUserName;

//测试Stub 用法
-(NSInteger) writeResultToDatabaseWithNum:(NSInteger)lowNum heightNum:(NSInteger)heightNum;

-(NSInteger)sunTwoNum:(NSInteger)leftNum rightNum:(NSInteger)rightNum;

//测试mock 用法
-(NSInteger)testMockResultToDataBaseWith:(NSInteger)firstNum;

@end
