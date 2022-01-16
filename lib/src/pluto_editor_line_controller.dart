import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';
import 'package:pluto_code_editor/src/editor_theme.dart';

class PlutoEditorLineController {
  final PlutoRichCodeEditingController _controller;
  final FocusNode _focusNode;
  int currentIndent;

  PlutoEditorLineController({String? text})
      : _controller = PlutoRichCodeEditingController(
          text: text,
          theme: EditorTheme(),
        ),
        _focusNode = FocusNode(),
        currentIndent = 0;

  TextEditingController get textEditingController => _controller;

  FocusNode get focusNode => _focusNode;
}
