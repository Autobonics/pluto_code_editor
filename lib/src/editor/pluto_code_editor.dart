import 'package:flutter/material.dart';
import 'package:pluto_code_editor/src/editor/bonicpython.dart';
import 'package:pluto_code_editor/src/editor/editor_theme.dart';
import 'package:pluto_code_editor/src/editor/pluto_code_editor_controller.dart';
import 'package:pluto_code_editor/src/editor/pluto_editor_formatter.dart';
import 'package:pluto_code_editor/src/editor/pluto_editor_line.dart';
import 'package:pluto_code_editor/src/editor/pluto_editor_line_controller.dart';
import 'package:highlight/highlight_core.dart' show highlight;

class PlutoCodeEditor extends StatefulWidget {
  // final SyntaxHighlighterBase? syntaxHighlighter;
  // final Color dividerLineColor;
  final PlutoCodeEditorController controller;
  // final EditorTheme theme;
  // final String language;

  PlutoCodeEditor({
    Key? key,
    // this.syntaxHighlighter,
    required this.controller,
    // EditorTheme? theme,
    // this.language = 'bonicpython',
  })
  // : this.theme = theme ?? EditorTheme(),
  : super(key: key);

  @override
  _PlutoCodeEditorState createState() => _PlutoCodeEditorState();
}

class _PlutoCodeEditorState extends State<PlutoCodeEditor> {
  _listner() {
    setState(() {});
  }

  @override
  void initState() {
    if (widget.controller.language == 'bonicpython') {
      highlight.registerLanguage('bonicpython', bonicpython);
    }
    widget.controller.addListener(_listner);
    widget.controller.setInitCode();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: widget.controller.theme.backgroundColor,
        child: ListView.builder(
          itemCount: widget.controller.controllers.length,
          itemBuilder: (context, index) {
            return PlutoEditorLine(
              controller: widget.controller.controllers[index],
              lineNumber: index + 1,
              indentationController: widget.controller.indentationController,
              dividerLineColor: widget.controller.theme.dividerLineColor,
              lineNumberStyle: widget.controller.theme.lineNumberStyle,
              onNewline: () async {
                PlutoEditorLineController lineController =
                    widget.controller.getNewLineController(index + 1);
                widget.controller.controllers.insert(index + 1, lineController);
                setState(() {});
                await Future.delayed(const Duration(milliseconds: 50));
                FocusScope.of(context).requestFocus(lineController.focusNode);
              },
              onRemoveLine: (int index) async {
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
