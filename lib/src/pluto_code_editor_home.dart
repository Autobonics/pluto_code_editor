import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';
import 'package:pluto_code_editor/src/bonicpython_syntax_highlighter.dart';
import 'package:pluto_code_editor/src/pluto_editor_formatter.dart';
import 'package:pluto_code_editor/src/pluto_editor_line_controller.dart';

class PlutoCodeEditor extends StatefulWidget {
  final SyntaxHighlighterBase? syntaxHighlighter;

  const PlutoCodeEditor({
    Key? key,
    this.syntaxHighlighter,
  }) : super(key: key);

  @override
  _PlutoCodeEditorState createState() => _PlutoCodeEditorState();
}

class _PlutoCodeEditorState extends State<PlutoCodeEditor> {
  late SyntaxHighlighterBase _syntaxHighlighter;
  final LineIndentationController _indentationController =
      LineIndentationController();

  final List<PlutoEditorLineController> _controllers =
      <PlutoEditorLineController>[];

  @override
  void initState() {
    _syntaxHighlighter =
        widget.syntaxHighlighter ?? BonicPythonSyntaxHighlighter();
    _controllers.add(PlutoEditorLineController(_syntaxHighlighter));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: _controllers.length,
          itemBuilder: (context, index) {
            return EditorLine(
              controller: _controllers[index],
              lineNumber: index + 1,
              indentationController: _indentationController,
              onNewline: () async {
                PlutoEditorLineController controller =
                    PlutoEditorLineController(_syntaxHighlighter,
                        text: "  " * _indentationController.currentIndent);
                _controllers.insert(index + 1, controller);
                setState(() {});
                await Future.delayed(const Duration(milliseconds: 50));
                FocusScope.of(context).requestFocus(controller.focusNode);
              },
              onRemoveLine: (int index) {
                if (index == 0) return;
                _controllers.removeAt(index);
                setState(() {});
                PlutoEditorLineController controller = _controllers[index - 1];
                FocusScope.of(context).requestFocus(controller.focusNode);
              },
            );
          },
        ),
      ),
    );
  }
}

class EditorLine extends StatefulWidget {
  final PlutoEditorLineController controller;
  final void Function() onNewline;
  final void Function(int) onRemoveLine;
  final int lineNumber;
  final LineIndentationController indentationController;

  const EditorLine({
    Key? key,
    required this.controller,
    required this.lineNumber,
    required this.onNewline,
    required this.onRemoveLine,
    required this.indentationController,
  }) : super(key: key);

  @override
  _EditorLineState createState() => _EditorLineState();
}

class _EditorLineState extends State<EditorLine> {
  late PlutoEditorFormatter _formatter;

  @override
  void initState() {
    _formatter =
        PlutoEditorFormatter(widget.onNewline, widget.indentationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          // color: Colors.grey,
          child: Center(child: Text(widget.lineNumber.toString())),
        ),
        Expanded(
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (RawKeyEvent key) {
              if (key.isKeyPressed(LogicalKeyboardKey.backspace)) {
                widget.onRemoveLine(widget.lineNumber - 1);
              }
            },
            child: TextField(
              decoration: null,
              autocorrect: false,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              autofocus: true,
              inputFormatters: [_formatter],
              maxLines: null,
              focusNode: widget.controller.focusNode,
              controller: widget.controller.textEditingController,
            ),
          ),
        )
      ],
    );
  }
}

class LineIndentationController {
  int currentIndent;

  LineIndentationController() : currentIndent = 0;
}
