import 'package:flutter/material.dart';

class PlutoCodeEditorHome extends StatefulWidget {
  const PlutoCodeEditorHome({Key? key}) : super(key: key);

  @override
  _PlutoCodeEditorHomeState createState() => _PlutoCodeEditorHomeState();
}

class _PlutoCodeEditorHomeState extends State<PlutoCodeEditorHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: const Center(
          child: Text(" Pluto Code Editor "),
        ));
  }
}
