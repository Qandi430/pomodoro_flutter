import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500; //변경 방지를 위하여 상수로 설정
  bool isRunning = false; //타이머 진행여부 확인
  int totalSeconds = twentyFiveMinutes; //총 시간
  int totalPomodoros = 0; //총 pomodoro 횟수
  late Timer timer; //late vatiable modifier는 이 property를 당장 초기화하지 않아도 된다는것을 뜻함.
  //property를 사용하기전에 초기화 한다고 계약
  void onTick(Timer time) {
    if (totalSeconds == 0) {
      //시간이 0이되면 pomodoro횟수를 증가시키고 나머지 초기화
      setState(() {
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
        totalPomodoros = totalPomodoros + 1;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds -= 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    ); //타이버 함수는 주기(첫번째 파라미터)마다  함수(2번째 파라미터)를 실행
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel(); //타이머 종료
    setState(() {
      isRunning = false;
    });
  }

  void onStopPressed() {
    timer.cancel(); //타이머 종료
    setState(() {
      isRunning = false;
      totalSeconds = twentyFiveMinutes;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).backgroundColor, //backgroundColor를 context에서 가져와 설정
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ), //비율로 공간을결정
          Flexible(
            flex: 2, //default = 1 2는 1의 2배
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed:
                        isRunning ? onPausePressed : onStartPressed, //3항연산자로 조절
                    icon: Icon(isRunning
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline),
                  ),
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed: onStopPressed, //3항연산자로 조절
                    icon: const Icon(Icons.stop_circle_outlined),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodoros',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 58,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
