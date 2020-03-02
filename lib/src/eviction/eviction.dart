import 'package:flutter_memory_cache/src/cache/cache_entry.dart';

abstract class Eviction {
  ///@param cache
  ///@param startTime  计算ttl有效的时间点
  ///@param atLeast 要求最少清理掉的cache个数,注意:这里只接收正数
  evict(Map<String, CacheEntry> cache, int startTime, int atLeast);
}
