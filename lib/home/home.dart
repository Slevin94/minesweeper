import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minesweeper/game/game_page.dart';
import 'package:minesweeper/home/difficulty.dart';
import 'package:minesweeper/home/readme.dart';
import 'package:minesweeper/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPressed = 0;
  int opacity = 0;
  Timer _timer;
  int seconds = 0; // verstrichende Sekunden speichern
  var levels = [
    //Definieren der Level
    Level(name: 'Easy', height: 10, width: 10, mineCount: 10),
    Level(name: 'Medium', height: 20, width: 30, mineCount: 50),
    Level(name: 'Hard', height: 30, width: 40, mineCount: 100),
  ];

  var selected;

  // Wenn der Schwierigskeitsgrad ausgewählt wurde, wird der Index i übergeben
  void onPressed(int i) {
    // beende falls bereits ausgewählt
    if (currentPressed == i)
      return;
    setState(() {
      // Wenn der Schwierigkeitsgrad ausgewählt wurde, wird der Index I gegeben
      selected[i] = true; // Sonst setze die i-te Auswahl auf true und vorherige Auswahl auf false
      selected[currentPressed] = false;
      currentPressed = i;
    });
  }

  @override
  void initState() {
    for (var i in levels) {
      // wird vom lokalen Speicher gegriffen
      try {
        i.highScore = pref.getInt(i.name);
      } catch (e) {
      }
    }

    selected = List.generate(levels.length, (index) => false);
    selected[0] = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // Ändern der opacity jede Sek mit der timer var.
      if (mounted) {
        setState(() {
          seconds++;
          opacity = seconds % 2; // opacity [0/1]
        });
      } else {
        _timer.cancel();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: Icon(Icons.help),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Help()),
                );
              })
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50,
                ),
                Expanded(child: Image.asset('assets/images/minesweeper.png')),
                Text(
                  ' Minesweeper',
                  style: TextStyle(
                      fontSize: 50, fontFamily: 'Command', color: Colors.white),
                ),
                SizedBox(
                  width: 50,
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: levels
                      .asMap()
                      .entries
                      .map((level) => Difficulty(
                            level: level.value,
                            isPressed: selected[level.key],
                            function: onPressed,
                            number: level.key,
                          ))
                      .toList()),
            ),
            AnimatedOpacity(
              // https://www.youtube.com/watch?v=QZAvjqOqiLY
              duration: Duration(seconds: 1),
              opacity: this.opacity / 1,
              child: TextButton(
                child: Text(
                  'Start',
                  style: TextStyle(
                      fontSize: 30, fontFamily: 'Command', color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration.zero,
                      pageBuilder: (_, __, ___) => GamePage(
                        height: levels[currentPressed].height,
                        width: levels[currentPressed].width,
                        mineCount: levels[currentPressed].mineCount,
                        name: levels[currentPressed].name,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
