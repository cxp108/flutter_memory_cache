


import 'package:flutter_memory_cache/src/policy/capacity_sentive_policy.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('CapacitSentivePolicy test', () {
    CapacitySensitivePolicy test = CapacitySensitivePolicy();
    int ret = test.evictOrExpand(900, 1000);
    expect(ret, 0);
    ret = test.evictOrExpand(901, 1000);
    expect(ret,0);
    ret = test.evictOrExpand(901, 1000);
    expect(ret,0);
    ret = test.evictOrExpand(901, 1000);
    expect(ret, -1);
    ret = test.evictOrExpand(901,1000);
    expect(ret, 0);
  });

  test('CapacitSentivePolicy test', () {
    CapacitySensitivePolicy test = CapacitySensitivePolicy(evictLevel: 0.7,tolerance: 1);
    int ret = test.evictOrExpand(900, 1000);
    expect(ret, -200);

  });
}