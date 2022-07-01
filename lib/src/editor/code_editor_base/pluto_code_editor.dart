import 'package:flutter/material.dart';
import 'package:pluto_code_editor/src/editor/syntax/bonicpython.dart';
import 'package:pluto_code_editor/src/editor/code_editor_base/pluto_code_editor_controller.dart';
import 'package:pluto_code_editor/src/editor/code_editor_line/pluto_editor_line.dart';
import 'package:pluto_code_editor/src/editor/code_editor_line/pluto_editor_line_controller.dart';
import 'package:highlight/highlight_core.dart' show highlight;

class PlutoCodeEditor extends StatefulWidget {
  final PlutoCodeEditorController controller;

  const PlutoCodeEditor({
    Key? key,
    required this.controller,
  }) : super(key: key);

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

  _getOnNewLine(int index) {
    return (String text) async {
      PlutoEditorLineController lineController =
          widget.controller.getNewLineController(index + 1, text);
      widget.controller.controllers.insert(index + 1, lineController);
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 50));
      FocusScope.of(context).requestFocus(lineController.focusNode);
    };
  }

  _onRemoveLine(int index, String suffixText) async {
    if (index == 0) return;
    widget.controller.controllers[index].dispose();
    widget.controller.controllers.removeAt(index);
    setState(() {});
    PlutoEditorLineController controller =
        widget.controller.controllers[index - 1];
    int offset = controller.textEditingController.text.length;
    controller.textEditingController.text += suffixText;
    controller.textEditingController.selection =
        TextSelection.fromPosition(TextPosition(offset: offset));
    setState(() {});
    FocusScope.of(context).requestFocus(controller.focusNode);
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
              onNewline: _getOnNewLine(index),
              onRemoveLine: _onRemoveLine,
            );
          },
        ),
      ),
    );
  }
}
