import 'dart:async';

import 'package:flutter/material.dart';

class GameTimer extends StatefulWidget {
  List counter;
  bool isResponsive; // wenn nicht responsive -> stop
  bool letsStart; // zum Erststart

  GameTimer({this.isResponsive, this.letsStart, this.counter});

  @override
  _GameTimerState createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  bool isStarted = false;
  Timer _timer;
  int seconds = 0;

  void startTimer() {
    // Auf 1 Sekunde setzen
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        // Jede Sekunde wird diese Funktion einmal ausgeführt
        oneSec, (Timer timer) {
          if (mounted) { setState(() {
            widget.counter[0] +=  1;
          },
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GameTimer oldWidget) {
    if (!widget.isResponsive && _timer != null) {
      _timer.cancel(); // timer stop
      return;
    }
    if (widget.letsStart && !isStarted) {
      // passiert nur einmal, Timer startet nach öffnen des ersten Felds
      isStarted = true;
      startTimer();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            right: BorderSide(width: 2, color: Colors.white),
            bottom: BorderSide(width: 2, color: Colors.white),
            top: BorderSide(width: 2, color: Color.fromARGB(255, 128, 128, 128)),
            left: BorderSide(width: 2, color: Color.fromARGB(255, 128, 128, 128)),
          )),
      padding: EdgeInsets.all(1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 0.5,
            child: Container(
              color: Colors.black,
              // Abhängig vom counter wird [1, 2, ...] eingesetzt
              child:
              Image.asset('assets/images/${(widget.counter[0] / 100).floor() % 10}.png'),
            ),
          ),
          AspectRatio(
            aspectRatio: 0.5,
            child: Container(
              color: Colors.black,
              child:
              Image.asset('assets/images/${(widget.counter[0] / 10).floor() % 10}.png'),
            ),
          ),
          AspectRatio(
            aspectRatio: 0.5,
            child: Container(
              color: Colors.black,
              child:
              Image.asset('assets/images/${(widget.counter[0] % 10)}.png'),
            ),
          ),
        ],
      ),
    );
  }
}
