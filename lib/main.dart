import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:just_audio/just_audio.dart';

const int cardMa = 30;
const List<int> cardYaku = [1, 2, 10, 13, 44, 45];
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // このウィジェットはアプリケーションのルートです。
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '蒼けやき',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 25, 117, 238)),
      ),
      home: const MyHomePage(title: '蒼けやき'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // ホームページ用のStatefulWidget
  const MyHomePage({super.key, required this.title});

  final String title; // アプリバーに表示するタイトル

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> fileNames = [
    "あ",
    "い",
    "う",
    "え",
    "お",
    "か",
    "き",
    "く",
    "け",
    "こ",
    "さ",
    "し",
    "す",
    "せ",
    "そ",
    "た",
    "ち",
    "つ",
    "て",
    "と",
    "な",
    "に",
    "ぬ",
    "ね",
    "の",
    "は",
    "ひ",
    "ふ",
    "へ",
    "ほ",
    "ま",
    "み",
    "む",
    "め",
    "も",
    "や",
    "ゆ",
    "よ",
    "ら",
    "り",
    "る",
    "れ",
    "ろ",
    "わ",
    "を",
    "ん",
    "つづけます"
  ];
  final String soundType = "mp3";
  String reader = "r_n";
  AudioPlayer player = AudioPlayer(); //現在読む札が入る
  AudioPlayer next = AudioPlayer(); //「続けます」が入る
  AudioPlayer orderPlayer = AudioPlayer();
  var duration; //不要っぽい
  var audioDuration; //不要っぽい
  bool test = true; //消す
  DateTime preRead = DateTime.now();
  Duration waitRead = const Duration(seconds: 100);
  late Duration orderRead;
  late Duration nextRead;
  late Duration nowDuration;
  int nowState = 0;
  List<int> order = [];
  final CountDownController _controller = CountDownController();
  int memoTime = 3;
  bool ready = false;
  bool first = false;
  bool last = false;
  bool stoped = false;
  String nextS = "止める";
  int nowRead = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width; // 画面の幅を取得
    final double screenHeight = MediaQuery.of(context).size.height; // 画面の高さを取得
    MainAxisAlignment nowAlignment;
    switch (nowState) {
      case 0:
        nowAlignment = MainAxisAlignment.start;
        break;
      default:
        nowAlignment = MainAxisAlignment.center;
        break;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary, // アプリバーの背景色
        title: Text(widget.title), // アプリバーのタイトル
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: nowAlignment, // 上寄せ配置
          children: [
            if (nowState == 0) startScreen(context, screenWidth, screenHeight),
            if (nowState == 1) secondScreen(context, screenWidth, screenHeight),
            if (nowState == 2) readScreen(context, screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget startScreen(context, width, height) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.1,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(width * 0.7, height * 0.10), // ボタンサイズを画面比で指定
                textStyle: TextStyle(fontSize: width * 0.08)),
            onPressed: () {
              setState(() {
                nowState = 1;
                readInit();
              });
            }, // ボタン押下時の処理
            child: const Text("記憶時間に移る")), // ボタンのラベル
        SizedBox(height: height * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "記憶時間",
              style: TextStyle(fontSize: width * 0.07),
            ),
            Container(
              width: width * 0.1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Text(
                "$memoTime",
                style: TextStyle(fontSize: width * 0.07),
              ),
            ),
            Text("分", style: TextStyle(fontSize: width * 0.07)),
          ],
        ),
        SizedBox(height: height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                fixedSize: Size(width * 0.1, width * 0.1),
                textStyle: TextStyle(fontSize: width * 0.1),
                padding: EdgeInsets.all(0),
              ),
              onPressed: () {
                setState(() {
                  memoTime++;
                });
              },
              child: Text("+"),
            ),
            SizedBox(width: width * 0.05),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  fixedSize: Size(width * 0.1, width * 0.1),
                  textStyle: TextStyle(fontSize: width * 0.1),
                  padding: EdgeInsets.all(0),
                ),
                onPressed: () {
                  setState(() {
                    if (memoTime > 0) memoTime--;
                  });
                },
                child: const Text("-")),
            SizedBox(width: width * 0.05)
          ],
        )
      ],
    );
  }

  Widget secondScreen(context, width, height) {
    return Column(
      children: [
        CircularCountDownTimer(
          width: width * 0.5,
          height: height * 0.5,
          duration: memoTime * 60,
          fillColor: const Color.fromARGB(255, 20, 48, 204),
          ringColor: Color.fromRGBO(0, 0, 0, 0.1),
          controller: _controller,
          isReverse: true,
          isReverseAnimation: true,
          onComplete: () {
            changeToRead();
          },
        ),
        ElevatedButton(
            onPressed: () {
              changeToRead();
            },
            child: Text(
              "すぐに読み始める",
              style: TextStyle(fontSize: width * 0.1),
            ))
      ],
    );
  }

  //読む画面に遷移する処理
  void changeToRead() {
    if (nowState == 2) return;
    setState(() {
      nowState = 2;
    });
    soundLoop(); //読み始める
  }

  Widget readScreen(context, width, height) {
    return Column(
      children: [
        Text("test"),
        ElevatedButton(
            onPressed: () {
              setState(() {
                ready = !ready;
                if (ready) {
                  nextS = "止める";
                } else {
                  nextS = "続ける";
                }
              });
            },
            child: Text(nextS)),
        ElevatedButton(
            onPressed: () {
              setState(() {
                nowState = 0;
              });
            },
            child: Text("test"))
      ],
    );
  }

  //一回だけ呼び出して中で無限ループで処理する
  void soundLoop() async {
    player.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          audioDuration = duration.inMilliseconds / 1000.0;
        });
      }
    });
    preRead = DateTime.now();
    while (true) {
      // 50ミリ秒ごとに処理を実行して音声再生を管理
      await Future.delayed(const Duration(milliseconds: 50));
      // 前の札が読み終わって一定時間経過し、かつ再生準備ができている場合
      if (preRead.difference(DateTime.now()) >=
              waitRead + Duration(microseconds: 1500) &&
          ready) {
        // 待機時間をリセット
        waitRead = const Duration(seconds: 100);
        // 読み上げ開始時間を更新
        preRead = DateTime.now();
        if (stoped) {
          // 停止状態から再開する場合は「つづけます」の音声を再生
          player = next;
          waitRead = nextRead;
        } else {
          // 通常の札読み上げ処理
          player = orderPlayer;
          waitRead = orderRead;
          // 次の札のための新しいAudioPlayerを準備
          orderPlayer = AudioPlayer();
          // 次の札の音声ファイルをセット
          orderPlayer.setAsset(
              "assets/sounds/$reader/${fileNames[order[nowRead]]}.$soundType");
          // 次の札の再生時間を取得
          orderPlayer.durationStream.listen((duration) {
            //次の札が読まれる前にはロードが終わるはず
            if (duration != null) {
              setState(() {
                orderRead = duration;
              });
            }
          });
          nowRead++;//次の札にインデックスを移動する
        }
        player.seek(const Duration(seconds: 0));
        player.play();
        stoped = false;
      } else if (preRead.difference(DateTime.now()) >=
              waitRead + Duration(microseconds: 1500) &&
          !ready) {
        stoped = true;
      }
    }
  }

  //読み上げる部分の初期化
  void readInit() {
    mixSounds();
    ready = true;
    first = true;
    last = false;
    stoped = false;
    nextS = "止める";
    next.seek(const Duration(seconds: 0));
    preRead = DateTime.now(); //ひとつ前の札を読み始めた瞬間
    waitRead = const Duration(seconds: 100); //間の時間
    nowRead = 0;
    reader = "r_n"; //読み手場合によっては変わるかも
    player.setAsset(
        "assets/sounds/$reader/${fileNames[30]}.$soundType"); //最初はま札が読まれる
    next.setAsset(
        "assets/sounds/$reader/${fileNames[46]}.$soundType"); //"続けます"が入る
    orderPlayer.setAsset(
        "assets/sounds/$reader/${fileNames[order[nowRead]]}.$soundType"); //最初の1枚の準備
    //実際に読んでいる札の待機時間
    player.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          waitRead = duration;
        });
      }
    });

    //順番に読む札の時間が入る
    orderPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          orderRead = duration;
        });
      }
    });

    //"続けます"の時間が入る
    next.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          nextRead = duration;
        });
      }
    });
  }

  //音声の順番のシャッフルをする
  void mixSounds({int stMa = 5, int enMa = 5, int stYaku = 5, int enYaku = 5}) {
    if (enYaku < 2) enYaku = 2;
    if (enMa < 2) enMa = 2;

    while (true) {
      order = List.generate(46, (i) => i);
      order.shuffle();
      //ま札が初めの方に含まれているか確認
      if (stMa > 0) {
        List<int> stMaList = order.sublist(0, stMa);
        bool ng = false;
        for (int i in stMaList) {
          if (i == cardMa) {
            ng = true;
            break;
          }
        }
        if (ng) continue;
      }

      //やく札が初めの方に含まれているか確認
      if (stYaku > 0) {
        List<int> stYakuList = order.sublist(0, stYaku);
        bool ng = false;
        for (int i in stYakuList) {
          for (int j in cardYaku) {
            if (i == j) {
              ng = true;
              break;
            }
          }
          if (ng) break;
        }
        if (ng) continue;
      }

      //ま札が最後の方に含まれているか確認
      List<int> enMaList = order.sublist(order.length - enMa, order.length);
      bool ng = false;
      for (int i in enMaList) {
        if (i == cardMa) {
          ng = true;
          break;
        }
      }

      //やく札が最後の方に含まれているか確認
      List<int> enYakuList = order.sublist(order.length - enYaku, order.length);
      for (int i in enYakuList) {
        for (int j in cardYaku) {
          if (ng || i == j) {
            ng = true;
            break;
          }
        }
        if (ng) break;
      }
      if (ng) continue;

      break;
    }
    print(order);
  }
}
