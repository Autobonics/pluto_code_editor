import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_code_editor/src/editor/editor_line_formatter/pluto_editor_formatter.dart';
import 'package:pluto_code_editor/src/editor/code_editor_line/pluto_editor_line_controller.dart';

class PlutoEditorLine extends StatefulWidget {
  final PlutoEditorLineController controller;
  final void Function(String text) onNewline;
  final void Function(int, String suffixText) onRemoveLine;
  final int lineNumber;
  final LineIndentationController indentationController;
  final Color dividerLineColor;
  final TextStyle lineNumberStyle;

  const PlutoEditorLine({
    Key? key,
    required this.controller,
    required this.lineNumber,
    required this.onNewline,
    required this.onRemoveLine,
    required this.indentationController,
    required this.dividerLineColor,
    required this.lineNumberStyle,
  }) : super(key: key);

  @override
  _PlutoEditorLineState createState() => _PlutoEditorLineState();
}

class _PlutoEditorLineState extends State<PlutoEditorLine> {
  late PlutoEditorFormatter _formatter;
  late FocusNode _rawFocusNode;

  @override
  void initState() {
    _formatter =
        PlutoEditorFormatter(widget.onNewline, widget.indentationController);
    _rawFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _rawFocusNode.dispose();
  }

  _getLineNumber() {
    return GestureDetector(
      onTap: () {
        widget.controller.focusNode.requestFocus();
        widget.controller.textEditingController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: widget.controller.textEditingController.text.length);
      },
      child: Container(
        color: Colors.transparent,
        width: 40,
        height: 20,
        child: Center(
          child: Text(
            widget.lineNumber.toString(),
            style: widget.lineNumberStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getLineNumber(),
        Container(
          height: 20,
          width: 1,
          color: widget.dividerLineColor,
        ),
        const SizedBox(
          width: 7,
          height: 20,
        ),
        Expanded(
          child: RawKeyboardListener(
            focusNode: _rawFocusNode,
            onKey: (RawKeyEvent key) async {
              if (key.isKeyPressed(LogicalKeyboardKey.backspace)) {
                var cursorPos = widget
                    .controller.textEditingController.selection.base.offset;
                // String prefixText = widget
                //     .controller.textEditingController.text
                //     .substring(0, cursorPos);
                if (cursorPos <= 0) {
                  cursorPos = 0;
                  String suffixText = widget
                      .controller.textEditingController.text
                      .substring(cursorPos);
                  await Future.delayed(const Duration(microseconds: 10));
                  widget.onRemoveLine(widget.lineNumber - 1, suffixText);
                }
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
        ),
      ],
    );
  }
}
