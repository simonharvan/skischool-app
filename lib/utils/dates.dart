String parseTimeFromStringDate(String date) {
  int minute = DateTime.parse(date).minute;
  String min = minute.toString();
  if (minute < 10) {
    min = '0' + min;
  }

  return '${DateTime.parse(date).hour}:$min';
}

String parseDateFromStringDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  return '${dateTime.day}.${dateTime.month} (${parseWeekdayFromInt(dateTime)})';
}

String parseWeekdayFromInt(DateTime date) {
  switch (date.weekday) {
    case 1:
      return "Pondelok";
    case 2:
      return "Utorok";
    case 3:
      return "Streda";
    case 4:
      return "Štvrtok";
    case 5:
      return "Piatok";
    case 6:
      return "Sobota";
    case 7:
      return "Nedeľa";
    default:
      return "";
  }
}

bool isDateBefore(String dateString, String beforeDateString) {
  DateTime date = DateTime.parse(dateString.substring(0, 10));

  DateTime beforeDate = DateTime.parse(beforeDateString.substring(0, 10));
  return beforeDate.isBefore(date);
}

bool isToday(String dateString) {
  DateTime date = DateTime.parse(dateString.substring(0, 10));

  DateTime now = DateTime.now();
  return now.day == date.day &&
      now.month == date.month &&
      now.year == date.year;
}
