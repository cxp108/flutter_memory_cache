Language: [English](README.md) | [中文简体](README-ZH.md)

# flutter_memory_cache

flutter memory cache in Map with ttl support.

### Notice

- It's not for the logical cache because eviction will automatically remove cache.
- It use TTL(Time To Live) to make sure data can be refresh.
- This lib have **NOT** been fully tested yet, Please do **NOT** use it in production.

## Getting Started

Add dependency

```yaml

dependencies:
   flutter_memory_cache: #latest version

```

then

```dart
main(){
 MemoryCache memoryCache = MemoryCache();
 dynamic cache1 = {'name': 'obj1'};
 var cache2 = {'name': 'obj2'};
 memoryCache.put('obj1', cache1); //default ttl 60 seconds
 memoryCache.putWithTTL(
     'cache2', cache2, 5); //cache2 will be invalidate in 5 seconds
 sleep(Duration(seconds:6));
 var ret = memoryCache.get('cache2');//ret is null
 print('ret is $ret');
 ret = memoryCache.get('cache1');
 print('cache1 is $ret'); // cache1 is {name: obj1}
}
```
