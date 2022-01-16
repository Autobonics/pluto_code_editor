import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_code_editor/src/editor_theme.dart';
import 'package:pluto_code_editor/src/pluto_editor_formatter.dart';
import 'package:pluto_code_editor/src/pluto_editor_line.dart';
import 'package:pluto_code_editor/src/pluto_editor_line_controller.dart';

class PlutoCodeEditor extends StatefulWidget {
  // final SyntaxHighlighterBase? syntaxHighlighter;
  // final Color dividerLineColor;
  final EditorTheme theme;

  PlutoCodeEditor({
    Key? key,
    // this.syntaxHighlighter,
    EditorTheme? theme,
  })  : this.theme = theme ?? EditorTheme(),
        super(key: key);

  @override
  _PlutoCodeEditorState createState() => _PlutoCodeEditorState();
}

class _PlutoCodeEditorState extends State<PlutoCodeEditor> {
  // late SyntaxHighlighterBase _syntaxHighlighter;
  final LineIndentationController _indentationController =
      LineIndentationController();

  final List<PlutoEditorLineController> _controllers =
      <PlutoEditorLineController>[];

  @override
  void initState() {
    // _syntaxHighlighter =
    //     widget.syntaxHighlighter ?? BonicPythonSyntaxHighlighter();
    _controllers.add(PlutoEditorLineController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: widget.theme.backgroundColor,
        child: ListView.builder(
          itemCount: _controllers.length,
          itemBuilder: (context, index) {
            return PlutoEditorLine(
              controller: _controllers[index],
              lineNumber: index + 1,
              indentationController: _indentationController,
              dividerLineColor: widget.theme.dividerLineColor,
              lineNumberStyle: widget.theme.lineNumberStyle,
              onNewline: () async {
                PlutoEditorLineController controller =
                    PlutoEditorLineController(
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
