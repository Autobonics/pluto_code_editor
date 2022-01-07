import 'package:flutter/material.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pluto Code Editor Demo',
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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PlutoCodeEditorHome(),
    );
  }
}
