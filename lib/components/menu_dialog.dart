import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const SPACING = 15.0;
const AVATAR_RADIUS = 40.0;
const BUTTON_WIDTH = 180.0;

class MenuDialog extends StatefulWidget {
  final void Function() restartGame;

  MenuDialog({@required this.restartGame});

  @override
  _MenuDialogState createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
  _launchRules() async {
    const url = 'https://en.wikipedia.org/wiki/Rules_of_chess';
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SPACING),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: menuContent(context),
    );
  }

  menuContent(context) {
    final menuActions = [
      {
        'label': 'New game',
        'icon': Icon(
          Icons.restore,
          color: Colors.white,
        ),
        'action': () {
          widget.restartGame();
          Navigator.of(context).pop();
        }
      },
      {
        'label': 'Rules',
        'icon': Icon(
          Icons.rule_rounded,
          color: Colors.white,
        ),
        'action': () {
          _launchRules();
          Navigator.of(context).pop();
        }
      },
    ];

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: SPACING,
            top: AVATAR_RADIUS + SPACING,
            right: SPACING,
            bottom: SPACING,
          ),
          margin: EdgeInsets.only(top: AVATAR_RADIUS),
          width: double.infinity,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(SPACING),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 10),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Menu',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: SPACING,
              ),
              ...menuActions.map(
                (element) => SizedBox(
                  width: BUTTON_WIDTH,
                  child: RaisedButton.icon(
                    icon: element["icon"],
                    onPressed: element["action"],
                    color: Colors.blueGrey[400],
                    label: Text(
                      element["label"],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: SPACING,
          right: SPACING,
          child: CircleAvatar(
            radius: AVATAR_RADIUS,
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(AVATAR_RADIUS)),
              child: Image.asset("assets/icons/icon.png"),
            ),
          ),
        ),
      ],
    );
  }
}
