

class CacheEntry {
  int _invalid;
  String _key;
  dynamic _cache;

  CacheEntry(this._key,this._cache,this._invalid);

  String get key => _key;
  dynamic get cache => _cache;
  int get invalid => _invalid;
}