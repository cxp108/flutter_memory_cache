Language: [English](README.md) | [中文简体](README-ZH.md)
# flutter_memory_cache

一个使用数据有效时间(ttl)来保证数据有效性的缓存的工具

## 说明

- 默认配置下，每个MemoryCache容量是1000，ttl是60秒
- 当缓存数量超过容量后会立刻进行清理
- 清理时根据ttl倒序来删除cache,但即使未执行清理，ttl已经到期失效的缓存在get时，依然会失效返回null
- 对某个key的缓存频繁获取，并不会延长这个缓存的失效时间

## 注意

- 这不是一个逻辑缓存工具，不能保证缓存的持续性，在某些特定条件下即使有效时间(ttl)未到期，缓存的对象依然可能被清理
- 不支持LRU策略，这个工具的使用思路不是长期缓存
- 还没全部测试过，暂时不要在生产环境下使用

## Getting Started

Add dependency

```yaml

dependencies:
   flutter_memory_cache: 0.0.1 #latest version

```

then

```dart


main(){
 MemoryCache memoryCache = MemoryCache();
 dynamic cache1 = {'name': 'obj1'};
 var cache2 = {'name': 'obj2'};
 memoryCache.put('obj1', cache1); //缓存默认有效周期是60秒
 memoryCache.putWithTTL(
     'cache2', cache2, 5); //cache2将在5秒后过期
 sleep(Duration(seconds:6));
 var ret = memoryCache.get('cache2');//cache2已经过期，所以得到null
 print('ret is $ret');
 ret = memoryCache.get('cache1');
 print('cache1 is $ret'); // cache1 is {name: obj1}
}

```
