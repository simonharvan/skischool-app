import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skischool/data/auth.dart';
import 'package:table_calendar/table_calendar.dart';

class FilterPage extends StatefulWidget {
  FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    Auth _auth = Provider.of<Auth>(context, listen: true);
    DateTime? dateTime = _auth.getFilterDate();
    if (dateTime != null) {
      _focusedDay = dateTime;
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Filter'),
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
                    TableCalendar(
                      firstDay: DateTime.utc(2021, 10, 16),
                      lastDay: DateTime.utc(2050, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isSameDay(_selectedDay, selectedDay)) {
                          // Call `setState()` when updating the selected day
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        }
                      },
                    )
                  ]),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                      child: Text('Vyčisti'),
                      onPressed: () {
                        _auth.setFilterDate(null);
                        Navigator.pop(context, true);
                      }),
                  FlatButton(
                      child: Text('Dnes'),
                      onPressed: () {
                        _auth.setFilterDate(DateTime.now());
                        Navigator.pop(context, true);
                      }),
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        _auth.setFilterDate(_selectedDay);
                        Navigator.pop(context, true);
                      }),
                ],
              )
            ],
          )),
    );
  }
}
