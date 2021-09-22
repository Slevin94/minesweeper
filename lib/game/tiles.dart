import 'package:flutter/material.dart';

class NormalTile extends StatefulWidget {
  List grid;
  List revGrid;
  List flagGrid;
  List flagNumber;

  // [x,y]
  int x, y;

  // liste für offene Felder
  List pressedOnes;
  // benötigte Anzahl an Felder um zu gewinnen
  int winningNumber;

  bool isFlagged;
  bool isRevealed;
  bool isResponsive;

  Function startFirst;
  Function getRemaining;
  Function death;
  Function win;
  Function setFlag;

  NormalTile(this.revGrid, this.grid, this.x, this.y, {
    this.isFlagged = false,
      this.isRevealed = false,
      this.getRemaining,
      this.death,
      this.isResponsive,
      this.startFirst,
      this.pressedOnes,
      this.winningNumber,
      this.win,
      this.flagGrid,
      this.flagNumber,
      this.setFlag});

  @override
  _NormalTileState createState() => _NormalTileState();
}

class _NormalTileState extends State<NormalTile> {
  // Booleans um die Änderungen local zu zeigen
  bool isRevealed;
  bool isFlagged;

  String outputImage(int i) {
    switch (i) {
      case -1:
        return 'assets/images/mine.png';
        break;
      case 0:
        return 'assets/images/zero.png';
        break;
      case 1:
        return 'assets/images/one.png';
        break;
      case 2:
        return 'assets/images/two.png';
        break;
      case 3:
        return 'assets/images/three.png';
        break;
      case 4:
        return 'assets/images/four.png';
        break;
      case 5:
        return 'assets/images/five.png';
        break;
      case 6:
        return 'assets/images/six.png';
        break;
      case 7:
        return 'assets/images/seven.png';
        break;
      case 8:
        return 'assets/images/eight.png';
        break;
    }
    return '';
  }

  //Setzen der Anfangszustände der beiden bools mit Konstruktorwerten
  @override
  void initState() {
    this.isRevealed = widget.isRevealed;
    this.isFlagged = widget.flagGrid[widget.x][widget.y];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NormalTile oldWidget) {
    this.isRevealed = widget.revGrid[widget.x][widget.y];
    this.isFlagged = widget.flagGrid[widget.x][widget.y];
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, size) {
            return GestureDetector(
              onLongPress: () {
                // bei aufgedeckten Feld keine Flagge setzen möglich
                if (!this.isRevealed) {
                  if (this.isFlagged) {
                    this.isFlagged = false; // long press Flagge
                    widget.flagNumber[0]--; // Menge verfügbarer Flaggen -1
                    widget.flagGrid[widget.x][widget.y] = false;
                    widget.setFlag(); // Updaten des parent widgets mit einer callback funktion
                  } else {
                    // flaggenlimit
                    if (widget.flagNumber[0] < 10) {
                      this.isFlagged = true;
                      widget.flagNumber[0]++; // flaggen++
                      widget.flagGrid[widget.x][widget.y] = true; // setzen der Flagge im Grid[x,y]
                    }
                    widget.setFlag(); // wieder updaten
                  }
                }
              },

              onTap: !widget.isResponsive || this.isRevealed || this.isFlagged ? null : () {
                  // Falls noch responsive oder nicht offen oder nicht markiert
                      if (widget.grid[widget.x][widget.y] == -1) {
                        widget.death();
                      } else if (widget.grid[widget.x][widget.y] == 0) {
                        //falls leeres Feld -> getRemaining(x,y) aufrufen
                        widget.startFirst();
                        widget.getRemaining(widget.x, widget.y);
                      } else {
                        // Win check
                        if (widget.pressedOnes[0] + 1 == widget.winningNumber) {
                          widget.win(widget.x, widget.y);
                          return;
                        }

                        widget.pressedOnes[0]++;
                        widget.startFirst();
                        setState(() {
                          this.isRevealed = true;
                          widget.revGrid[widget.x][widget.y] = true;
                        }
                        );
                      }
                    },

              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 192, 192, 192),
                    border: Border(
                      top: BorderSide(
                          width: isRevealed ? 0 : size.maxWidth / 10,
                          color: Colors.white),
                      left: BorderSide(
                          width: isRevealed ? 0 : size.maxWidth / 10,
                          color: Colors.white),
                      right: BorderSide(
                          width: isRevealed ? 0 : size.maxWidth / 10,
                          color: Color.fromARGB(255, 128, 128, 128)),
                      bottom: BorderSide(
                          width: isRevealed ? 0 : size.maxWidth / 10,
                          color: Color.fromARGB(255, 128, 128, 128)),
                    )),

                // falls nicht offen, blankes feld wird gezeigt, ansonsten entsprechende zahl mit grid[x,y]
                child: this.isRevealed ? Image.asset(
                    outputImage(widget.grid[widget.x][widget.y])) : (this.isFlagged ? Image.asset('assets/images/flag.png') : SizedBox()),
              ),
            );
          },
        ),
      ),
    );
  }
}
