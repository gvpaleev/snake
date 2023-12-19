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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('AppBar')),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final gameMapData = GameMapData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RawKeyboard.instance.addListener((RawKeyEvent event) {
      if (event is RawKeyDownEvent) {
        if (event.logicalKey.keyLabel == 'Arrow Left') {
          gameMapData.snakeDirection = 3;
        }
        if (event.logicalKey.keyLabel == 'Arrow Up') {
          gameMapData.snakeDirection = 0;
          // Vector = 1;
        }
        if (event.logicalKey.keyLabel == 'Arrow Down') {
          gameMapData.snakeDirection = 2;
        }
        if (event.logicalKey.keyLabel == 'Arrow Right') {
          gameMapData.snakeDirection = 1;
        }
        // print('Клавиша ${event.logicalKey.keyLabel} нажата');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromARGB(100, 0, 0, 0), width: 1)),
          width: 1202,
          child: Wrap(children: gameMapData.getMap()),
        ),
      ),
    );
  }
}

class GameMapData {
  final Map<int, Cell> map = List.generate(6000, (index) {
    final cellModel = CellModel();
    final cell = Cell(model: cellModel);
    return cell;
  }).asMap();

  List<int> snake = [Random().nextInt(6000)];
  int snakeLingth = 6;

  int snakeDirection = Random().nextInt(4);

  GameMapData() {
    Timer.periodic(Duration(milliseconds: 25), (timer) {
      stepGame();
    });
  }

  void stepGame() {
    snake.forEach((item) {
      if (map[item]!.model.flag != true) {
        map[item]!.model.edit();
      }
    });
    switch (snakeDirection) {
      case 0:
        upStep();
        break;
      case 1:
        rightStep();
        break;
      case 2:
        downStep();
        break;
      case 3:
        leftStep();
        break;
    }
  }

  List<Widget> getMap() {
    return map.entries.map((elem) => elem.value).toList();
  }

  void upStep() {
    snake.insert(
        0, (snake[0] - 120) < 0 ? snake[0] + 120 * 49 : snake[0] - 120);

    if (snake.length > snakeLingth) {
      map[snake.removeLast()]!.model.edit();
    }
  }

  void rightStep() {
    snake.insert(0, (snake[0] + 1) % 120 == 0 ? snake[0] - 119 : snake[0] + 1);

    if (snake.length > snakeLingth) {
      map[snake.removeLast()]!.model.edit();
    }
  }

  void downStep() {
    snake.insert(
        0, (snake[0] + 120) > 6000 ? snake[0] - 120 * 49 : snake[0] + 120);

    if (snake.length > snakeLingth) {
      map[snake.removeLast()]!.model.edit();
    }
  }

  void leftStep() {
    snake.insert(0, snake[0] % 120 == 0 ? snake[0] + 119 : snake[0] - 1);

    if (snake.length > snakeLingth) {
      map[snake.removeLast()]!.model.edit();
    }
    // print('leftStep');
  }
}

class Cell extends StatefulWidget {
  final CellModel model;
  // final int index;
  const Cell({super.key, required this.model});

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.model.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      color: widget.model.flag
          ? Colors.black
          : Color.fromARGB(50, Random().nextInt(256), Random().nextInt(256),
              Random().nextInt(256)),
    );
  }
}

class CellModel extends ChangeNotifier {
  bool flag = false;

  void edit() {
    flag = !flag;
    notifyListeners();
  }
}
