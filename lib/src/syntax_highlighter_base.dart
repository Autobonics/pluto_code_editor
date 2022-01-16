import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

// This is the interface that must be implemented
abstract class SyntaxHighlighterBase {
  /// Generates syntax highglighted text as list of `TextSpan` object.
  List<TextSpan> parseText(TextEditingValue tev);
}
