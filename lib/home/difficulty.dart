import 'package:flutter/material.dart';

class Level {
  String name;
  int width;
  int height;
  int mineCount;

  Level({
    this.name,
    this.width,
    this.height,
    this.mineCount,
    this.highScore
  });

  int highScore;
}

class Difficulty extends StatelessWidget {
  // Level select menü
  bool isPressed;
  Level level;
  int number;
  Function function;

  Difficulty({
    this.isPressed = false,
    this.level,
    this.number,
    this.function
  });

  @override
  Widget build(BuildContext context) {
    var value = isPressed ? 0 : 192;
    return GestureDetector(
      onTap: () {
        function(number);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, value, value, value),
            border: Border(
              right: BorderSide(
                  width: 5,
                  color: isPressed
                      ? Colors.white
                      : Color.fromARGB(255, 128, 128, 128)),
              bottom: BorderSide(
                  width: 5,
                  color: isPressed
                      ? Colors.white
                      : Color.fromARGB(255, 128, 128, 128)),
              top: BorderSide(
                  width: 5,
                  color: isPressed
                      ? Color.fromARGB(255, 128, 128, 128)
                      : Colors.white),
              left: BorderSide(
                  width: 5,
                  color: isPressed
                      ? Color.fromARGB(255, 128, 128, 128)
                      : Colors.white),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  level.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Command',
                      color: isPressed ? Colors.green : Colors.black),
                )
              ],
            ),
            Text(
              '${level.width}x${level.height} ${level.mineCount} mines',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Command',
                  color: isPressed ? Colors.green : Colors.black),
            ),
            Text(
              'HighScore : ${(level.highScore ?? 'Nil').toString()} ',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Command',
                  color: isPressed ? Colors.green : Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
