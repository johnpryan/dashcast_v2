import 'package:dashcast_server/src/util/date.dart';
import 'package:test/test.dart';

void main() {
  group('datetime parsing', () {
    test('RSS feed XML date', () {
      var s = 'Fri, 22 Jan 2021 05:30:12 -0000';
      var d = parseDate(s);
      expect(d, isNotNull);
      expect(d.year, 2021);
      expect(d.month, 1);
      expect(d.day, 22);
      expect(d.hour, 5);
      expect(d.minute, 30);
      expect(d.second, 12);
      expect(d.timeZoneOffset, Duration(hours: 0));
    });
    test('RSS feed XML date', () {
      var s = '2021-01-12T21:21:20+00:00';
      var d = parseDate(s);
      expect(d, isNotNull);
      expect(d.year, 2021);
      expect(d.month, 1);
      expect(d.day, 12);
      expect(d.hour, 21);
      expect(d.minute, 21);
      expect(d.second, 20);
      expect(d.timeZoneOffset, Duration(hours: 0));
    });
  });
}