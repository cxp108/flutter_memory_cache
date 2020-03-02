import 'dart:async';

import 'package:flutter_memory_cache/src/cache/cache_entry.dart';
import 'package:flutter_memory_cache/src/eviction/eviction.dart';
import 'package:flutter_memory_cache/src/eviction/volatile.dart';
import 'package:flutter_memory_cache/src/policy/capacity_sentive_policy.dart';
import 'package:flutter_memory_cache/src/policy/policy.dart';

class MemoryCache {
  int _ttl;

  int _capacity;

  Map<String, CacheEntry> _cacheMap;

  Eviction _eviction;

  Policy _policy;

  MemoryCache(
      {int ttl = 60, int capacity = 1000, Eviction eviction, Policy policy}) {
    this._ttl = ttl;
    this._capacity = capacity;
    _cacheMap = Map();
    _eviction = eviction == null ? VolatileEviction() : eviction;
    _policy = policy == null ? CapacitySensitivePolicy() : policy;
  }

  /// use cache default ttl
  put(String key, dynamic value) {
    putWithTTL(key, value, _ttl);
    _check();
  }

  /// use custom ttl
  putWithTTL(String key, dynamic value, int ttl) {
    int invalid = _now() + ttl;
    _putAtTime(key, value, invalid);
    _check();
  }

  _putAtTime(String key, dynamic value, int invalid) {
    CacheEntry cacheEntry = CacheEntry(key, value, invalid);
    _cacheMap[key] = cacheEntry;
  }

  int _checkPoint;

  _check() {
    // to prevent duplicate check
    if (_cacheMap.length == _checkPoint) {
      return;
    } else {
      _checkPoint = _cacheMap.length;
    }
    if (_cacheMap.length > _capacity) {
      // cache is overflow
      // cancel the timer to prevent unnecessary evict in timer.
      _timer.cancel();
      // evict right now
      _eviction.evict(_cacheMap, _now(),
          _policy.evictOrExpand(_cacheMap.length, _capacity));
    } else {
      _tryScheduling();
    }
  }

  Timer _timer;

  _tryScheduling() {
    if (_cacheMap.isEmpty || (_timer != null && _timer.isActive)) {
      return;
    }
    _timer = Timer.periodic(Duration(seconds: 30), (Timer timer) {
      if (_cacheMap.isEmpty) {
        timer.cancel();
        return;
      }
      int ret = _policy.evictOrExpand(_cacheMap.length, _capacity);
      if (ret < 0) {
        _eviction.evict(_cacheMap, _now(), ret.abs());
        //如果所有缓存都删除，也要等下一次启动timer时才停止这个timer
        //timer.cancel();
      }
    });
  }

  putAll(Map<String, dynamic> map) {
    putAllWithTTL(map, _ttl);
    _check();
  }

  putAllWithTTL(Map<String, dynamic> map, int ttl) {
    int invalid = _now() + ttl;
    for (String k in map.keys) {
      _putAtTime(k, map[k], invalid);
    }
    _check();
  }

  get(String key) {
    CacheEntry cacheEntry = _cacheMap[key];
    if (cacheEntry == null) {
      return null;
    } else if (cacheEntry.invalid <= _now()) {
      remove(key);
      return null;
    }
    return cacheEntry.cache;
  }

  remove(String key) {
    _cacheMap.remove(key);
  }

  double milliSeconds = 1000;

  int _now() {
    return (DateTime.now().millisecondsSinceEpoch / milliSeconds).round();
  }

  set ttl(t) => _ttl = t;
}
