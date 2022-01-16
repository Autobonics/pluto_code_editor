import 'package:flutter/services.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';

class PlutoEditorFormatter extends TextInputFormatter {
  final void Function() onNewLine;
  final LineIndentationController _indentationController;
  int _currentPos;

  PlutoEditorFormatter(this.onNewLine, this._indentationController)
      : _currentPos = 0;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    PressedKey pressedKey = KeyboardUtilz.getPressedKey(oldValue, newValue);
    if (pressedKey == PressedKey.enter) {
      newValue = newValue.copyWith(text: newValue.text.replaceAll('\n', ' '));
      _currentPos += 1;
      String lastChar = '';
      String trimmedVal = newValue.text.trim();
      if (trimmedVal.length > 1) {
        lastChar =
            trimmedVal.substring(trimmedVal.length - 1, trimmedVal.length);
      }
      if (lastChar == ":") {
        _indentationController.currentIndent += 1;
        print('updated indent');
      }
      onNewLine();
    } else if (pressedKey == PressedKey.regular) {
      _currentPos += 1;
    } else if (pressedKey == PressedKey.backSpace) {
      _currentPos -= 1;

      if (_currentPos < 0) {
        _indentationController.currentIndent += (_currentPos ~/ 2);
      }
    }
    print('current pos => $_currentPos');
    print('currnet intect ->.... ${_indentationController.currentIndent}');

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
