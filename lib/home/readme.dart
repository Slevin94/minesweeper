import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: Text('ReadMe'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 192, 192, 192),
              padding: EdgeInsets.all(20),
              child: LayoutBuilder(builder: (context, size) {
                return Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border(
                          right: BorderSide(
                              width: size.maxWidth / 100, color: Colors.white),
                          bottom: BorderSide(
                              width: size.maxWidth / 100, color: Colors.white),
                          top: BorderSide(
                              width: size.maxWidth / 100,
                              color: Color.fromARGB(255, 128, 128, 128)),
                          left: BorderSide(
                              width: size.maxWidth / 100,
                              color: Color.fromARGB(255, 128, 128, 128)),
                        )),
                    width: double.infinity,
                    child: Text(
                          '1. Berühre ein leeres Feld um dieses aufzudecken.'
                          '\n2. Das Spiel endet wenn das gewählte Feld eine Mine enthält.'
                          '\n3. Die Nummer auf einen aufgedeckten Feld verrät wie viele Minen um'
                          ' dieses Feld herum sind.'
                          '\n4. Berührst du ein Feld für eine längere Zeit so markierst du dieses'
                          ' Feld mit einer Fahne und es kann nicht mehr aufgedeckt werden.'
                          '\n5. Viel Glück! :)',
                      style: TextStyle(
                          fontFamily: 'Command',
                          color: Colors.green,
                          fontSize: 20),
                    ));
              }),
            ),
          ),
        ],
      ),
    );
  }
}
