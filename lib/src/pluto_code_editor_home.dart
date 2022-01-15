import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';
import 'package:pluto_code_editor/src/bonicpython_syntax_highlight.dart';

class PlutoCodeEditorHome extends StatefulWidget {
  final SyntaxHighlighterBase? syntaxHighlighter;

  const PlutoCodeEditorHome({
    Key? key,
    this.syntaxHighlighter,
  }) : super(key: key);

  @override
  _PlutoCodeEditorHomeState createState() => _PlutoCodeEditorHomeState();
}

class _PlutoCodeEditorHomeState extends State<PlutoCodeEditorHome> {
  late SyntaxHighlighterBase _syntaxHighlighter;

  final List<EditorLineController> _controllers = <EditorLineController>[];

  @override
  void initState() {
    _syntaxHighlighter =
        widget.syntaxHighlighter ?? BonicPythonSyntaxHighlighter();
    _controllers.add(EditorLineController(_syntaxHighlighter));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: _controllers.length,
          itemBuilder: (context, index) {
            return EditorLine(
              controller: _controllers[index],
              lineNumber: index + 1,
              onNextPressed: () async {
                print("on next pressed");
                EditorLineController controller =
                    EditorLineController(_syntaxHighlighter);
                _controllers.insert(index + 1, controller);
                setState(() {});
                await Future.delayed(Duration(milliseconds: 100));
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(controller.focusNode);
              },
            );
          },
        ),
      ),
    );
  }
}

class EditorLine extends StatefulWidget {
  final EditorLineController controller;
  final VoidCallback onNextPressed;
  final int lineNumber;

  const EditorLine({
    Key? key,
    required this.controller,
    required this.lineNumber,
    required this.onNextPressed,
  }) : super(key: key);

  @override
  _EditorLineState createState() => _EditorLineState();
}

class _EditorLineState extends State<EditorLine> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: Colors.grey,
          child: Center(child: Text(widget.lineNumber.toString())),
        ),
        Expanded(
            child: MyEditableText(
          controller: widget.controller.textEditingController,
          focusNode: widget.controller.focusNode,
        )
            // child: TextField(
            //   decoration: null,
            //   autocorrect: false,
            //   // keyboardType: TextInputType.multiline,
            //   autofocus: true,
            //   inputFormatters: [Formatter()],
            //   // maxLines: 100,
            //   focusNode: widget.controller.focusNode,
            //   controller: widget.controller.textEditingController,
            //   onEditingComplete: () => widget.onNextPressed(),
            //   onSubmitted: (val) => print('on submit pressed'),

            //   textInputAction: TextInputAction.newline,
            //   onChanged: (val) {
            //     // _pressedKey = KeyboardUtilz.getPressedKey(_value, value);
            //     print("on chnaged pressed");
            //     print(val);
            //     if (val.contains('\n')) {
            //       print(' yea baby got it');
            //     }
            //   },
            //   onTap: () => print('on tap pressed'),
            // ),
            )
      ],
    );
  }
}

class Formatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // TODO: implement formatEditUpdate
    print('old value ${oldValue.text} and new value is ${newValue.text}');
    print(KeyboardUtilz.getPressedKey(oldValue, newValue));
    return newValue;
  }
}

class EditorLineController {
  final RichCodeEditingController _controller;
  final FocusNode _focusNode;

  EditorLineController(
    SyntaxHighlighterBase syntaxHighlighter,
  )   : _controller =
            RichCodeEditingController(syntaxHighlighter: syntaxHighlighter),
        _focusNode = FocusNode();

  TextEditingController get textEditingController => _controller;

  FocusNode get focusNode => _focusNode;
}

class KeyboardUtilz {
  /// Check and see if last pressed key was enter key.
  /// This is checked by looking if the last character text == "\n".
  static PressedKey getPressedKey(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length == 1 && newValue.text == "\n") {
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

class MyEditableText extends EditableText {
  MyEditableText({
    Key? key,
    required FocusNode focusNode,
    required TextEditingController controller,
    TextStyle? style,
    Color? cursorColor,
    Color? backgroudCursorColor,
  }) : super(
          key: key,
          focusNode: focusNode,
          controller: controller,
          style: style ?? TextStyle(),
          cursorColor: cursorColor ?? Colors.black,
          backgroundCursorColor: backgroudCursorColor ?? Colors.red,
          keyboardType: TextInputType.multiline,
          // maxLines: null,
          textInputAction: TextInputAction.newline,
          onEditingComplete: () {
            print("editing completed ============");
          },
        );

  @override
  EditableTextState createState() => MyEditableTextState();
}

class MyEditableTextState extends EditableTextState {
  // TextEditingValue oldValue = TextEditingValue.empty;

  // @override
  // void updateEditingValue(TextEditingValue value) {
  //   oldValue = value;
  //   print(value.text);
  //   print(KeyboardUtilz.getPressedKey(oldValue, value));
  // }

  @override
  void performAction(TextInputAction action) {
    print(action);
    switch (action) {
      case TextInputAction.newline:
        print("newline created-------");
        break;
      default:
        print("default action");
    }
  }
}
