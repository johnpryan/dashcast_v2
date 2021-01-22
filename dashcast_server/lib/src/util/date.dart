import 'package:intl/intl.dart';

final _fmtA = DateFormat('EE, dd MMM yyyy HH:mm:ss ZZZZZ');
final _fmtB = DateFormat('yyyy-mm-ddTHH:mm:ssZZZZZ');

DateTime parseDate(String s) {
  var d = _tryParse(s, _fmtA);
  if (d != null) return d;
  d = _tryParse(s, _fmtB);
  if (d != null) return d;
  return null;
}

DateTime _tryParse(String s, DateFormat format) {
  try {
    return format.parse(s, true);
  } on FormatException {
    return null;
  }
}