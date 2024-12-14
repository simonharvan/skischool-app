import 'package:flutter/material.dart';
import 'package:skischool/models/lesson.dart';
import 'package:skischool/utils/dates.dart';
import 'package:url_launcher/url_launcher.dart';

class LessonDetailPage extends StatelessWidget {
  final Lesson lesson;

  LessonDetailPage({required this.lesson, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = 16;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(lesson.name + ' (${lesson.type})'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: new Row(
                      children: [
                        new Text('Dátum: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize)),
                        new Text(parseDateFromStringDate(lesson.from),
                            style: TextStyle(fontSize: fontSize))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: new Row(
                      children: [
                        new Text('Čas: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize)),
                        new Text(parseTimeFromStringDate(lesson.from),
                            style: TextStyle(fontSize: fontSize)),
                        new Text(' - ', style: TextStyle(fontSize: fontSize)),
                        new Text(parseTimeFromStringDate(lesson.to),
                            style: TextStyle(fontSize: fontSize))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: new Row(
                            children: [
                              new Text('Meno klienta: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize)),
                              new Text(lesson.client.name ?? "",
                                  style: TextStyle(fontSize: fontSize))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: new Row(
                            children: [
                              new Text('Email: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize)),
                              new Text(lesson.client.email ?? "",
                                  style: TextStyle(fontSize: fontSize))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: new Row(
                            children: [
                              new Text('Telefón: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize)),
                              new Text(lesson.client.phone ?? "",
                                  style: TextStyle(fontSize: fontSize))
                            ],
                          ),
                        ),
                        lesson.client.phone_2 != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: new Row(
                                  children: [
                                    new Text('Telefón 2: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSize)),
                                    new Text(lesson.client.phone ?? "",
                                        style: TextStyle(fontSize: fontSize))
                                  ],
                                ),
                              )
                            : Container(),
                        lesson.note != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: new Row(
                                  children: [
                                    new Text('Poznámka: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: fontSize)),
                                    new Text(lesson.note ?? "",
                                        style: TextStyle(fontSize: fontSize))
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: new Text(
                              lesson.status == STATUS_PAID
                                  ? 'Zaplatené'
                                  : 'Nezaplatené',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize,
                                  color: lesson.status == STATUS_PAID
                                      ? Colors.green
                                      : Colors.red)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () => launch("tel:${lesson.client.phone}"),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: new Text("Volať"),
                      )),
                  new FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () => launch("sms:${lesson.client.phone}"),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: new Text("SMS"),
                      )),
                ],
              )
            ],
          )),
    );
  }
}
