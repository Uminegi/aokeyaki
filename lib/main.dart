import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width; // 画面の幅を取得
    final double screenHeight = MediaQuery.of(context).size.height; // 画面の高さを取得
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary, // アプリバーの背景色
        title: Text(widget.title), // アプリバーのタイトル
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 上寄せ配置
          children: [
            const Text("test"), // テスト用テキスト
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                      screenWidth * 0.7, screenHeight * 0.12), // ボタンサイズを画面比で指定
                ),
                onPressed: () {}, // ボタン押下時の処理
                child: const Text("記憶時間に移る")), // ボタンのラベル
          ],
        ),
      ),
    );
  }
}
