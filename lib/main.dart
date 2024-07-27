import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var screen = '0';
  var input = '0';
  var press = false;

  @override
  Widget build(BuildContext context) {
    double buttonSize = MediaQuery.of(context).size.width / 4 - 25;
    double iconSize = MediaQuery.of(context).size.width / 13;
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 55, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          input,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          screen,
                          style: const TextStyle(fontSize: 60),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: iconSize,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                              child: Icon(
                                Icons.straighten,
                                size: iconSize,
                              ),
                            ),
                            Icon(
                              Icons.calculate_outlined,
                              size: iconSize,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  subString();
                                });
                              },
                              icon: Icon(
                                CupertinoIcons.delete_left,
                                color: Colors.green,
                                size: iconSize,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: button(['C', '()', '%', '/'], buttonSize),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: button(['7', '8', '9', '*'], buttonSize),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: button(['4', '5', '6', '-'], buttonSize),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: button(['1', '2', '3', '+'], buttonSize),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: button(['+/-', '0', '.', '='], buttonSize),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ElevatedButton> button(List<String> labels, double size) {
    List<ElevatedButton> buttonList = [];
    for (var x in labels) {
      buttonList.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: x == "=" ? Colors.green : Colors.grey.shade800,
            fixedSize: Size(size, size),
            shape: const CircleBorder(),
          ),
          onPressed: () {
            setState(() {
              calcLogic(x);
            });
          },
          child: Text(
            x,
            style: TextStyle(color: textColor(x), fontSize: size / 3.5),
          ),
        ),
      );
    }
    return buttonList;
  }

  bool isOperator(String x) {
    var operator = ['%', '/', '+', '-', '*', '='];
    return operator.contains(x);
  }

  Color textColor(String s) {
    if (s == '=') {
      return Colors.white;
    } else if (s == 'C') {
      return Colors.red;
    } else if (isOperator(s)) {
      return Colors.green;
    } else {
      return Colors.white;
    }
  }

  void calcLogic(String x) {
    if (screen == '0') {
      screen = '';
    }
    if (input == '0') {
      input = '';
    }
    if (x == '=') {
      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      screen = eval.toString();
    } else if (x == '()') {
      if (!press) {
        input += '(';
        screen = '0';
        press = true;
      } else if (press) {
        input += ')';
        screen = '0';
        press = false;
      }
    } else if (isOperator(x) && input == '') {
      input = '0$x';
    } else if (x == 'C') {
      screen = '0';
      input = '0';
    } else if (isOperator(x)) {
      screen = '0';
      input += x;
    } else {
      screen += x;
      input += x;
    }
  }

  void subString() {
    input = input.substring(0, input.length - 1);
    screen = screen.substring(0, screen.length - 1);
    if (screen == '') {
      screen = '0';
    }
    if (input == '') {
      input = '0';
    }
  }
}
