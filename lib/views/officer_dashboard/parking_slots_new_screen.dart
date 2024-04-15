import 'package:flutter/material.dart';

class ParkingSlotsNewScreen extends StatelessWidget {
  const ParkingSlotsNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFFFC700),
          title: const Text(
            'Parking slots new screen',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(32),
          child: Row(
            children: [
              Column(
                children: List.generate(
                    10,
                    (index) => createSlot(
                          "S${index + 1}",
                          borderTopLeft(),
                          index == 9,
                          1,
                        )),
              ),
              const Spacer(),
              Column(
                children: List.generate(
                    10,
                    (index) => createSlot(
                          "S${index + 11}",
                          middleBorderTopRight(),
                          index == 9,
                          2,
                        )),
              ),
              Column(
                children: List.generate(
                    10,
                    (index) => createSlot(
                          "S${index + 21}",
                          middleBorderTopLeft(),
                          index == 9,
                          3,
                        )),
              ),
              const Spacer(),
              Column(
                children: List.generate(
                    10,
                    (index) => createSlot(
                          "S${index + 31}",
                          borderTopRight(),
                          index == 9,
                          4,
                        )),
              ),
            ],
          ),
        ));
  }

  Widget createSlot(String text, BoxDecoration decoration, bool isLast, int colNum) {
    BoxDecoration finalDecoration;
    if (isLast && (colNum == 1 || colNum == 3)) {
      finalDecoration = decoration.copyWith(
        border: const Border(
          top: BorderSide(color: Colors.black, width: 2.0),
          bottom: BorderSide(color: Colors.black, width: 2.0),
          left: BorderSide(color: Colors.black, width: 2.0),
        ),
      );
    } else if (isLast && (colNum == 2 || colNum == 4)) {
      finalDecoration = decoration.copyWith(
        border: const Border(
          top: BorderSide(color: Colors.black, width: 2.0),
          bottom: BorderSide(color: Colors.black, width: 2.0),
          right: BorderSide(color: Colors.black, width: 2.0),
        ),
      );
    } else {
      finalDecoration = decoration;
    }

    return Container(
      decoration: finalDecoration,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 50,
      width: 50,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4),
        color: const Color(0xFFF3F6FF),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  BoxDecoration borderTopLeft() {
    return const BoxDecoration(
      border: Border(
        left: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
        top: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    );
  }

  BoxDecoration borderTopRight() {
    return const BoxDecoration(
      border: Border(
        right: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
        top: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    );
  }

  BoxDecoration middleBorderTopLeft() {
    return const BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
        left: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    );
  }

  BoxDecoration middleBorderTopRight() {
    return const BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
        right: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    );
  }
}