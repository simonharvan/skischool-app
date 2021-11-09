import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skischool/data/auth.dart';
import 'package:skischool/data/result.dart';
import 'package:skischool/models/lesson.dart';
import 'package:skischool/screens/lesson_detail_page.dart';
import 'package:skischool/screens/lessons/lessons_tile.dart';
import 'package:skischool/utils/dates.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LessonsPage extends StatelessWidget {
  LessonsPage({Key key}) : super(key: key);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    Auth _auth = Provider.of<Auth>(context, listen: true);
    List<Lesson> _lessons = _auth.lessons.data;
    ResultState _state = _auth.lessons.state;

    Widget content;

    if (_state == ResultState.loading) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      Widget child;
      if (_lessons.isEmpty) {
        child = new Center(child: new Text("Nemáš žiadne hodiny :("));
      } else {
        child = new ListView.builder(
          itemCount: _lessons.length,
          itemBuilder: (BuildContext context, index) {
            return buildLessonTile(context, index, _lessons,
                () => _navigateToLessonDetails(context, _lessons[index]));
          },
        );
      }
      content = SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("Potiahni");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Načítanie zlyhalo skús ešte raz");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("Pusti");
            } else {
              body = Text("Nemáme viac hodín");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: () {
          _onRefresh(_auth);
        },
        child: child,
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Hodiny'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      _auth.user.name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      _auth.user.email,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      _auth.user.phone,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Odhlásiť'),
              onTap: () => _logout(context, _auth),
            ),
          ],
        ),
      ),
      body: content,
    );
  }

  void _navigateToLessonDetails(BuildContext context, Lesson lesson) {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (c) {
          return new LessonDetailPage(lesson: lesson);
        },
      ),
    );
  }

  void _onRefresh(Auth auth) async {
    // monitor network fetch
    await auth.getLessons();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  _logout(BuildContext context, Auth auth) {
    auth.logout();
  }
}
