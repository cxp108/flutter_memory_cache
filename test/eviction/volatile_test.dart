
import 'package:flutter_memory_cache/src/eviction/volatile.dart';
import 'package:flutter_memory_cache/src/cache/cache_entry.dart';
import 'package:flutter_test/flutter_test.dart';


@TestOn('android')
void main() {
  Map<String,CacheEntry> cache;
  String ka = 'a',kb='b',kc='c',kd='kd',va='va',vb='vb',vc='vc',vd='vd';

  int startTime;
  VolatileEviction testSubject;
  setUp((){
    cache = Map();
    startTime= (DateTime.now().millisecondsSinceEpoch/1000).round();
    CacheEntry a = CacheEntry(ka,va,startTime+10);
    CacheEntry b = CacheEntry(kb,vb,startTime-10);
    CacheEntry c = CacheEntry(kc,vc,startTime-10);
    CacheEntry d = CacheEntry(kd,vd,startTime+10);
    cache[ka] = a;
    cache[kb] = b;
    cache[kc] = c;
    cache[kd] = d;
    testSubject = VolatileEviction();
  });

  test(' test', () {

    testSubject.evict(cache, startTime, 2);
    expect(cache[ka].cache, va);
  });

  test('test2 ',(){
    testSubject.evict(cache, startTime, 3);
    expect(cache.length, 1);
  });

  test('test3',(){
    testSubject.evict(cache, startTime, 4);
    expect(cache.length, 0);
  });

}