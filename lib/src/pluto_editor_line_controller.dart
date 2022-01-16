import 'package:flutter/material.dart';
import 'package:pluto_code_editor/src/editor_theme.dart';
import 'package:pluto_code_editor/src/pluto_rich_code_editing_controller.dart';

class PlutoEditorLineController {
  final PlutoRichCodeEditingController _controller;
  final FocusNode _focusNode;
  final EditorTheme editorTheme;
  final String language;

  PlutoEditorLineController({
    String? text,
    required this.editorTheme,
    required this.language,
  })  : _controller = PlutoRichCodeEditingController(
          text: text,
          theme: editorTheme,
          language: language,
        ),
        _focusNode = FocusNode();

  TextEditingController get textEditingController => _controller;

  FocusNode get focusNode => _focusNode;
}
