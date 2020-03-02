import 'dart:io';

import 'package:flutter_memory_cache/flutter_memory_cache.dart';

main() {
  // when cache object number over capacity*0.8 more then  5 times(continuously) of evict check.
  // 基于容量的检查策略，当缓存数量超过水位线(容量*evictLevel)连续5次，则启动清理
  CapacitySensitivePolicy capacitySensitivePolicy = CapacitySensitivePolicy(
      evictLevel: 0.8, tolerance: 5);

  // when cache is overflow, Eviction will start immediately,cache will be droped.
  // default ttl set to 5 seconds
  // 当缓存数量大于容量(capacity)时，立刻启动清理,默认ttl设置为5秒
  MemoryCache memoryCache = MemoryCache(
      capacity: 3000, ttl: 5, policy: capacitySensitivePolicy);

  var cache1 = {'name': 'cache1'};
  var cache2 = {'name': 'cache2'};

  // Default ttl is 5 seconds
  memoryCache.put('cache1', cache1);

  memoryCache.putWithTTL('cache2', cache2,30);
  sleep(Duration(seconds: 6));
  var ret = memoryCache.get('cache1');
  print('cache1 is $ret');
  assert(ret == null);
  ret = memoryCache.get('cache2');
  print('cache2 is $ret');
  assert(ret != null);
}