import 'package:flutter/material.dart';

class WinnerBanner extends StatelessWidget {
  final bool won;

  WinnerBanner({this.won = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                    top: BorderSide(width: 10, color: Colors.white),
                    left: BorderSide(width: 10, color: Colors.white),
                    right: BorderSide(
                        width: 10, color: Color.fromARGB(255, 128, 128, 128)),
                    bottom: BorderSide(
                        width: 10, color: Color.fromARGB(255, 128, 128, 128)),
                  )),
              width: double.infinity,
              child: Center(
                child: Text(
                  won ? 'Glückwunsch!' : 'Game Over',
                  style: TextStyle(
                      fontFamily: 'Command', color: Colors.green, fontSize: 40),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
