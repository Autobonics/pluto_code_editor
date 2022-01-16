import 'package:flutter/material.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';

class PlutoEditorLineController {
  final PlutoRichCodeEditingController _controller;
  final FocusNode _focusNode;
  int currentIndent;

  PlutoEditorLineController(SyntaxHighlighterBase syntaxHighlighter,
      {String? text})
      : _controller = PlutoRichCodeEditingController(
            syntaxHighlighter: syntaxHighlighter, text: text),
        _focusNode = FocusNode(),
        currentIndent = 0;

  TextEditingController get textEditingController => _controller;

  FocusNode get focusNode => _focusNode;
}
