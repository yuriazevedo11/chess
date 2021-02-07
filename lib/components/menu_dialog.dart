import 'package:flutter/material.dart';

const SPACING = 15.0;
const AVATAR_RADIUS = 40.0;
const BUTTON_WIDTH = 180.0;

class MenuDialog extends StatefulWidget {
  @override
  _MenuDialogState createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
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
              SizedBox(
                width: BUTTON_WIDTH,
                child: RaisedButton.icon(
                  icon: Icon(
                    Icons.rule_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.blueGrey[400],
                  label: Text(
                    'Rules',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: BUTTON_WIDTH,
                child: RaisedButton.icon(
                  icon: Icon(
                    Icons.restore,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.blueGrey[400],
                  label: Text(
                    'New game',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: BUTTON_WIDTH,
                child: RaisedButton.icon(
                  icon: Icon(
                    Icons.undo_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.blueGrey[400],
                  label: Text(
                    'Undo',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
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
