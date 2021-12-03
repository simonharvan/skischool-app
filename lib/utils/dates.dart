

String parseTimeFromStringDate(String date)  {
  int minute = DateTime.parse(date).minute;
  String min = minute.toString();
  if (minute < 10) {
    min = '0' + min;
  }

  return '${DateTime.parse(date).hour}:$min';
}

String parseDateFromStringDate(String date)  {
  return '${DateTime.parse(date).day}.${DateTime.parse(date).month}';
}

bool isDateBefore(String dateString, String beforeDateString)  {
  DateTime date = DateTime.parse(dateString.substring(0, 10));
  
  DateTime beforeDate = DateTime.parse(beforeDateString.substring(0, 10));
  return beforeDate.isBefore(date);
}

