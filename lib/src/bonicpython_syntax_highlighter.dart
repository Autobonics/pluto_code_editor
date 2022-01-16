import 'package:flutter/material.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';

class BonicPythonSyntaxHighlighter implements SyntaxHighlighterBase {
  @override
  List<TextSpan> parseText(TextEditingValue tev) {
    var texts = tev.text.split(' ');

    var lsSpans = <TextSpan>[];
    for (int i = 0; i < texts.length; i++) {
      var originalText = texts[i];
      var text = originalText.replaceAll('\n', '');
      text = originalText.replaceAll(':', '');
      if (text == 'class') {
        lsSpans.add(TextSpan(
            text: originalText, style: TextStyle(color: Colors.green)));
      } else if (text == 'if' || text == 'else' || text == 'elif') {
        lsSpans.add(
            TextSpan(text: originalText, style: TextStyle(color: Colors.blue)));
      } else if (text == 'return') {
        lsSpans.add(
            TextSpan(text: originalText, style: TextStyle(color: Colors.red)));
      } else if (text == 'print') {
        lsSpans.add(TextSpan(
            text: originalText, style: TextStyle(color: Colors.purple)));
      } else {
        lsSpans.add(TextSpan(
            text: originalText, style: TextStyle(color: Colors.black)));
      }
      lsSpans.add(TextSpan(text: ' ', style: TextStyle(color: Colors.black)));
    }
    return lsSpans;
  }
}
