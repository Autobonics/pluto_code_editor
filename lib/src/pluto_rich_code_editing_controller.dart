import 'package:flutter/material.dart';
import 'package:pluto_code_editor/src/syntax_highlighter_base.dart';

class PlutoRichCodeEditingController extends TextEditingController {
  SyntaxHighlighterBase syntaxHighlighter;

  PlutoRichCodeEditingController(
      {required this.syntaxHighlighter, String? text})
      : super(text: text);

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
    List<TextSpan> lsSpans = syntaxHighlighter.parseText(value);

    return TextSpan(style: style, children: lsSpans);

    // final List<InlineSpan> children = [];
    // String patternMatched;
    // String formatText;
    // TextStyle myStyle;
    // text.splitMapJoin(
    //   pattern,
    //   onMatch: (Match match) {
    //     myStyle = map[match[0]] ??
    //         map[map.keys.firstWhere(
    //           (e) {
    //             bool ret = false;
    //             RegExp(e).allMatches(text)
    //               ..forEach((element) {
    //                 if (element.group(0) == match[0]) {
    //                   patternMatched = e;
    //                   ret = true;
    //                   return true;
    //                 }
    //               });
    //             return ret;
    //           },
    //         )];

    //     if (patternMatched == r"_(.*?)\_") {
    //       formatText = match[0].replaceAll("_", " ");
    //     } else if (patternMatched == r'\*(.*?)\*') {
    //       formatText = match[0].replaceAll("*", " ");
    //     } else if (patternMatched == "~(.*?)~") {
    //       formatText = match[0].replaceAll("~", " ");
    //     } else if (patternMatched == r'```(.*?)```') {
    //       formatText = match[0].replaceAll("```", "   ");
    //     } else {
    //       formatText = match[0];
    //     }
    //     children.add(TextSpan(
    //       text: formatText,
    //       style: style.merge(myStyle),
    //     ));
    //     return "";
    //   },
    //   onNonMatch: (String text) {
    //     children.add(TextSpan(text: text, style: style));
    //     return "";
    //   },
    // );
  }
}
