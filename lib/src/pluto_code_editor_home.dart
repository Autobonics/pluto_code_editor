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

  final List<EditorLineController> _controllers = <EditorLineController>[];

  @override
  void initState() {
    _syntaxHighlighter =
        widget.syntaxHighlighter ?? BonicPythonSyntaxHighlighter();
    _controllers.add(EditorLineController(_syntaxHighlighter));
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
                print("on next pressed");
                _controllers.insert(
                    index + 1, EditorLineController(_syntaxHighlighter));
                setState(() {});
                FocusScope.of(context)
                    .requestFocus(_controllers[index + 1].focusNode);
              },
            );
          },
        ),
      ),
    );
  }
}

class EditorLine extends StatefulWidget {
  final EditorLineController controller;
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
          child: RawKeyboardListener(
            focusNode: widget.controller.focusNode,
            onKey: (RawKeyEvent event) {},
            child: TextField(
              decoration: null,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              autofocus: true,
              // focusNode: widget.controller.focusNode,
              controller: widget.controller.textEditingController,
              onEditingComplete: () => widget.onNextPressed(),
              onSubmitted: (val) => print('on submit pressed'),
              onChanged: (val) => print(val),
              onTap: () => print('on tap pressed'),
            ),
          ),
        )
      ],
    );
  }
}

class EditorLineController {
  final RichCodeEditingController _controller;
  final FocusNode _focusNode;

  EditorLineController(
    SyntaxHighlighterBase syntaxHighlighter,
  )   : _controller =
            RichCodeEditingController(syntaxHighlighter: syntaxHighlighter),
        _focusNode = FocusNode();

  TextEditingController get textEditingController => _controller;

  FocusNode get focusNode => _focusNode;
}
