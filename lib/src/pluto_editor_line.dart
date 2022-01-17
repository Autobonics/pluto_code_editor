import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_code_editor/src/pluto_editor_formatter.dart';
import 'package:pluto_code_editor/src/pluto_editor_line_controller.dart';

class PlutoEditorLine extends StatefulWidget {
  final PlutoEditorLineController controller;
  final void Function() onNewline;
  final void Function(int) onRemoveLine;
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
    _rawFocusNode.dispose();
    widget.controller.dispose();
    super.dispose();
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
          child: Center(
              child: Text(
            widget.lineNumber.toString(),
            style: widget.lineNumberStyle,
          )),
        ),
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
        ),
      ],
    );
  }
}
