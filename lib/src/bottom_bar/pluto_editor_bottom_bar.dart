import 'package:flutter/material.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';
import 'package:pluto_code_editor/src/editor/editor_theme.dart';

class PlutoEditorBottomBar extends StatefulWidget {
  final PlutoCodeEditorController controller;
  final Function() onCodeRun;
  final Function() onPause;
  final List<String> keys;

  const PlutoEditorBottomBar({
    Key? key,
    required this.controller,
    required this.keys,
    required this.onCodeRun,
    required this.onPause,
  }) : super(key: key);

  @override
  _PlutoEditorBottomBarState createState() => _PlutoEditorBottomBarState();
}

class _PlutoEditorBottomBarState extends State<PlutoEditorBottomBar> {
  bool isPlaying = false;

  _getTabCard() {
    return KeyCard(
      char: 'Tab',
      onTap: () {
        widget.controller.addCharacter('  ');
      },
    );
  }

  _getClearCard() {
    return KeyCard(
      char: 'Clear',
      onTap: () {
        widget.controller.clear(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 40,
              color: widget.controller.theme.syntaxTheme['comment']?.color,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.keys.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) return _getTabCard();
                  if (index == 1) return _getClearCard();
                  String char = widget.keys[index - 2];
                  return KeyCard(
                    char: char,
                    onTap: () {
                      widget.controller.addCharacter(char);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      color: Colors.white,
                      width: 1,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            child: FloatingActionButton(
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                if (isPlaying) {
                  isPlaying = false;
                  setState(() {});
                  widget.onPause();
                } else {
                  isPlaying = true;
                  setState(() {});
                  widget.onCodeRun();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class KeyCard extends StatelessWidget {
  final String char;
  final VoidCallback onTap;

  const KeyCard({
    Key? key,
    required this.char,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 70,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Center(
              child: Text(
            char,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }
}
