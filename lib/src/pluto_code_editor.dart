import 'package:flutter/material.dart';
import 'package:pluto_code_editor/src/bonicpython.dart';
import 'package:pluto_code_editor/src/editor_theme.dart';
import 'package:pluto_code_editor/src/pluto_code_editor_controller.dart';
import 'package:pluto_code_editor/src/pluto_editor_formatter.dart';
import 'package:pluto_code_editor/src/pluto_editor_line.dart';
import 'package:pluto_code_editor/src/pluto_editor_line_controller.dart';
import 'package:highlight/highlight_core.dart' show highlight;

class PlutoCodeEditor extends StatefulWidget {
  // final SyntaxHighlighterBase? syntaxHighlighter;
  // final Color dividerLineColor;
  final PlutoCodeEditorController controller;
  final EditorTheme theme;
  final String language;

  PlutoCodeEditor({
    Key? key,
    // this.syntaxHighlighter,
    required this.controller,
    EditorTheme? theme,
    this.language = 'bonicpython',
  })  : this.theme = theme ?? EditorTheme(),
        super(key: key);

  @override
  _PlutoCodeEditorState createState() => _PlutoCodeEditorState();
}

class _PlutoCodeEditorState extends State<PlutoCodeEditor> {
  // late SyntaxHighlighterBase _syntaxHighlighter;
  final LineIndentationController _indentationController =
      LineIndentationController();

  @override
  void initState() {
    if (widget.language == 'bonicpython') {
      highlight.registerLanguage('bonicpython', bonicpython);
    }
    widget.controller.controllers.add(
      PlutoEditorLineController(
        editorTheme: widget.theme,
        language: widget.language,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: widget.theme.backgroundColor,
        child: ListView.builder(
          itemCount: widget.controller.controllers.length,
          itemBuilder: (context, index) {
            return PlutoEditorLine(
              controller: widget.controller.controllers[index],
              lineNumber: index + 1,
              indentationController: _indentationController,
              dividerLineColor: widget.theme.dividerLineColor,
              lineNumberStyle: widget.theme.lineNumberStyle,
              onNewline: () async {
                PlutoEditorLineController controller =
                    PlutoEditorLineController(
                  text: "  " * _indentationController.currentIndent,
                  editorTheme: widget.theme,
                  language: widget.language,
                );
                widget.controller.controllers.insert(index + 1, controller);
                setState(() {});
                await Future.delayed(const Duration(milliseconds: 50));
                FocusScope.of(context).requestFocus(controller.focusNode);
              },
              onRemoveLine: (int index) {
                if (index == 0) return;
                widget.controller.controllers.removeAt(index);
                setState(() {});
                PlutoEditorLineController controller =
                    widget.controller.controllers[index - 1];
                FocusScope.of(context).requestFocus(controller.focusNode);
              },
            );
          },
        ),
      ),
    );
  }
}
