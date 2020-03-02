import 'dart:io';

import 'package:flutter_memory_cache/flutter_memory_cache.dart';

main() {
  // default config
  MemoryCache memoryCache = MemoryCache();
  dynamic cache1 = {'name': 'obj1'};
  var cache2 = {'name': 'obj2'};
  memoryCache.put('obj1', cache1); //default ttl 60 seconds
  memoryCache.putWithTTL(
      'cache2', cache2, 5); //cache2 will be invalidate in 30 seconds
  sleep(Duration(seconds:6));
  var ret = memoryCache.get('cache2');//
  print('ret is $ret');
  assert (ret == null);
  exit(0);
}
