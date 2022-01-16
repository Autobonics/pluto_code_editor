// import 'package:flutter/material.dart';
// import 'package:pluto_code_editor/pluto_code_editor.dart';
// import 'package:pluto_code_editor/src/editor_theme.dart';

// class BonicPythonSyntaxHighlighter implements SyntaxHighlighterBase {
//   final EditorTheme editorTheme;

//   BonicPythonSyntaxHighlighter({this.editorTheme = const EditorTheme()});

//   @override
//   List<TextSpan> parseText(TextEditingValue tev) {
//     var texts = tev.text.split(' ');

//     var lsSpans = <TextSpan>[];
//     for (int i = 0; i < texts.length; i++) {
//       var originalText = texts[i];
//       var text = originalText.replaceAll('\n', '');

//       //TODO -> Add regular expressions to seperate keywords from special charactors

//       // text = text.replaceAll(':', '');
//       // text = text.replaceAll(")", "");
//       // text = text.replaceAll("(", "");
//       if (keywords1.contains(text)) {
//         lsSpans.add(TextSpan(
//             text: originalText,
//             style: TextStyle(color: editorTheme.keyword1Color)));
//       } else if (keywords2.contains(text)) {
//         lsSpans.add(TextSpan(
//             text: originalText,
//             style: TextStyle(color: editorTheme.keyword2Color)));
//       } else if (keywords3.contains(text)) {
//         lsSpans.add(TextSpan(
//             text: originalText,
//             style: TextStyle(color: editorTheme.keyword3Color)));
//       } else {
//         lsSpans.add(TextSpan(
//             text: originalText,
//             style: TextStyle(color: editorTheme.textColor)));
//       }
//       lsSpans.add(
//           TextSpan(text: ' ', style: TextStyle(color: editorTheme.textColor)));
//     }
//     return lsSpans;
//   }

//   @override
//   List<String> keywords1 = [
//     "class",
//     "def",
//     "and",
//     "is",
//     "global",
//     "in",
//     "True",
//     "False",
//     "not",
//     "or",
//     "lambda",
//     "NotImplemented",
//     "None",
//   ];

//   @override
//   List<String> keywords2 = [
//     "elif",
//     "as",
//     "if",
//     "from",
//     "raise",
//     "for",
//     "except",
//     "finally",
//     "import",
//     "pass",
//     "return",
//     "else",
//     "break",
//     "with",
//     "asset",
//     "yield",
//     "try",
//     "while",
//     "continue",
//     "del",
//     "async",
//     "await",
//     "nonlocal"
//   ];

//   @override
//   List<String> keywords3 = [
//     "print",
//     "exec",
//   ];
// }
