## Upgrade to V4

`Fluwx v4` not only brings a lot exciting functionalities but also breaking changes。

- Now we need to initialize the instance using `Fluwx fluwx = Fluwx()`
- Listening response from WeChat changed to `subscribeResponse` and also adding `unsubscribeResponse` to support 
  cancel listening.  
- Keyword `wechat` in some functions is removed.
- Some functions are extracted to a single function，and now you can pass different params instead.
- Some configurations are moved to[pubspec.yaml](../example/pubspec.yaml)，for example, you can enable/disable log in `pubspec.yaml`.
- `no_pay` can be enabled by [pubspec.yaml](../example/pubspec.yaml), reference example for more details.