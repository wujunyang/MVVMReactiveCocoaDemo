
## MVVMReactiveCocoaDemo介绍

MVVMReactiveCocoaDemo是一个ReactiveCocoa知识整理，还包含一些如何结合MVVM进行开发的内容；ReactiveCocoa知识包含一些常见的实例和介绍说明；

# 一：关于ReactiveCocoa的知识点

1：RACSigner基础知识点

```obj-c

信号类(RACSiganl)，只是表示当数据改变时，信号内部会发出数据，它本身不具备发送信号的能力，而是交给内部一个订阅者去发出。

默认一个信号都是冷信号，也就是值改变了，也不会触发，只有订阅了这个信号，这个信号才会变为热信号，值改变了才会触发。

如何订阅信号：调用信号RACSignal的subscribeNext就能订阅

```

2：RACSubject基础知识点

3：RACSequence基础知识点

4：RACCommand基础知识点

5：RACMulticastConnection基础知识点

6：RAC结合UI一般事件

7：高阶操作知识内容

8：RAC并发编程知识点

9：冷信号跟热信号知识点

10：RACDisposable知识点

11：RACChannel知识点

12：RAC倒计时小实例"


# 二：关于使用ReactiveCocoa结合MVVM模式的实例；

包括关于公共内容的提取，在ViewModel中实现页面的跳转，列表的点击实事等；在源代码中还有关于简单的数据请求并绑定列表的功能；


<img src="https://github.com/wujunyang/MVVMReactiveCocoaDemo/blob/master/MobileProject/3.gif" width=200px height=300px></img>

