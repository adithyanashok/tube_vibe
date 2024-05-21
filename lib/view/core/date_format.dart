import 'package:timeago/timeago.dart' as timeago;

String formatDateTimeAgo(String dateTimeString) {
  // Parse the DateTime string
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Format the DateTime to "ago" format
  return timeago.format(dateTime);
}
