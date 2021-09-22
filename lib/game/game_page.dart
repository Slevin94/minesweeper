import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper/game/flag_count.dart';
import 'package:minesweeper/game/tiles.dart';
import 'package:minesweeper/game/timer.dart';
import 'package:minesweeper/game/winner_banner.dart';
import 'package:minesweeper/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class GamePage extends StatefulWidget {
  int width;
  int height;
  int mineCount;
  String name;

  GamePage(
      {this.width = 10,
      this.height = 10,
      this.mineCount = 10,
      this.name = 'Easy'
      });
  // Der Konstruktor nimmt die Breite,
  // Höhe und Minenzahl. 10 ist der Standardwert

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // Bestimmt die Menge an Flaggen
  var flagCount = 10;
  // Erhöht sich jeweils um 1 wenn ein freies Feld aufgedeckt wird
  var winNum = 0;
  var pressedOnes = [ 0,];
  var counter = [0,];
  Timer _timer;   //Timer Objekt
  var grid = [];
  var revGrid = []; // Speichert den status eines geöffneten blocks
  var flagGrid = []; // Flaggen location
  var flagNumber = [ 0,]; // Speichert die Menge an genutzen flaggen
  var mines = []; // locations der Minen
  var smiley = true;
  var isResponsive = true;

  //Ist true wenn das Game startet
  var isStarted = false;

  void firstStart() {
    //Wird ausgeführt nach öffnen eines Feldes
    if (!isStarted) {
      setState(() {
        // If loop damit set nur einmal gesetzt werden kann.
        isStarted = true;
      });
    }
  }

  void setFlag() {
    setState(() {
      flagCount = 10 - flagNumber[0];
    });
  }

  void ded() {
    setState(() {
      smiley = false; // sad face
      isResponsive = false;
      for (var i in mines) {
        revGrid[i[0]][i[1]] = true; // Legt die Minenfelder nach einen Game over offen
      }
    });

    Navigator.of(context).push(PageRouteBuilder(
        // win / lose Banner
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return WinnerBanner(
            won: false,
          );
        }));
  }

  void win(int row, int col) {
    setState(() {
      revGrid[row][col] = true;
      isResponsive = false;

      try {
        // Setzt den Highscore. Widget.name gibt den Schwierigkeitsgrad an.
        var input = pref.getInt('${widget.name}');
        if (input > counter[0]) {
          pref.setInt(widget.name, this.counter[0]);
        }
      } catch (e) {
        // Falls es vorher kein Highscore gab
        pref.setInt(widget.name, this.counter[0]);
      }
    });

    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return WinnerBanner(won: true, );
        }));
  }

  void placeMines() {
    var row = <int>[]; // x achse [x,y]
    var col = <int>[]; // y achse [x,y]
    var surrAdds = [  [-1, 1],  [0, 1],  [1, 1],
                      [-1, 0],           [1, 0],
                      [-1, -1], [0, -1], [1, -1]
    ];
    var rand = Random();

    var count = 0;
    while (count < widget.mineCount) {
      var rowMid = rand.nextInt(widget.height); // random x
      var colMid = rand.nextInt(widget.width); // random y

      if (grid[rowMid][colMid] != -1) {
        //print(rowMid.toString() + '   ' + colMid.toString());
        grid[rowMid][colMid] = -1; // Mine gesetzt
        mines.add([rowMid, colMid]); // Mine der liste hinzugefügt

        for (var i in surrAdds) {
          // zugriff auf die blocks drum herum
          var midRow = rowMid + i[0];
          var midCol = colMid + i[1];

          if (!(midRow == -1 ||
              midRow == widget.height ||
              midCol == -1 ||
              midCol == widget.width)) {
            // falls das neue [x,y] im Grid ist, dann wird der loop ausgeführt
            if (grid[midRow][midCol] != -1) {
              // Inkrementierung der unmittelbaren Umgebung +1
              grid[midRow][midCol] += 1;
            }
          }
        }
        count++;
      }
    }
  }

  void floodFillCover(int row, int col) {

    // Aufdecken aller leeren Felder
    void floodFill(int row, int col) {

      // checkt für out of bounds
      if (row < 0 || row == widget.height || col < 0 || col == widget.width)
        return;

      // if stop für bereits aufgedecktes und für Flaggen
      if (grid[row][col] == -1 || revGrid[row][col] || flagGrid[row][col]) {
        return;
      }

      // Falls eine Nummer, Nummer aufdecken und Funktion stoppen
      if (![0, -1].contains(grid[row][col])) {
        revGrid[row][col] = true;
        pressedOnes[0]++;
        return;
      }

      // Markiert das Feld um zu vermeiden doppelt drüber zu gehen
      revGrid[row][col] = true;
      pressedOnes[0]++;

      floodFill(row + 1, col); // unten
      floodFill(row - 1, col); // oben
      floodFill(row, col + 1); // rechts
      floodFill(row, col - 1); // links
      floodFill(row + 1, col + 1); // oben rechts
      floodFill(row - 1, col + 1); // oben links
      floodFill(row + 1, col - 1); // unten rechts
      floodFill(row - 1, col - 1); // unten links
      return;
    }

    floodFill(row, col);
    if (pressedOnes[0] == winNum) {
      // check ob gewonnen wurde
      win(row, col);
      return;
    }
    setState(() {
    });
  }

  @override
  void initState() {
    // Berechnung der nötigen Felder um zu gewinnen
    winNum = widget.width * widget.height - widget.mineCount;
    // Füllen der grids
    grid = List.generate( widget.height, (row) => List.generate( widget.width, (col) => 0));
    revGrid = List.generate(widget.height, (row) => List.generate(widget.width, (col) => false));
    flagGrid = List.generate(widget.height, (row) => List.generate(widget.width, (col) => false));
    placeMines();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // https://www.youtube.com/watch?v=zrn7V3bMJvg
    return InteractiveViewer(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 192, 192, 192),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
              color: Color.fromARGB(255, 192, 192, 192),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 50,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration.zero,
                              pageBuilder: (_, __, ___) => Home(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  LayoutBuilder(builder: (context, size) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      height: 70,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 192, 192, 192),
                          border: Border(
                            right: BorderSide(
                                width: size.maxWidth / 100,
                                color: Colors.white),
                            bottom: BorderSide(
                                width: size.maxWidth / 100,
                                color: Colors.white),
                            top: BorderSide(
                                width: size.maxWidth / 100,
                                color: Color.fromARGB(255, 128, 128, 128)),
                            left: BorderSide(
                                width: size.maxWidth / 100,
                                color: Color.fromARGB(255, 128, 128, 128)),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GameTimer(
                            isResponsive: this.isResponsive,
                            letsStart: this.isStarted,
                            counter: counter,
                          ),

                          AspectRatio(
                            // Smiley face widget
                            aspectRatio: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: Duration.zero,
                                    pageBuilder: (_, __, ___) => GamePage(
                                      height: widget.height,
                                      width: widget.width,
                                      mineCount: widget.mineCount,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 192, 192, 192),
                                    border: Border(
                                      top: BorderSide(
                                          width: 1, color: Colors.white),
                                      left: BorderSide(
                                          width: 1, color: Colors.white),
                                      right: BorderSide(
                                          width: 1,
                                          color: Color.fromARGB(
                                              255, 128, 128, 128)),
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Color.fromARGB(
                                              255, 128, 128, 128)),
                                    )),
                                child: Image.asset('assets/images/${smiley ? 'smiley' : 'frowney'}.png'),
                              ),
                            ),
                          ),

                          FlagCount(
                            number: this.flagCount,
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  LayoutBuilder(builder: (context, size) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border(
                            right: BorderSide(
                                width: size.maxWidth / 100,
                                color: Colors.white),
                            bottom: BorderSide(
                                width: size.maxWidth / 100,
                                color: Colors.white),
                            top: BorderSide(
                                width: size.maxWidth / 100,
                                color: Color.fromARGB(255, 128, 128, 128)),
                            left: BorderSide(
                                width: size.maxWidth / 100,
                                color: Color.fromARGB(255, 128, 128, 128)),
                          )),
                      child: Column(

                          // Board widget
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate( widget.height,
                              (row) => Row(
                                    children: List.generate(
                                        widget.width,
                                        (col) => NormalTile(
                                              revGrid,
                                              grid,
                                              row,
                                              col,
                                              getRemaining: floodFillCover,
                                              isRevealed: revGrid[row][col],
                                              death: ded,
                                              isResponsive: this.isResponsive,
                                              startFirst: firstStart,
                                              pressedOnes: pressedOnes,
                                              winningNumber: winNum,
                                              win: win,
                                              flagGrid: this.flagGrid,
                                              flagNumber: this.flagNumber,
                                              setFlag: this.setFlag,
                                            )),
                                  ))),
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        )),
      ),
    );
  }
}
