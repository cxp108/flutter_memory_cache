import 'package:flutter_memory_cache/src/cache/cache_entry.dart';
import 'package:flutter_memory_cache/src/eviction/eviction.dart';

class VolatileEviction extends Eviction {


  evict(Map<String, CacheEntry> cache, int startTime, int atLeast) {
    List<CacheEntry> entries = cache.values.toList();
    entries.sort(compare);
    if (entries.first.invalid > startTime) {
      //所有的cache都还未过期,还是要按照atLeast要求淘汰一部分
      entries.getRange(0, atLeast).forEach((c) => cache.remove(c.key));
    } else if (entries.last.invalid < startTime || atLeast >= cache.length) {
      //全部过期或atLeast要求全部淘汰
      cache.clear();
    } else {
      for (int i = 0; i < entries.length; i++) {
        CacheEntry entry = entries[i];
        if (entry.invalid > startTime && atLeast <= 0) {
          //检查完所有过期时间符合条件的
          break;
        }
        atLeast--;
        cache.remove(entry.key);
      }
    }
  }


  int compare(CacheEntry a, CacheEntry b) {
    if (a.invalid > b.invalid) {
      return 1;
    } else if (a.invalid == b.invalid) {
      return 0;
    } else {
      return -1;
    }
  }
}
