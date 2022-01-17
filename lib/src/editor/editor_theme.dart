import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/darcula.dart';

class EditorTheme {
  late Color backgroundColor;
  late Color fontColor;
  late Color dividerLineColor;
  final String fontFamily;
  late Map<String, TextStyle> syntaxTheme;
  late TextStyle lineNumberStyle;
  late Color mainColor;

  static const _defaultFontColor = Color(0xff000000);
  static const defaultBackgroundColor = Color(0xffffffff);
  static const _defaultFontFamily = 'monospace';
  static const _defaultLineNumberStyle = TextStyle(color: Colors.grey);

  EditorTheme({
    this.fontFamily = _defaultFontFamily,
    Color? fontColor,
    Map<String, TextStyle>? syntaxTheme,
    Color? dividerLineColor,
    Color? backgroundColor,
    TextStyle? lineNumberStyle,
    this.mainColor = const Color(0xff0088CC),
  }) {
    this.syntaxTheme = syntaxTheme ?? darculaTheme;
    this.dividerLineColor =
        dividerLineColor ?? this.syntaxTheme['symbol']?.color ?? Colors.grey;
    this.backgroundColor = backgroundColor ??
        this.syntaxTheme['root']?.backgroundColor ??
        defaultBackgroundColor;
    this.fontColor =
        fontColor ?? this.syntaxTheme['root']?.color ?? _defaultFontColor;
    this.lineNumberStyle = lineNumberStyle ??
        this.syntaxTheme['bullet'] ??
        _defaultLineNumberStyle;
  }
}
