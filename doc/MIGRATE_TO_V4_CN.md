## 升级到V4

`Fluwx v4`带来了很多令人兴奋的功能，但也带来了少破坏性更新。

- 现在我们需要使用`Fluwx fluwx = Fluwx()`初始化实例
- 监听微信回调变成了`subscribeResponse`并且增加了`unsubscribeResponse`以支持取消监听
- 很多带有`wechat`关键字的函数已经把`wechat`关键字删除了
- 很多方法被整到了一个函数中，现在你可以传递不同的对象实现对应的业务
- 一些配置被移动到了[pubspec.yaml](../example/pubspec.yaml)，可以通过`pubspec.yaml`配置是否开启日志等等
- `no_pay`现在也通过[pubspec.yaml](../example/pubspec.yaml)配置，具体可以参加example.