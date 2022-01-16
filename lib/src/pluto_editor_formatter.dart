import 'package:flutter/services.dart';

class PlutoEditorFormatter extends TextInputFormatter {
  final void Function(bool) onNewLine;

  PlutoEditorFormatter(this.onNewLine);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    PressedKey pressedKey = KeyboardUtilz.getPressedKey(oldValue, newValue);
    if (pressedKey == PressedKey.enter) {
      newValue = newValue.copyWith(text: newValue.text.replaceAll('\n', ''));
      String lastChar = '';
      if (newValue.text.length > 1) {
        lastChar = newValue.text
            .substring(newValue.text.length - 1, newValue.text.length);
      }
      onNewLine(lastChar == ":");
    }

    return newValue;
  }
}

class KeyboardUtilz {
  /// Check and see if last pressed key was enter key.
  /// This is checked by looking if the last character text == "\n".
  static PressedKey getPressedKey(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == "\n") {
      return PressedKey.enter;
    }

    final TextSelection newSelection = newValue.selection;
    final TextSelection currentSelection = oldValue.selection;

    if (currentSelection.baseOffset > newSelection.baseOffset) {
      //backspace was pressed
      return PressedKey.backSpace;
    }

    var lastChar = newValue.text
        .substring(currentSelection.baseOffset, newSelection.baseOffset);

    return lastChar == "\n" ? PressedKey.enter : PressedKey.regular;
  }
}

enum PressedKey { enter, backSpace, regular }
