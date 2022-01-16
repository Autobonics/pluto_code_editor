import 'package:flutter/material.dart';
import 'package:pluto_code_editor/src/bonicpython.dart';
import 'package:pluto_code_editor/src/editor_theme.dart';
import 'package:highlight/highlight_core.dart' show highlight, Node;

class PlutoRichCodeEditingController extends TextEditingController {
  // SyntaxHighlighterBase syntaxHighlighter;
  final EditorTheme theme;

  PlutoRichCodeEditingController({String? text, required this.theme})
      : super(text: text);

  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
      composing: TextRange.empty,
    );
  }

  List<TextSpan> _convert(List<Node> nodes) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    _traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(node.className == null
            ? TextSpan(text: node.value)
            : TextSpan(
                text: node.value, style: theme.syntaxTheme[node.className!]));
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans.add(
            TextSpan(children: tmp, style: theme.syntaxTheme[node.className!]));
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

  static const _rootKey = 'root';

  @override
  TextSpan buildTextSpan(
      {required BuildContext context, TextStyle? style, bool? withComposing}) {
    var _textStyle = TextStyle(
      fontFamily: theme.fontFamily,
      color: theme.syntaxTheme[_rootKey]?.color ?? theme.fontColor,
    );

    // List<TextSpan> lsSpans = syntaxHighlighter.parseText(value);

    // return TextSpan(style: style, children: lsSpans);

    highlight.registerLanguage('bonicpython', bonicpython);

    return TextSpan(
      style: _textStyle,
      children:
          _convert(highlight.parse(value.text, language: 'bonicpython').nodes!),
    );

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
