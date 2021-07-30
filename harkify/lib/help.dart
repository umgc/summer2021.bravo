import 'package:flutter/material.dart';
import "package:youtube_player_flutter/youtube_player_flutter.dart";
import 'basemenudrawer.dart';


final helpScaffoldKey = GlobalKey<ScaffoldState>();

class HelpPage extends StatefulWidget {
  final String title = "Help Page";
  final url = YoutubePlayer.convertUrlToId(
      "https://www.youtube.com/watch?v=S5aK3TIOnIw&ab_channel=Flutter");
  HelpPage({title, url});

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
              "https://www.youtube.com/watch?v=S5aK3TIOnIw&ab_channel=Flutter")
          .toString());

  void runYoutubePlayer() {
    _controller = YoutubePlayerController(
        initialVideoId: widget.url.toString(),
        flags: YoutubePlayerFlags(
          enableCaption: false,
          isLive: false,
          autoPlay: false,
        ));
  }

  @override
  void initState() {
    runYoutubePlayer();
    super.initState();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
        ),
        builder: (context, player) {
          return Scaffold(
            key: helpScaffoldKey,
            endDrawer: BaseMenuDrawer(),
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Container(
              padding: EdgeInsets.only(
                left: 16,
                top: 25,
                right: 16,
              ),
              child: ListView(
                children: [
                  Text(
                    "FAQs & Support",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.video_camera_back_sharp,
                        color: Colors.deepPurpleAccent,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Walk-through Video",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      player,
                      SizedBox(
                        height: 40.0,
                      ),
                      // Text(
                      //   'Harkify video Player',
                      // ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildAccountOptionRow(context, "Devices supported?"),
                  buildAccountOptionRow(context, "Account needed?"),
                  buildAccountOptionRow(context, "Recording languages?"),
                  buildAccountOptionRow(
                      context, "Saving & editing notes issue?"),
                  buildAccountOptionRow(context, "Privacy policy?"),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.contact_support_sharp,
                        color: Colors.deepPurpleAccent,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Contact Support",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // This trailing comma makes auto-formatting nicer for build methods.
                ],
              ),
            ),
          );
        });
  }
}

GestureDetector buildAccountOptionRow(BuildContext context, String title) {
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Option A"),
                  Text("Option B"),
                  Text("Option C"),
                ],
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close")),
              ],
            );
          });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}
