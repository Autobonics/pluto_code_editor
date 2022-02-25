import 'package:flutter/services.dart';

class PlutoEditorFormatter extends TextInputFormatter {
  final void Function(String text) onNewLine;
  final LineIndentationController _indentationController;

  PlutoEditorFormatter(this.onNewLine, this._indentationController);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    PressedKey pressedKey = KeyboardUtilz.getPressedKey(oldValue, newValue);
    if (pressedKey == PressedKey.enter) {
      int offset = oldValue.selection.baseOffset;
      String prefixText = oldValue.text.substring(0, offset);
      String suffixText = oldValue.text.substring(offset);
      newValue = TextEditingValue(text: prefixText);
      String lastChar = '';
      String trimmedVal = newValue.text.trimLeft();
      if (trimmedVal.length > 1) {
        lastChar =
            trimmedVal.substring(trimmedVal.length - 1, trimmedVal.length);
      }
      _indentationController.currentOffset =
          newValue.text.length - trimmedVal.length + (lastChar == ":" ? 2 : 0);

      onNewLine(suffixText);
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

class LineIndentationController {
  int currentOffset;

  LineIndentationController() : currentOffset = 0;
}
