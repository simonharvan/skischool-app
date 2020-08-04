import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skishool/data/auth.dart';
import 'package:skishool/models/lesson.dart';
import 'package:skishool/utils/dates.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LessonsPage extends StatelessWidget {
  LessonsPage({Key key}) : super(key: key);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Widget _buildLessonsListTile(
      BuildContext context, int index, List<Lesson> _lessons) {
    var lesson = _lessons[index];
    Auth _auth = Provider.of<Auth>(context, listen: true);

    return new ListTile(
      onTap: () => _navigateToLessonDetails(lesson),
      leading: Icon(
        lesson.type == 'ski' ? Icons.accessibility : Icons.accessible_forward,
        color: lesson.type == 'ski' ? Colors.blue : Colors.green,
        size: 32.0,
        semanticLabel: lesson.type,
      ),
      title: new Text(lesson.name),
      subtitle: Row(
        children: <Widget>[
          new Text(parseTimeFromDate(lesson.from)),
          new Text(' - '),
          new Text(parseTimeFromDate(lesson.to))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Auth _auth = Provider.of<Auth>(context, listen: true);
    List<Lesson> _lessons = _auth.lessons;

    Widget content;
    if (_lessons.isEmpty) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      content = SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
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
        child: new ListView.builder(
          itemCount: _lessons.length,
          itemBuilder: (BuildContext context, index) {
            return _buildLessonsListTile(context, index, _lessons);
          },
        ),
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Hodiny'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (String value) {
              _logout(context, _auth);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Odhlásiť sa'),
                )
              ];
            },
          )
        ],
      ),
      body: content,
    );
  }

  void _navigateToLessonDetails(Lesson lesson) {
//    Navigator.of(context).push(
//      new MaterialPageRoute(
//        builder: (c) {
//          return new FriendDetailsPage(friend, avatarTag: avatarTag);
//        },
//      ),
//    );
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
