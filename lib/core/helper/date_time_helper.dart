import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as time_ago;
class DateTimeHelper {

  static String getDateFormat (DateTime dateTime){
    Duration difference = DateTime.now().difference(dateTime);
    if (difference <= const Duration(hours: 24) ){
      return DateFormat.jm().format(dateTime);
    } else if (difference <= const Duration(days: 7)){
      return '${DateFormat.E().format(dateTime)} ${DateFormat.jm().format(dateTime)}';
    } else if (difference >= const Duration(days: 365)){
      return '${DateFormat.yMd().format(dateTime)} ${DateFormat.jm().format(dateTime)}';
    }else {
      return '${DateFormat.MMMd().format(dateTime)} ${DateFormat.jm().format(dateTime)}';
    }
  }

  static String getDateDifference (DateTime dateTime){
    return time_ago.format(DateTime.now().subtract(DateTime.now().difference(dateTime)));
  }
}