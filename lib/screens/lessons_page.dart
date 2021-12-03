import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:skischool/data/auth.dart';
import 'package:skischool/data/result.dart';
import 'package:skischool/models/lesson.dart';
import 'package:skischool/screens/lesson_detail_page.dart';
import 'package:skischool/screens/lessons/lessons_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skischool/utils/logger.dart';

class LessonsPage extends StatefulWidget {
  LessonsPage({Key key}) : super(key: key);

  @override
  _LessonsPageState createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final PagingController<int, Lesson> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    Auth _auth = Provider.of<Auth>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(_auth, pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(Auth auth, int pageKey) async {
    try {
      final newItems = await auth.getLessons(offset: pageKey);
      final isLastPage = newItems.length < Auth.PAGE_SIZE;
      Log.d("isLastPage: $isLastPage, new items length: ${newItems.length}");
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    Auth _auth = Provider.of<Auth>(context, listen: true);
    ResultState _state = _auth.lessons.state;

    Widget content;

    if (_state == ResultState.loading) {
      content = new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      Widget child;
      if (_pagingController.itemList != null &&
          _pagingController.itemList.isEmpty) {
        child = new Center(child: new Text("Nemáš žiadne hodiny :("));
      } else {
        child = new PagedListView(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Lesson>(
              itemBuilder: (context, item, index) => buildLessonTile(
                  context,
                  index,
                  _pagingController.itemList,
                  (lesson) => {_navigateToLessonDetails(context, lesson)}),
            ));
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
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
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

  _logout(BuildContext context, Auth auth) {
    auth.logout();
  }
}
