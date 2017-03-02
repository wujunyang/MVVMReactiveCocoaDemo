//
//  MPTRACUIKitViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/3/2.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTRACUIKitViewController.h"

@interface MPTRACUIKitViewController ()
@property(nonatomic,strong)UIButton *myButton;
@property(nonatomic,strong)UIView *myView;
@property(nonatomic,strong)UITextField *myTextField;
@property(nonatomic,strong)MPTUserModel *userModel;
@end

static NSString *MPTNotificationName=@"RacMPTNotification";

@implementation MPTRACUIKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    if (!_myButton) {
        _myButton=[UIButton new];
        [_myButton setTitle:@"保存" forState:UIControlStateNormal];
        _myButton.backgroundColor=[UIColor blackColor];
        [self.view addSubview:_myButton];
        [_myButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(120);
            make.left.mas_equalTo(20);
        }];
    }
    
    if (!_myTextField) {
        _myTextField=[UITextField new];
        _myTextField.backgroundColor=[UIColor blueColor];
        [self.view addSubview:_myTextField];
        [_myTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(70);
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
    }
    
    if (!_myView) {
        _myView=[UIView new];
        _myView.backgroundColor=[UIColor redColor];
        [self.view addSubview:_myView];
        [_myView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(200);
            make.left.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(180, 180));
        }];
    }
    
    if (!_userModel) {
        _userModel=[MPTUserModel new];
        _userModel.userName=@"wujunyang";
    }
    
    @weakify(self);
    
    //RAC
    //1:rac_signalForControlEvents监听事件
    [[self.myButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        //改变属性 触发KVO
        self.userModel.userName=@"cnblogs";
        //发送通知 触发通知监听
         [[NSNotificationCenter defaultCenter] postNotificationName:MPTNotificationName object:nil];
        NSLog(@"rac_signalForControlEvents监听事件");
    }];
    
    //2:rac_textSignal 监听文本框的文字改变
    [[self.myTextField rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"rac_textSignal当前输入:%@",x);
    }];
    
    //3:rac_valuesAndChangesForKeyPath  KVO监听
    [[self.userModel rac_valuesAndChangesForKeyPath:@"userName" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"userName的值：%@",x);
    }];
    
    //4:监听通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:MPTNotificationName object:nil] subscribeNext:^(id x) {
        NSLog(@"收到通知了");
    }];
    
    //5:替换代理方法的实现 rac_signalForSelector
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RAC" message:@"RAC TEST" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"other", nil];
    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        NSLog(@"tuple.first:%@",tuple.first);
        NSLog(@"tuple.second:%@",tuple.second);
        NSLog(@"tuple.third:%@",tuple.third);
        //tuple.first UIAlertView当前对象
        //tuple.second索引值
    }];
    [alertView show];
    
    //UIAlertView 还有更简便的 上面只是为了演示rac_signalForSelector  下面的X就是索引值
    //[[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
    //NSLog(@"%@",x);
    //}];
    
    // 6.处理多个请求，都返回结果的时候，统一做处理. rac_liftSelector
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 更新UI
- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPTNotificationName object:nil];
}



@end
