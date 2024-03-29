import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthyapp/create_task.dart';
import 'package:healthyapp/requests.dart';
import 'package:http/http.dart' as http;

class Task {
  final String to;
  final String from;
  final String type;
  final String goal;
  final String deadline;
  final String progress;

  Task(this.to, this.from, this.type, this.goal, this.deadline, this.progress);

  Task.fromJson(Map<String, dynamic> json)
      : to = json['received'] as String,
        from = json['sent'] as String,
        type = json['description'] as String,
        goal = json['goal'] as String,
        deadline = json['deadline'] as String,
        progress = json['progress'] as String;
}

enum TaskType {
  running,
  ropejumping,
}

class TaskCard extends StatefulWidget {
  @override
  _TaskCardState createState() => _TaskCardState();

  TaskCard({Key key, @required this.type, @required this.goal, @required this.progress, @required this.deadline});

  final TaskType type;
  final int goal;
  final double progress;
  final String deadline;
}

class _TaskCardState extends State<TaskCard> {

  String _title;
  String _iconUrl;
  Size _progressSize;
  double _iconRadius = 40.0;

  double _barSize = 0;
  double _progressPadding = 0;

  @override
  void initState() {
    super.initState();

    switch (widget.type) {
      case TaskType.running:
        _title = "Run " + widget.goal.toString() + " miles.";
        _iconUrl = "https://files.catbox.moe/mukn0p.png";
        break;
      case TaskType.ropejumping:
        _title = "Jump the rope " + widget.goal.toString() + " hours.";
        _iconUrl = "https://files.catbox.moe/soltzy.png";
        break;
      default:
        _title = "DEFAULT";
        _iconUrl = "";
    }

  }

  @override
  Widget build(BuildContext context) {
    
    _progressSize = (TextPainter(
        text: TextSpan(text: widget.progress.toString(), style: TextStyle(fontWeight: FontWeight.w600)),
        maxLines: 1,
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        textDirection: TextDirection.ltr)
      ..layout())
    .size;

    _barSize = MediaQuery.of(context).size.width - 40 - _iconRadius * 2 - 20;
    _progressPadding = widget.progress * (MediaQuery.of(context).size.width - 40 - _iconRadius * 2 - 20) / widget.goal;
    if (_progressPadding + _progressSize.width > _barSize)
      _progressPadding = _barSize - _progressSize.width;

    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.blue.withOpacity(0.3),
        highlightColor: Colors.blue.withOpacity(0.1),
        onTap: () {},
        child: Container(
          height: 190,
          padding: EdgeInsets.fromLTRB(20,25,20,25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(_iconUrl),
                    radius: _iconRadius,
                  ),
                  SizedBox(width: 20),
                  Container(
                    height: _iconRadius * 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Ends on " + widget.deadline,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black45
                          ),
                        ),
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget>[
                            Container(
                              height: 10,
                              width: _barSize,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.grey[300]),
                            ),
                            Container(
                              height: 10,
                              width: widget.progress * _barSize / widget.goal,
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.blue[300]),
                            ),
                          ],
                        ),
                        Container(
                          height: 20,
                          width: _barSize,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                left: _progressPadding,
                                child: Text(widget.progress.toString(), style: TextStyle(fontWeight: FontWeight.w600)),
                              )
                              //Text("0", style: TextStyle(fontWeight: FontWeight.w600),),
                              //Align(alignment: Alignment.centerRight, child: Text(widget.amount.toString(), style: TextStyle(fontWeight: FontWeight.w600),),)
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),

              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.people),
                    SizedBox(width: 15,),
                    CircleAvatar(backgroundImage: NetworkImage("https://i.redd.it/3h830ttao8341.jpg")),
                    SizedBox(width: 7,),
                    CircleAvatar(backgroundImage: NetworkImage("https://i.redd.it/kruwv92y42911.jpg")),
                    SizedBox(width: 7,),
                    CircleAvatar(backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5I-LyW9aEufGed1suUqzi6eoGmm0KlsUu1w&usqp=CAU")),
                    SizedBox(width: 7,),
                    CircleAvatar(backgroundImage: NetworkImage("https://i.redd.it/zsit5ydyfxr21.jpg")),
                    SizedBox(width: 7,),
                    CircleAvatar(backgroundImage: NetworkImage("https://i.pinimg.com/564x/0c/88/c5/0c88c5b8f75c901e5d04141301f7741a.jpg")),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();

  ProgressPage({Key key, @required this.username});

  final String username;
}

class _ProgressPageState extends State<ProgressPage> with AutomaticKeepAliveClientMixin<ProgressPage> {

  ScrollController _scrollController;
  ValueNotifier<double> _scrollNotifier;

  double _expandedHeight = 250;
  double _parallax = 0;

  bool _first = true;

  List<Task> _tasks = [];

  Future<void> _refresh() async {
    http.Response response = await getChallenges(widget.username);
    print(response.body);

    if (response.body == '514' || response.body == '515') {
      setState(() {
        _tasks = [];
      });
    } else {
      setState(() {
        _tasks = [];
        var t = jsonDecode(response.body);
        print(t.runtimeType);

        if (t != null) {
          t.forEach((e) {
            var tt = e.replaceAll(RegExp("'"), '"');
            tt = tt.replaceAll(RegExp(":"), ':"');
            tt = tt.replaceAll(RegExp(","), '",');
            tt = tt.replaceAll(RegExp("}"), '"}');
            var ttt = jsonDecode(tt);
            var cc = Task.fromJson(ttt);
            print(cc.deadline);
            _tasks.add(cc);
          });
        }
      });
    }

    print(_tasks);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollNotifier = ValueNotifier<double>(0.0);
    _scrollController.addListener(() {
      _scrollNotifier.value = _scrollController.position.pixels;
      setState(() {
        if (_scrollController.position.pixels < 0) {
          _expandedHeight = 250 - _scrollController.position.pixels;
          _parallax = 0;
        } else {
          _expandedHeight = 250;
          _parallax = -(_scrollController.position.pixels * 0.5);
        }
      });
    });

    _refresh().then((value) => _first = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "lol",
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, size: 25,),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTaskPage(username: widget.username))
          );
        },
      ),
      body: _first ? 
        Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        )
       : Container(
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: _parallax,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Image.network('https://i.pinimg.com/originals/a1/03/3b/a1033bf9c3cc07acb5389cd1e44609a6.jpg', fit: BoxFit.cover, color: Colors.black.withOpacity(0.5), colorBlendMode: BlendMode.srcATop,),
                height: _expandedHeight,
              ),
            ),
            RefreshIndicator(
              strokeWidth: 2.5,
              onRefresh: () {  return _refresh(); },
              child: CustomScrollView(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: _scrollController,
                slivers: <Widget>[

                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.transparent,
                      height: 250,
                      padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ' Your progress',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Expanded(
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                              elevation: 10,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(25,10,25,10),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage('https://ourfunnylittlesite.com/wp-content/uploads/2018/07/1-4.jpg'),
                                      radius: 40,
                                    ),
                                    SizedBox(width: 20,),
                                    Text(
                                      widget.username,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {

                      if (index < _tasks.length) {
                        Task r = _tasks[index];
                        TaskType t;
                        switch (r.type) {
                          case "1":
                            t = TaskType.running;
                            break;
                          default:
                        }
                        return Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              TaskCard(
                                type: t,
                                goal: int.parse(r.goal),
                                progress: double.parse(r.progress),
                                deadline: r.deadline,
                              ),
                              if (index < _tasks.length - 1)
                                Divider(indent: 40, endIndent: 40, height: 1, thickness: 1,),
                            ],
                          ),
                        );
                      }
                      
                    }),
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}