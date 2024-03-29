import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthyapp/requests.dart';
import 'package:http/http.dart' as http;

class ChallengeRequest {
  final String to;
  final String from;
  final String type;
  final String goal;
  final String deadline;
  final String progress;

  ChallengeRequest(this.to, this.from, this.type, this.goal, this.deadline, this.progress);

  ChallengeRequest.fromJson(Map<String, dynamic> json)
      : to = json['received'] as String,
        from = json['sent'] as String,
        type = json['description'] as String,
        goal = json['goal'] as String,
        deadline = json['deadline'] as String,
        progress = json['progress'] as String;


  // Map<String, dynamic> toJson() =>
  //   {
  //     'name': name,
  //     'email': email,
  //   };
}

class CRequest extends StatelessWidget {

  CRequest({Key key, @required this.r, @required this.refreshCallback});

  final ChallengeRequest r;
  final VoidCallback refreshCallback;

  @override
  Widget build(BuildContext context) {

    String _title = "";
    switch (r.type) {
      case "1":
        _title = "Run " + r.goal.toString() + " miles.";
        break;
      default:
    }

    return Container(
      height: 100,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue,
              backgroundImage: NetworkImage("https://i.redd.it/3h830ttao8341.jpg"),
            ),
            SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text("Deadline: " + r.deadline, style: TextStyle(color: Colors.black45),),
                Text("Sent by " + r.from, style: TextStyle(color: Colors.black45),),

              ],
            ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 40,
                height: 40,
                child: MaterialButton(
                  onPressed: () async {
                    http.Response response = await acceptChallenge(r.from, r.to, r.type, r.deadline);
                    print(response.body);
                    this.refreshCallback();
                  },
                  shape: CircleBorder(),
                  child: Icon(Icons.check, color: Colors.white,),
                  color: Colors.blue,
                  padding: EdgeInsets.all(5),
                ),
              ),
              SizedBox(width: 10,),
              SizedBox(
                width: 40,
                height: 40,
                child: MaterialButton(
                  elevation: 1,
                  highlightElevation: 5,
                  onPressed: () async {
                    http.Response response = await rejectChallenge(r.from, r.to, r.type, r.deadline);
                    print(response.body);
                    this.refreshCallback();
                  },
                  shape: CircleBorder(),
                  child: Icon(Icons.clear, color: Colors.grey,),
                  color: Colors.white,
                  padding: EdgeInsets.all(5),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class FriendRequest extends StatelessWidget {

  FriendRequest({Key key, @required this.username, @required this.myUsername, @required this.refreshCallback, @required this.myOwn});

  final String username;
  final String myUsername;
  final VoidCallback refreshCallback;
  final bool myOwn;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue,
              backgroundImage: NetworkImage("https://i.redd.it/3h830ttao8341.jpg"),
            ),
            SizedBox(width: 10,),
            Text(this.username, style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (!myOwn)
              SizedBox(
                width: 40,
                height: 40,
                child: MaterialButton(
                  onPressed: () async {
                    http.Response response = await acceptRequest(this.username, this.myUsername);
                    this.refreshCallback();
                  },
                  shape: CircleBorder(),
                  child: Icon(Icons.check, color: Colors.white,),
                  color: Colors.blue,
                  padding: EdgeInsets.all(5),
                ),
              ),
              if (myOwn)
              Text(
                "PENDING",
                style: TextStyle(
                  color: Colors.black45
                ),
              ),
              SizedBox(width: 10,),
              SizedBox(
                width: 40,
                height: 40,
                child: MaterialButton(
                  elevation: 1,
                  highlightElevation: 5,
                  onPressed: () async {
                    if (!myOwn) {
                      http.Response response = await rejectRequest(this.username, this.myUsername);
                    } else {
                      http.Response response = await rejectRequest(this.myUsername, this.username);
                    }
                    this.refreshCallback();
                  },
                  shape: CircleBorder(),
                  child: Icon(Icons.clear, color: Colors.grey,),
                  color: Colors.white,
                  padding: EdgeInsets.all(5),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class FriendTile extends StatelessWidget {

  FriendTile({Key key, @required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue,
              backgroundImage: NetworkImage("https://yt3.ggpht.com/EdjnobpzppDl5pSVU2s2AUIiFS0qBfT8Jdodw-FHMhugJK5zmzWDLkpqDVtpnaLSP66M5F8nqINImLKGtQ=s900-nd-c-c0xffffffff-rj-k-no"),
            ),
            SizedBox(width: 10,),
            Text(this.username, style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          // FlatButton(
          //   onPressed: () {},
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
          //   child: Text(
          //     "CHALLENGE",
          //     style: TextStyle(
          //       color: Colors.blue
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();

  SocialPage({Key key, @required this.username});

  final String username;
}

class _SocialPageState extends State<SocialPage> with AutomaticKeepAliveClientMixin<SocialPage> {

  List<String> _friends = [];
  List<String> _requestsToMe = [];
  List<String> _requestsFromMe = [];
  List<ChallengeRequest> _pending = [];

  bool _first = true;

  @override
  bool get wantKeepAlive => true;

  Future<void> refresh() async {
    http.Response response1 = await getFriendRequestsReceived(widget.username);
    http.Response response2 = await getFriendRequestsSent(widget.username);
    http.Response response3 = await getFriends(widget.username);
    http.Response response4 = await getPendingChallenges(widget.username);

    print(response1.body);
    print(response2.body);
    print(response3.body);
    print(response4.body.runtimeType);
    
    if (response1.body == '518' || response1.body == '517') {
      setState(() {
        _requestsToMe = [];
      });
    } else {
      setState(() {
        _requestsToMe = response1.body.split(" ");
      });
    }

    if (response2.body == '519' || response2.body == '520') {
      setState(() {
        _requestsFromMe = [];
      });
    } else {
      setState(() {
        _requestsFromMe = response2.body.split(" ");
      });
    }

    if (response3.body == '521' || response3.body == '522') {
      setState(() {
        _friends = [];
      });
    } else {
      setState(() {
        _friends = response3.body.split(" ");
      });
    }

    if (response4.body == '523' || response4.body == '524') {
      setState(() {
        _pending = [];
      });
    } else {
      setState(() {
        _pending = [];
        var t = jsonDecode(response4.body);
        print(t.runtimeType);

        if (t != null) {
          t.forEach((e) {
            var tt = e.replaceAll(RegExp("'"), '"');
            tt = tt.replaceAll(RegExp(":"), ':"');
            tt = tt.replaceAll(RegExp(","), '",');
            tt = tt.replaceAll(RegExp("}"), '"}');
            var ttt = jsonDecode(tt);
            var cc = ChallengeRequest.fromJson(ttt);
            print(cc.deadline);
            _pending.add(cc);
          });
        }
      });
    }

    //var pc = ChallengeRequest.fromJson(t);
    //print(pc.deadline);

    return;
  }

  @override
  void initState() {
    super.initState();

    refresh().then((value) => _first = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          return showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              TextEditingController _tc = TextEditingController();
              return AlertDialog(
                title: Text("Enter a username"),
                content: TextField(
                  controller: _tc,
                  decoration: InputDecoration(
                    labelText: "Username",
                    contentPadding: EdgeInsets.fromLTRB(30,20,30,20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("SEND REQUEST"),
                    onPressed: () async {
                      http.Response response = await addFriend(widget.username, _tc.text);
                      print(response.body);
                      Navigator.of(context).pop();
                      refresh();
                    },
                  )
                ],
              );
            }
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, size: 25,),
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
        child: RefreshIndicator(
          strokeWidth: 2.5,
          onRefresh: () {  return refresh(); },
          child: CustomScrollView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[

              SliverToBoxAdapter(
                child: SizedBox(height: 30,),
              ),

              if (_pending.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Text(
                          "Your pending challenges",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              
              if (_pending.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < _pending.length) {
                        return Column(
                          children: <Widget>[
                            CRequest(
                              r: _pending[index],
                              refreshCallback: refresh,
                            ),
                            if (index < _pending.length - 1)
                              Divider(indent: 40, endIndent: 40, height: 1, thickness: 1),
                          ],
                        );
                      }
                    }
                  ),
                ),
              
              if (_requestsToMe.isNotEmpty || _requestsFromMe.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Text(
                          "Your friend requests",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),

              if (_requestsToMe.isNotEmpty || _requestsFromMe.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < _requestsToMe.length) {
                        return Column(
                          children: <Widget>[
                            FriendRequest(
                              username: _requestsToMe[index],
                              myUsername: widget.username,
                              refreshCallback: refresh,
                              myOwn: false
                            ),
                            if (index < _requestsToMe.length + _requestsFromMe.length - 1)
                              Divider(indent: 40, endIndent: 40, height: 1, thickness: 1),
                          ],
                        );
                      } else if (index < _requestsToMe.length + _requestsFromMe.length) {
                        return Column(
                          children: <Widget>[
                            FriendRequest(
                              username: _requestsFromMe[index - _requestsToMe.length],
                              myUsername: widget.username,
                              refreshCallback: refresh,
                              myOwn: true
                            ),
                            if (index < _requestsToMe.length + _requestsFromMe.length - 1)
                              Divider(indent: 40, endIndent: 40, height: 1, thickness: 1),
                          ],
                        );
                      }
                    }
                  ),
                ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Text(
                        "Your friends",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              if (_friends.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < _friends.length)
                        return Column(
                          children: <Widget>[
                            FriendTile(username: _friends[index],),
                            if (index < _friends.length - 1)
                              Divider(indent: 40, endIndent: 40, height: 1, thickness: 1,),
                          ],
                        );
                      return null;
                    }
                  ),
                ),
              if (_friends.isEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "You don't have any friends.",
                        style: TextStyle(
                          color: Colors.black45,
                        )
                      ),
                    ),
                  ),
                )

            ],
          ),
        ),
      ),
    );
  }
}