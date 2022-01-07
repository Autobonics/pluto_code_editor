import 'package:flutter/material.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';
import 'package:pluto_code_editor/src/bonicpython_syntax_highlight.dart';

class PlutoCodeEditorHome extends StatefulWidget {
  final SyntaxHighlighterBase? syntaxHighlighter;

  const PlutoCodeEditorHome({
    Key? key,
    this.syntaxHighlighter,
  }) : super(key: key);

  @override
  _PlutoCodeEditorHomeState createState() => _PlutoCodeEditorHomeState();
}

class _PlutoCodeEditorHomeState extends State<PlutoCodeEditorHome> {
  late SyntaxHighlighterBase _syntaxHighlighter;

  final List<RichCodeEditingController> _controllers =
      <RichCodeEditingController>[];

  @override
  void initState() {
    _syntaxHighlighter =
        widget.syntaxHighlighter ?? BonicPythonSyntaxHighlighter();
    _controllers
        .add(RichCodeEditingController(syntaxHighlighter: _syntaxHighlighter));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.red,
        child: ListView.builder(
          itemCount: _controllers.length,
          itemBuilder: (context, index) {
            return EditorLine(
              controller: _controllers[index],
              lineNumber: index + 1,
              onNextPressed: () {
                FocusScope.of(context).unfocus();
                _controllers.insert(
                    index + 1,
                    RichCodeEditingController(
                        syntaxHighlighter: _syntaxHighlighter));
                setState(() {});
              },
            );
          },
        ),
      ),
    );
  }
}

class EditorLine extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onNextPressed;
  final int lineNumber;

  const EditorLine({
    Key? key,
    required this.controller,
    required this.lineNumber,
    required this.onNextPressed,
  }) : super(key: key);

  @override
  _EditorLineState createState() => _EditorLineState();
}

class _EditorLineState extends State<EditorLine> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: Colors.grey,
          child: Center(child: Text(widget.lineNumber.toString())),
        ),
        Expanded(
          child: TextField(
            decoration: null,
            autocorrect: false,
            autofocus: true,
            controller: widget.controller,
            onEditingComplete: () {
              widget.onNextPressed();
            },
          ),
        )
      ],
    );
  }
}
