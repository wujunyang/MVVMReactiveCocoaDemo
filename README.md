# MVVMReactiveCocoaDemo

一个使用ReactiveCocoa的MVVM实例；

#一：关于ReactiveCocoa的知识点

首先对RAC常用的知识点进行整理并都带有小实例：

1：RACSigner基础知识点

//信号类(RACSiganl)，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。
//
//默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。
//
//如何订阅信号：调用信号RACSignal的subscribeNext就能订阅


2：RACSubject基础知识点

//RACSubject:信号提供者，自己可以充当信号，又能发送信号  使用场景:通常用来代替代理，有了它，就不必要定义代理了

// RACSubject使用步骤
// 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
// 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 3.发送信号 sendNext:(id)value

// RACSubject:底层实现和RACSignal不一样。
// 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
// 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。

//RACSubject实例进行map操作之后, 发送完毕一定要调用-sendCompleted, 否则会出现内存泄漏; 而RACSignal实例不管是否进行map操作, 不管是否调用-sendCompleted, 都不会出现内存泄漏.
//原因 : 因为RACSubject是热信号, 为了保证未来有事件发生的时候, 订阅者可以收到信息, 所以需要对持有订阅者!


3：RACSequence基础知识点

//RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典

//通过RACSequence对数组进行操作
// 这里其实是三步
// 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
// 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
// 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。


4：RACCommand基础知识点

//RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程

// 一、RACCommand使用步骤:
// 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
// 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
// 3.执行命令 - (RACSignal *)execute:(id)input

// 二、RACCommand使用注意:
// 1.signalBlock必须要返回一个信号，不能传nil.
// 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
// 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
// 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。

// 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
// 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
// 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。

// 四、如何拿到RACCommand中返回信号发出的数据。
// 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
// 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。

// 五、监听当前命令是否正在执行executing

// 六、使用场景,监听按钮点击，网络请求


5：RACMulticastConnection基础知识点

//RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理
//使用注意:RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建.

// RACMulticastConnection使用步骤:
// 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
// 2.创建连接 RACMulticastConnection *connect = [signal publish];
// 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
// 4.连接 [connect connect]

// RACMulticastConnection底层原理:
// 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
// 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
// 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
// 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
// 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
// 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
// 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock


// 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
// 解决：使用RACMulticastConnection就能解决.


6：RAC结合UI一般事件

7：高阶操作知识内容

8：RAC并发编程知识点



9：冷信号跟热信号知识点

//Hot Observable是主动的，尽管你并没有订阅事件，但是它会时刻推送，就像鼠标移动；而Cold Observable是被动的，只有当你订阅的时候，它才会发布消息。
//Hot Observable可以有多个订阅者，是一对多，集合可以与订阅者共享信息；而Cold Observable只能一对一，当有不同的订阅者，消息是重新完整发送。
//热信号是主动的，即使你没有订阅事件，它仍然会时刻推送 而冷信号是被动的，只有当你订阅的时候，它才会发送消息
//热信号可以有多个订阅者，是一对多，信号可以与订阅者共享信息 而冷信号只能一对一，当有不同的订阅者，消息会从新完整发送
//冷信号与热信号的本质区别在于是否保持状态，冷信号的多次订阅是不保持状态的，而热信号的多次订阅可以保持状态



10：RACDisposable知识点

//RACDisposable用于取消订阅信号，默认信号发送完之后就会主动的取消订阅。订阅信号使用的subscribeNext:方法返回的就是RACDisposable类型的对象
//当订阅者发送信号- (void)sendNext:(id)value之后，会执行：- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock中的nextBlock。当nextBlock执行完毕也就意味着subscribeNext方法返回了RACDisposable对象。
//1.如果不强引用订阅者对象，默认情况下会自动取消订阅，我们可以拿到RACDisposable 用+ (instancetype)disposableWithBlock:(void (^)(void))block做清空资源的一些操作了。
//2.如果不希望自动取消订阅，我们应该强引用RACSubscriber * subscriber。在想要取消订阅的时候用- (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock返回的RACDisposable对象去调用- (void)dispose方法

11：RACChannel知识点

12：RAC倒计时小实例"


#二：关于使用ReactiveCocoa结合MVVM模式的实例；

包括关于公共内容的提取，在ViewModel中实现页面的跳转，列表的点击实事等；在源代码中还有关于简单的数据请求并绑定列表的功能；


<img src="https://github.com/wujunyang/MVVMReactiveCocoaDemo/blob/master/MobileProject/3.gif" width=200px height=300px></img>

