import 'package:flutter_memory_cache/src/policy/policy.dart';

/// 完全根据
class CapacitySensitivePolicy extends Policy {
  double evictLevel;
  int _tolerance;

  ///@param warningLevel
  CapacitySensitivePolicy({double evictLevel = 0.9, int tolerance = 3}) {
    if (evictLevel > 1 || evictLevel < 0) {
      throw Exception('0 < factor < 1');
    }
    this.evictLevel = evictLevel;
    this._tolerance = tolerance;
  }

  int _tolerateCountDown = 0;

  @override
  int evictOrExpand(int cacheSize, int capacity) {
    ///大于最大容量，立刻清理
    if (cacheSize > capacity) {
      ///要返回负数才是清理，正数是扩容
      return (capacity * evictLevel).round() - cacheSize;
    }
    if (cacheSize > capacity * evictLevel) {
      _tolerateCountDown--;

      ///超过次数限制
      if (_tolerateCountDown <= 0) {
        resetCountDown();
        return (capacity * evictLevel).round() - cacheSize;
      }
    } else {
      ///正常范围，清除溢出警告计数
      resetCountDown();
    }
    return 0;
  }

  resetCountDown() {
    _tolerateCountDown = _tolerance;
  }
}
