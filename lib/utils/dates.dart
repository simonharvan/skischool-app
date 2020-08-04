

String parseTimeFromDate(String date)  {
  int minute = DateTime.parse(date).minute;
  String min = minute.toString();
  if (minute < 10) {
    min = '0' + min;
  }

  return '${DateTime.parse(date).hour}:${min}';
}

