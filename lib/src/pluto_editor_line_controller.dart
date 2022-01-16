import 'package:flutter/material.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';

class PlutoEditorLineController {
  final PlutoRichCodeEditingController _controller;
  final FocusNode _focusNode;

  PlutoEditorLineController(SyntaxHighlighterBase syntaxHighlighter,
      {String? text})
      : _controller = PlutoRichCodeEditingController(
            syntaxHighlighter: syntaxHighlighter, text: text),
        _focusNode = FocusNode();

  TextEditingController get textEditingController => _controller;

  FocusNode get focusNode => _focusNode;
}
