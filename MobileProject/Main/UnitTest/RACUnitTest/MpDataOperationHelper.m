//
//  MpDataOperationHelper.m
//  MobileProject
//
//  Created by wujunyang on 2017/4/1.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MpDataOperationHelper.h"
#import "GCD.h"

@interface MpDataOperationHelper()

@property(nonatomic,copy)blockSuccessHandle myHandleBlock;

@end

@implementation MpDataOperationHelper


-(instancetype)init
{
    self=[super init];
    if (self) {
        _mockHelper=[[MpMockDataHelper alloc]init];
    }
    return self;
}

-(void)startWithErrorBlcok:(blockSuccessHandle)errorBlock
{
    _myHandleBlock=errorBlock;

    //等待5秒后回调出去
    [[GCDQueue mainQueue] execute:^{
        _myHandleBlock(@"abcd");
    } afterDelaySecs:5];
}

-(NSString *)getCurUserName
{
    return self.userName;
}


-(NSInteger) writeResultToDatabaseWithNum:(NSInteger)lowNum heightNum:(NSInteger)heightNum
{
    NSInteger result=[self sunTwoNum:lowNum rightNum:heightNum];
    
    NSLog(@"当前的值：%ld",result);
    
    return result+10;
}

-(NSInteger)sunTwoNum:(NSInteger)leftNum rightNum:(NSInteger)rightNum
{
    //这里面我们还会做很多逻辑处理，比如写入数据库等操作
    
    return leftNum+rightNum;
}


-(NSInteger)testMockResultToDataBaseWith:(NSInteger)firstNum
{
    NSInteger result=[self.mockHelper sunOneNum:firstNum];
    
    NSLog(@"当前的值：%ld",result);
    
    return result+5;
}


@end
