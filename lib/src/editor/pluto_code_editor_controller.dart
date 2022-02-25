import 'package:flutter/material.dart';
import 'package:pluto_code_editor/src/editor/editor_theme.dart';
import 'package:pluto_code_editor/src/editor/pluto_editor_formatter.dart';
import 'package:pluto_code_editor/src/editor/pluto_editor_line_controller.dart';

class PlutoCodeEditorController extends ValueNotifier {
  final List<PlutoEditorLineController> controllers;
  int currentFocus;
  final EditorTheme theme;
  final String language;
  final String? code;
  final LineIndentationController indentationController;
  bool isPlaying;

  PlutoCodeEditorController({
    EditorTheme? theme,
    this.language = 'bonicpython',
    this.code,
  })  : controllers = <PlutoEditorLineController>[],
        currentFocus = 0,
        this.theme = theme ?? EditorTheme(),
        indentationController = LineIndentationController(),
        isPlaying = false,
        super(1);

  void addCharacter(String char) {
    controllers[currentFocus].textEditingController.text += char;
    notifyListeners();
  }

  String get getCode {
    String code = '';
    for (var element in controllers) {
      code += element.textEditingController.text;
      code += '\n';
    }
    return code;
  }

  void setControllers(String code) {
    List<String> lines = code.split('\n');
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      controllers.add(
        PlutoEditorLineController(
          text: line,
          editorTheme: theme,
          language: language,
          listner: () => currentFocus = i,
        ),
      );
    }
    notifyListeners();
  }

  void setInitCode() {
    String _code = '''
import pluto

def main(process):
  button = pluto.Button()
  led = pluto.Led()
  while (not process.end):
    if button.get_val():
      led.set_color_hex('#0000ff')
    else :
      led.set_color_hex('#cc0000')

''';
    setControllers(code ?? _code);
  }

  PlutoEditorLineController getNewLineController(int setfoucsTo, String text) {
    int offset = indentationController.currentOffset;
    PlutoEditorLineController lineController = PlutoEditorLineController(
      text: " " * offset + text,
      editorTheme: theme,
      language: language,
      listner: () => currentFocus = setfoucsTo,
    );
    lineController.textEditingController.selection =
        TextSelection.fromPosition(TextPosition(offset: offset));

    return lineController;
  }

  void clear(BuildContext context) {
    controllers.clear();
    controllers.add(getNewLineController(0, ''));
    FocusScope.of(context).unfocus();
    notifyListeners();
  }
}
