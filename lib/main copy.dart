import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Snake(),
    );
  }
}

class Snake extends StatefulWidget {
  const Snake({super.key});

  @override
  State<Snake> createState() => _SnakeState();
}

class _SnakeState extends State<Snake> {
  int Vector = Random().nextInt(4);
  List<int> snake = [Random().nextInt(6000)];
  final List<int> mapGamesInt = List.generate(6000, (index) => 1);

  void leftStep() {
    slepDef();
    if (snake[0] % 120 == 0) {
      snake[0] += 119;
    } else {
      snake[0] -= 1;
    }

    setState(() {});
  }

  void upStep() {
    slepDef();
    if (snake[0] - 120 < 0) {
      snake[0] += 120 * 49;
    } else {
      snake[0] -= 120;
    }
    setState(() {});

    // snake.removeLast();
  }

  void downStep() {
    slepDef();
    if (snake[0] + 120 > 6000) {
      snake[0] -= 120 * 49;
    } else {
      snake[0] += 120;
    }

    setState(() {});
  }

  void rightStep() {
    slepDef();
    if ((snake[0] + 1) % 120 == 0) {
      snake[0] -= 119;
    } else {
      snake[0] += 1;
    }

    setState(() {});
  }

  void slepDef() {
    for (var i = snake.length - 1; i > 0; i--) {
      snake[i] = snake[i - 1];
    }
  }

  void slepGame() {
    switch (Vector) {
      case 0:
        leftStep();
        break;
      case 1:
        upStep();
        break;

      case 2:
        rightStep();
        break;

      case 3:
        downStep();
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    snake.add(snake[0] + 1);
    snake.add(snake[0] + 2);
    snake.add(snake[0] + 3);
    snake.add(snake[0] + 4);
    // TODO: implement initState
    RawKeyboard.instance.addListener((RawKeyEvent event) {
      if (event is RawKeyDownEvent) {
        if (event.logicalKey.keyLabel == 'Arrow Left') {
          Vector = 0;
        }
        if (event.logicalKey.keyLabel == 'Arrow Up') {
          Vector = 1;
        }
        if (event.logicalKey.keyLabel == 'Arrow Down') {
          Vector = 3;
        }
        if (event.logicalKey.keyLabel == 'Arrow Right') {
          Vector = 2;
        }
        // print('Клавиша ${event.logicalKey.keyLabel} нажата');
      }
    });
    // renderGame();

    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      //   // счётчик++;
      slepGame();
      //   // print('tik');
      //   // if (счётчик >= 5) {
      //   // таймер.cancel(); // Отмена таймера после 5 итераций
      //   //   print('Таймер отменён после 5 итераций');
      //   // }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(snake);
    mapGamesInt.fillRange(0, mapGamesInt.length, 0);
    snake.map((elem) {
      // print(elem);
      mapGamesInt[elem] = 1;
    }).toList();
    // mapGames =

    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Snake'))),
      body: Container(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(100, 0, 0, 0), width: 1)),
            width: 1202,
            child: DataProviderInherited(
              mapGamesInt: mapGamesInt,
              child: Wrap(children: [
                // ElevatedButton(
                //   child: Text('button'),
                //   onPressed: () {},
                // ),
                ...mapGamesInt
                    .asMap()
                    .entries
                    .map((entry) => Cell(index: entry.key))

                // ...mapGames,
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class Cell extends StatelessWidget {
  // final int flag;
  final int index;
  const Cell({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final flag = context
            .dependOnInheritedWidgetOfExactType<DataProviderInherited>(
                aspect: '$index')
            ?.mapGamesInt[index] ??
        0;
    return Container(
      width: 10,
      height: 10,
      color: flag == 1
          ? Colors.black
          : Color.fromARGB(50, Random().nextInt(256), Random().nextInt(256),
              Random().nextInt(256)),
    );
  }
}

class DataProviderInherited extends InheritedModel<String> {
  final List<int> mapGamesInt;

  DataProviderInherited(
      {Key? key, required Widget child, required this.mapGamesInt})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant DataProviderInherited oldWidget) {
    bool isEqual = false;

    mapGamesInt.asMap().forEach((index, value) {
      if (oldWidget.mapGamesInt[index] != value) {
        isEqual = true;
      }
    });
    return isEqual;
  }

  @override
  bool updateShouldNotifyDependent(
      covariant DataProviderInherited oldWidget, Set<String> aspect) {
    bool isEqual = false;

    mapGamesInt.asMap().forEach((index, value) {
      if (oldWidget.mapGamesInt[index] != value && aspect.contains('$index')) {
        isEqual = true;
      }
    });
    return isEqual;
  }
}
