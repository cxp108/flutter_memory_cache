

abstract class Policy {

  /// @return 大于0是希望扩容，小于0是
  int evictOrExpand(int cacheSize, int capacity);
}
