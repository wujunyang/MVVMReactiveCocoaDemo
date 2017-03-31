
## MVVMReactiveCocoaDemo介绍

MVVMReactiveCocoaDemo是一个以学习ReactiveCocoa为主的项目，里面包含关于ReactiveCocoa基础知识点及如何结合MVVM进行开发，还有部分关于单元测试的知识，可以快速了解关于ReactiveCocoa如何运用在项目中，项目中的实例都有相应的介绍跟输出说明；项目中还有几个关于MVVM的实例，包含关于如何进行ViewModel进行跳转问题，还有网络请求及网络状态判断的功能点；

#### 一：关于ReactiveCocoa的知识点

1：RACSigner基础知识点

```obj-c

信号类(RACSiganl)，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。

默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。

如何订阅信号：调用信号RACSignal的subscribeNext就能订阅

```

常见的操作方法：

```obj-c

flattenMap map 用于把源信号内容映射成新的内容。

concat 组合 按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号

then 用于连接两个信号，当第一个信号完成，才会连接then返回的信号。

merge 把多个信号合并为一个信号，任何一个信号有新值的时候就会调用

zipWith 把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。

combineLatest:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。

reduce聚合:用于信号发出的内容是元组，把信号发出元组的值聚合成一个值

filter:过滤信号，使用它可以获取满足条件的信号.

ignore:忽略完某些值的信号.

distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。

take:从开始一共取N次的信号

takeLast:取最后N次的信号,前提条件，订阅者必须调用完成，因为只有完成，就知道总共有多少信号.

takeUntil:(RACSignal *):获取信号直到某个信号执行完成

skip:(NSUInteger):跳过几个信号,不接受。

switchToLatest:用于signalOfSignals（信号的信号），有时候信号也会发出信号，会在signalOfSignals中，获取signalOfSignals发送的最新信号。

doNext: 执行Next之前，会先执行这个Block

doCompleted: 执行sendCompleted之前，会先执行这个Block

timeout：超时，可以让一个信号在一定的时间后，自动报错。

interval 定时：每隔一段时间发出信号

delay 延迟发送next。

retry重试 ：只要失败，就会重新执行创建信号中的block,直到成功.

replay重放：当一个信号被多次订阅,反复播放内容

throttle节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。

```

2：RACSubject基础知识点

```obj-c
RACSubject:信号提供者，自己可以充当信号，又能发送信号  使用场景:通常用来代替代理，有了它，就不必要定义代理了

RACSubject使用步骤
1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
3.发送信号 sendNext:(id)value

RACSubject:底层实现和RACSignal不一样。
1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。

RACSubject实例进行map操作之后, 发送完毕一定要调用-sendCompleted, 否则会出现内存泄漏; 而RACSignal实例不管是否进行map操作, 不管是否调用-sendCompleted, 都不会出现内存泄漏.
原因 : 因为RACSubject是热信号, 为了保证未来有事件发生的时候, 订阅者可以收到信息, 所以需要对持有订阅者!

```

3：RACSequence基础知识点

```obj-c

RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典

通过RACSequence对数组进行操作
这里其实是三步
第一步: 把数组转换成集合RACSequence numbers.rac_sequence
第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。

```

4：RACCommand基础知识点

```obj-c

RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程

一、RACCommand使用步骤:
1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
3.执行命令 - (RACSignal *)execute:(id)input

二、RACCommand使用注意:
1.signalBlock必须要返回一个信号，不能传nil.
2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。

三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。

四、如何拿到RACCommand中返回信号发出的数据。
1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。

五、监听当前命令是否正在执行executing

六、使用场景,监听按钮点击，网络请求

```

5：RACMulticastConnection基础知识点

```obj-c

RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理
使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.

RACMulticastConnection使用步骤:
1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
2.创建连接 RACMulticastConnection *connect = [signal publish];
3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
4.连接 [connect connect]

RACMulticastConnection底层原理:
1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
3.1.订阅原始信号，就会调用原始信号中的didSubscribe
3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock


需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
解决：使用RACMulticastConnection就能解决.

```

6：RAC结合UI一般事件

```obj-c

rac_signalForSelector : 代替代理

rac_valuesAndChangesForKeyPath: KVO

rac_signalForControlEvents:监听事件

rac_addObserverForName 代替通知

rac_textSignal：监听文本框文字改变

rac_liftSelector:withSignalsFromArray:Signals:当传入的Signals(信号数组)，每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法。

```

7：高阶操作知识内容


8：RAC并发编程知识点


```obj-c

1: subscribeOn运用

    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"%@ 111",[NSThread currentThread]);
        
        //可以放更新UI操作
        
        [subscriber sendNext:@0.1];
        RACDisposable *disposable = [[RACScheduler scheduler] schedule:^{
            NSLog(@"%@ 5555",[NSThread currentThread]);
            [subscriber sendNext:@1.1];
            [subscriber sendCompleted];
        }];
        return disposable;
    }];
    [[RACScheduler scheduler] schedule:^{
        NSLog(@"%@ 222",[NSThread currentThread]);
        [[signal subscribeOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            NSLog(@"%@ %@",[NSThread currentThread], x);
        }]; }];
    NSLog(@"%@ 4444",[NSThread currentThread]);

//使用subscribeOn 可以让signal内的代码在主线程中运行，sendNext在哪个线程 则对应的订阅输出就在对应线程上，所以0.1输出是在主线程中； 所以当在signal里面可能要放一些更新UI的操作，而这些是要在主线程才能处理，而订阅者却无法确认，所以要使用subscribeOn让它在主线程中；
//能够保证didSubscribe block在指定的scheduler
//不能保证sendNext、 error、 complete在哪个scheduler


2：deliverOn运用

    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"%@ 111",[NSThread currentThread]);
        [subscriber sendNext:@0.1];
        RACDisposable *disposable = [[RACScheduler scheduler] schedule:^{
            NSLog(@"%@ 555",[NSThread currentThread]);
            [subscriber sendNext:@1.1];
            [subscriber sendCompleted];
        }];
        return disposable;
    }];
    [[RACScheduler scheduler] schedule:^{
        NSLog(@"%@ 222",[NSThread currentThread]);
        [[signal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
            NSLog(@"%@ %@",[NSThread currentThread], x);
            
            //可以放UI更新操作
            
        }]; }];

//当我们让订阅的处理代码在指定的线程中执行，而不必去关心发送信号的当前线程，就可以deliverOn
```


9：冷信号跟热信号知识点

```obj-c

Hot Observable是主动的，尽管你并没有订阅事件，但是它会时刻推送，就像鼠标移动；而Cold Observable是被动的，只有当你订阅的时候，它才会发布消息。

Hot Observable可以有多个订阅者，是一对多，集合可以与订阅者共享信息；而Cold Observable只能一对一，当有不同的订阅者，消息是重新完整发送。

热信号是主动的，即使你没有订阅事件，它仍然会时刻推送 而冷信号是被动的，只有当你订阅的时候，它才会发送消息
热信号可以有多个订阅者，是一对多，信号可以与订阅者共享信息 而冷信号只能一对一，当有不同的订阅者，消息会从新完整发送

冷信号与热信号的本质区别在于是否保持状态，冷信号的多次订阅是不保持状态的，而热信号的多次订阅可以保持状态


```

10：RACDisposable知识点

```obj-c

RACDisposable用于取消订阅信号，默认信号发送完之后就会主动的取消订阅。订阅信号使用的subscribeNext:方法返回的就是RACDisposable类型的对象

当订阅者发送信号- (void)sendNext:(id)value之后，会执行：- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock中的nextBlock。当nextBlock执行完毕也就意味着subscribeNext方法返回了RACDisposable对象。

1.如果不强引用订阅者对象，默认情况下会自动取消订阅，我们可以拿到RACDisposable 用+ (instancetype)disposableWithBlock:(void (^)(void))block做清空资源的一些操作了。

2.如果不希望自动取消订阅，我们应该强引用RACSubscriber * subscriber。在想要取消订阅的时候用- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock返回的RACDisposable对象去调用- (void)dispose方法

```

11：RACChannel知识点

```obj-c
    RACChannelTerminal *channelA = RACChannelTo(self, valueA);
    RACChannelTerminal *channelB = RACChannelTo(self, valueB);
    [[channelA map:^id(NSString *value) {
        if ([value isEqualToString:@"西"]) {
            return @"东";
        }
        return value;
    }] subscribe:channelB];
    [[channelB map:^id(NSString *value) {
        if ([value isEqualToString:@"左"]) {
            return @"右";
        }
        return value;
    }] subscribe:channelA];
    [[RACObserve(self, valueA) filter:^BOOL(id value) {
        return value ? YES : NO;
    }] subscribeNext:^(NSString* x) {
        NSLog(@"你向%@", x);
    }];
    [[RACObserve(self, valueB) filter:^BOOL(id value) {
        return value ? YES : NO;
    }] subscribeNext:^(NSString* x) {
        NSLog(@"他向%@", x);
    }];
    self.valueA = @"西";
    self.valueB = @"左";
    
    
    RACChannelTerminal *characterRemainingTerminal = RACChannelTo(_loginButton, titleLabel.text);
    
    [[self.userNameText.rac_textSignal map:^id(NSString *text) {
        return [@(100 - (NSInteger)text.length) stringValue];
    }] subscribe:characterRemainingTerminal];

```


12：RAC倒计时小实例

```obj-c
    //倒计时的效果
    RACSignal *(^counterSigner)(NSNumber *count)=^RACSignal *(NSNumber *count)
    {
        RACSignal *timerSignal=[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler];
        RACSignal *counterSignal=[[timerSignal scanWithStart:count reduce:^id(NSNumber *running, id next) {
            return @(running.integerValue -1);
        }] takeUntilBlock:^BOOL(NSNumber *x) {
            return x.integerValue<0;
        }];
        
        return [counterSignal startWith:count];
    };
    
    
    RACSignal *enableSignal=[self.myTextField.rac_textSignal map:^id(NSString *value) {
        return @(value.length==11);
    }];
    
    RACCommand *command=[[RACCommand alloc]initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
        return counterSigner(@10);
    }];
    
    RACSignal *counterStringSignal=[[command.executionSignals switchToLatest] map:^id(NSNumber *value) {
        return [value stringValue];
    }];
    
    RACSignal *resetStringSignal=[[command.executing filter:^BOOL(NSNumber *value) {
        return !value.boolValue;
    }] mapReplace:@"点击获得验证码"];
    
    //[self.myButton rac_liftSelector:@selector(setTitle:forState:) withSignals:[RACSignal merge:@[counterStringSignal,resetStringSignal]],[RACSignal return:@(UIControlStateNormal)],nil];
    
    //上面也可以写成下面这样
    @weakify(self);
    [[RACSignal merge:@[counterStringSignal,resetStringSignal]] subscribeNext:^(id x) {
        @strongify(self);
        [self.myButton setTitle:x forState:UIControlStateNormal];
    }];
    
    self.myButton.rac_command=command;
    
    
    //编写关于委托的编写方式 是在self上面进行rac_signalForSelector
    [[self
      rac_signalForSelector:@selector(textFieldShouldReturn:)
      fromProtocol:@protocol(UITextFieldDelegate)]
    	subscribeNext:^(RACTuple *tuple) {
            @strongify(self)
            if (tuple.first == self.myTextField)
            {
                NSLog(@"触发");
            };
        }];
    
    self.myTextField.delegate = self;

```

13：常见的宏定义运用

```obj-c

1：
RAC(TARGET, [KEYPATH, [NIL_VALUE]]):用于给某个对象的某个属性绑定
只要文本框文字改变，就会修改label的文字
RAC(self.labelView,text) = _textField.rac_textSignal;

2:
RACObserve(self, name):监听某个对象的某个属性,返回的是信号。
[RACObserve(self.view, center) subscribeNext:^(id x) {
    NSLog(@"%@",x);
}];


当RACObserve放在block里面使用时一定要加上weakify，不管里面有没有使用到self；否则会内存泄漏，因为RACObserve宏里面就有一个self
@weakify(self);
RACSignal *signal3 = [anotherSignal flattenMap:^(NSArrayController *arrayController) {
     //Avoids a retain cycle because of RACObserve implicitly referencing self
    @strongify(self);
    return RACObserve(arrayController, items);
}];

3:
@weakify(Obj)和@strongify(Obj),一般两个都是配套使用,在主头文件(ReactiveCocoa.h)中并没有导入，需要自己手动导入，RACEXTScope.h才可以使用。但是每次导入都非常麻烦，只需要在主头文件自己导入就好了

4:
RACTuplePack：把数据包装成RACTuple（元组类）
把参数中的数据包装成元组
RACTuple *tuple = RACTuplePack(@10,@20);

5:
RACTupleUnpack：把RACTuple（元组类）解包成对应的数据
把参数中的数据包装成元组
RACTuple *tuple = RACTuplePack(@"xmg",@20);

解包元组，会把元组的值，按顺序给参数里面的变量赋值
name = @"xmg" age = @20
RACTupleUnpack(NSString *name,NSNumber *age) = tuple;

```


#### 二：关于使用ReactiveCocoa结合MVVM模式的实例；

MVVM模式和MVC模式一样，主要目的是分离视图（View）和模型（Model），有几大优点

1. 低耦合。视图（View）可以独立于Model变化和修改，一个ViewModel可以绑定到不同的"View"上，当View变化的时候Model可以不变，当Model变化的时候View也可以不变。

2. 可重用性。你可以把一些视图逻辑放在一个ViewModel里面，让很多view重用这段视图逻辑。

3. 独立开发。开发人员可以专注于业务逻辑和数据的开发（ViewModel），设计人员可以专注于页面设计。

4. 可测试。界面素来是比较难于测试的，而现在测试可以针对ViewModel来写。



#### 三：单元测试知识

```obj-c

//知识点一：
//方法在XCTestCase的测试方法调用之前调用，可以在测试之前创建在test case方法中需要用到的一些对象等
//- (void)setUp ;
//当测试全部结束之后调用tearDown方法，法则在全部的test case执行结束之后清理测试现场，释放资源删除不用的对象等
//- (void)tearDown ;
//测试代码执行性能
//- (void)testPerformanceExample


//知识点二：
//通用断言
XCTFail(format…)
//为空判断，a1为空时通过，反之不通过；
XCTAssertNil(a1, format...)
//不为空判断，a1不为空时通过，反之不通过；
XCTAssertNotNil(a1, format…)
//当expression求值为TRUE时通过；
XCTAssert(expression, format...)
//当expression求值为TRUE时通过；
XCTAssertTrue(expression, format...)
//当expression求值为False时通过；
XCTAssertFalse(expression, format...)
//判断相等，[a1 isEqual:a2]值为TRUE时通过，其中一个不为空时，不通过；
XCTAssertEqualObjects(a1, a2, format...)
//判断不等，[a1 isEqual:a2]值为False时通过；
XCTAssertNotEqualObjects(a1, a2, format...)
//判断相等（当a1和a2是 C语言标量、结构体或联合体时使用,实际测试发现NSString也可以）；
XCTAssertEqual(a1, a2, format...)
//判断不等（当a1和a2是 C语言标量、结构体或联合体时使用）；
XCTAssertNotEqual(a1, a2, format...)
//判断相等，（double或float类型）提供一个误差范围，当在误差范围（+/-accuracy）以内相等时通过测试；
XCTAssertEqualWithAccuracy(a1, a2, accuracy, format...)
//判断不等，（double或float类型）提供一个误差范围，当在误差范围以内不等时通过测试；
XCTAssertNotEqualWithAccuracy(a1, a2, accuracy, format...)
//异常测试，当expression发生异常时通过，反之不通过；
XCTAssertThrows(expression, format...)
//异常测试，当expression发生specificException异常时通过；反之发生其他异常或不发生异常均不通过
XCTAssertThrowsSpecific(expression, specificException, format...)
//异常测试，当expression发生具体异常、具体异常名称的异常时通过测试，反之不通过；
XCTAssertThrowsSpecificNamed(expression, specificException, exception_name, format...)
//异常测试，当expression没有发生异常时通过测试；
XCTAssertNoThrow(expression, format…)
//异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过；
XCTAssertNoThrowSpecific(expression, specificException, format...)
//异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过
XCTAssertNoThrowSpecificNamed(expression, specificException, exception_name, format...)

```

#### 四：项目效果：

<img src="https://github.com/wujunyang/MVVMReactiveCocoaDemo/blob/master/MobileProject/3.gif" width=200px height=300px></img>


#### 五：ReactiveCocoa知识分享地址

ReactiveCocoa 和 MVVM 入门 http://yulingtianxia.com/blog/2015/05/21/ReactiveCocoa-and-MVVM-an-Introduction/

MVVM Tutorial with ReactiveCocoa  http://southpeak.github.io/blog/2014/08/08/mvvmzhi-nan-yi-:flickrsou-suo-shi-li/

ReactiveCocoa 1-官方readme文档翻译  http://cindyfn.com/reactivecocoa/2014/12/01/ios-frame-use-ReactiveCocoa.html

这样好用的ReactiveCocoa，根本停不下来  http://www.cocoachina.com/ios/20150817/13071.html

ReactiveCocoa基本组件：深入浅出RACCommand  http://www.tuicool.com/articles/nYJRvu

ReactiveCocoa自述：工作原理和应用  http://www.cocoachina.com/ios/20150702/12302.html

RACSignal的巧克力工厂 http://www.cnblogs.com/sunnyxx/p/3547763.html

ReactiveCocoa一些概念讲解  http://www.thinksaas.cn/group/topic/347067/

细说ReactiveCocoa的冷信号与热信号（二）：为什么要区分冷热信号  http://www.tuicool.com/articles/e2uMzyq

细说ReactiveCocoa的冷信号与热信号（三）：怎么处理冷信号与热信号  http://www.tuicool.com/articles/emIVZjY

最快让你上手ReactiveCocoa之基础篇   http://www.jianshu.com/p/87ef6720a096

最快让你上手ReactiveCocoa之进阶篇  http://www.jianshu.com/p/e10e5ca413b7

ReactiveCocoa基础：理解并使用RACCommand http://www.yiqivr.com/2015/10/19/%E8%AF%91-ReactiveCocoa%E5%9F%BA%E7%A1%80%EF%BC%9A%E7%90%86%E8%A7%A3%E5%B9%B6%E4%BD%BF%E7%94%A8RACCommand/  

RAC一些代码总结：https://github.com/shuaiwang007/RAC 

ReactiveCocoa小总结   http://www.jianshu.com/p/8fd6c8349774

如何在ReactiveCocoa中写单元测试   http://www.jianshu.com/p/412875512bd1
