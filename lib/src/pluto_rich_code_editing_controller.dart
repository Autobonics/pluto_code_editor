import 'package:flutter/material.dart';
import 'package:pluto_code_editor/src/editor_theme.dart';
import 'package:highlight/highlight_core.dart' show highlight, Node;

class PlutoRichCodeEditingController extends TextEditingController {
  // SyntaxHighlighterBase syntaxHighlighter;
  final EditorTheme theme;
  final String language;

  PlutoRichCodeEditingController({
    String? text,
    required this.theme,
    required this.language,
  }) : super(text: text);

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context, TextStyle? style, bool? withComposing}) {
    var _textStyle = TextStyle(
      fontFamily: theme.fontFamily,
      color: theme.fontColor,
    );

    return TextSpan(
      style: _textStyle,
      children: getHighlightTextSpan(value.text, language, theme.syntaxTheme),
    );
  }
}

List<TextSpan> getHighlightTextSpan(
    String source, String language, Map<String, TextStyle> theme) {
  return _convert(highlight.parse(source, language: language).nodes!, theme);
}

List<TextSpan> _convert(
  List<Node> nodes,
  Map<String, TextStyle> syntaxTheme,
) {
  List<TextSpan> spans = [];
  var currentSpans = spans;
  List<List<TextSpan>> stack = [];

  _traverse(Node node) {
    if (node.value != null) {
      currentSpans.add(node.className == null
          ? TextSpan(text: node.value)
          : TextSpan(text: node.value, style: syntaxTheme[node.className!]));
    } else if (node.children != null) {
      List<TextSpan> tmp = [];
      currentSpans
          .add(TextSpan(children: tmp, style: syntaxTheme[node.className!]));
      stack.add(currentSpans);
      currentSpans = tmp;

      node.children!.forEach((n) {
        _traverse(n);
        if (n == node.children!.last) {
          currentSpans = stack.isEmpty ? spans : stack.removeLast();
        }
      });
    }
  }

  for (var node in nodes) {
    _traverse(node);
  }

  return spans;
}
