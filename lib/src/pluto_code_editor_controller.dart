import 'package:flutter/material.dart';
import 'package:pluto_code_editor/src/pluto_editor_line_controller.dart';

class PlutoCodeEditorController extends ValueNotifier {
  final List<PlutoEditorLineController> controllers;
  int currentFocus;

  PlutoCodeEditorController()
      : controllers = <PlutoEditorLineController>[],
        currentFocus = 0,
        super(1);

  void addCharacter(String char) {
    controllers[currentFocus].textEditingController.text += char;
    notifyListeners();
  }
}
