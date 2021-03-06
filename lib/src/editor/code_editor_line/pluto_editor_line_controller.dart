import 'package:flutter/material.dart';
import 'package:pluto_code_editor/src/editor/editor_theme.dart';
import 'package:pluto_code_editor/src/editor/editor_line_formatter/pluto_rich_code_editing_controller.dart';

class PlutoEditorLineController {
  final PlutoRichCodeEditingController _controller;
  final FocusNode _focusNode;
  final EditorTheme editorTheme;
  final String language;
  final VoidCallback listner;

  PlutoEditorLineController({
    String? text,
    required this.editorTheme,
    required this.language,
    required this.listner,
  })  : _controller = PlutoRichCodeEditingController(
          text: text,
          theme: editorTheme,
          language: language,
        ),
        _focusNode = FocusNode()..addListener(listner);

  TextEditingController get textEditingController => _controller;

  FocusNode get focusNode => _focusNode;

  void dispose() {
    _focusNode.removeListener(listner);
    _controller.dispose();
  }
}
