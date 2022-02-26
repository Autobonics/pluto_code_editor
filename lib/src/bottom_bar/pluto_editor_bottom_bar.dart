import 'package:flutter/material.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';
import 'package:pluto_code_editor/src/bottom_bar/pluto_bottom_bar_key_card.dart';

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
                physics: const BouncingScrollPhysics(),
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
              backgroundColor: widget.controller.theme.mainColor,
              child: Icon(
                  widget.controller.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () {
                if (widget.controller.isPlaying) {
                  widget.controller.isPlaying = false;
                  setState(() {});
                  widget.onPause();
                } else {
                  widget.controller.isPlaying = true;
                  setState(() {});
                  Scaffold.of(context).openEndDrawer();
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
