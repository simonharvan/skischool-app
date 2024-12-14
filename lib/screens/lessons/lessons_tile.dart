import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skischool/models/lesson.dart';
import 'package:skischool/utils/dates.dart';

Widget buildLessonTile(
    BuildContext context, int index, List<Lesson> _lessons, Function listener) {

  if (index < 0 && index >= _lessons.length) {
    return const SizedBox.shrink();
  }

  var lesson = _lessons[index];

  if (index == 0 || isDateBefore(_lessons[index - 1].from, lesson.from)) {
    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Divider(
            color: index != 0 ? Colors.grey : Colors.white,
            height: 10,
            thickness: 1,
            indent: 32,
            endIndent: 32,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: new Text(parseDateFromStringDate(lesson.from)),
          ),
          _listTile(listener, lesson)
        ]);
  } else {
    return _listTile(listener, lesson);
  }
}

Widget _listTile(Function listener, Lesson lesson) {
  return new ListTile(
    onTap: () => listener(lesson),
    tileColor: isToday(lesson.from) ? Colors.lightBlue.shade100 : Colors.white,
    leading: Icon(
      lesson.type == 'ski' ? Icons.accessibility_new : Icons.wheelchair_pickup,
      color: lesson.type == 'ski' ? Colors.blue : Colors.green,
      size: 32.0,
      semanticLabel: lesson.type,
    ),
    title: new Text(lesson.name),
    subtitle: Row(
      children: <Widget>[
        new Text(parseTimeFromStringDate(lesson.from)),
        new Text(' - '),
        new Text(parseTimeFromStringDate(lesson.to))
      ],
    ),
  );
}
