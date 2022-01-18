import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';
import 'package:flutter_highlight/themes/an-old-hope.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pluto Code Editor Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlutoCodeEditorDemo(),
    );
  }
}

class PlutoCodeEditorDemo extends StatefulWidget {
  const PlutoCodeEditorDemo({Key? key}) : super(key: key);

  @override
  _PlutoCodeEditorDemoState createState() => _PlutoCodeEditorDemoState();
}

class _PlutoCodeEditorDemoState extends State<PlutoCodeEditorDemo> {
  PlutoCodeEditorController controller = PlutoCodeEditorController(
      theme: EditorTheme(syntaxTheme: anOldHopeTheme));
  StreamController streamController = StreamController.broadcast();
  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0088CC),
        elevation: 0,
        title: const Text("Pluto Code Editor"),
      ),
      endDrawer: PlutoOutputViewer(
        controller: controller,
        output: streamController.stream,
      ),
      body: PlutoCodeEditor(
        controller: controller,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: PlutoEditorBottomBar(
        controller: controller,
        keys: const [
          ':',
          '#',
          '(',
          ')',
          '[',
          ']',
          '.',
          "'",
        ],
        onCodeRun: () {
          isRunning = true;
          void showHelloWorld() async {
            if (!isRunning) return;
            streamController.sink.add("Hello world\n");
            await Future.delayed(const Duration(milliseconds: 200));
            showHelloWorld();
          }

          showHelloWorld();
        },
        onPause: () {
          isRunning = false;
        },
      ),
    );
  }
}
