import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';

class PlutoOutputViewer extends StatefulWidget {
  final Stream? output;
  final PlutoCodeEditorController controller;
  final Color? headerBakgroundColor;
  final void Function(String)? onInputSend;
  const PlutoOutputViewer({
    Key? key,
    required this.output,
    required this.controller,
    this.headerBakgroundColor,
    this.onInputSend,
  }) : super(key: key);

  @override
  _PlutoOutputViewerState createState() => _PlutoOutputViewerState();
}

class _PlutoOutputViewerState extends State<PlutoOutputViewer> {
  StreamSubscription? subscription;
  bool _needsScroll = false;
  late ScrollController _scrollController;
  String outPut = '';
  String? currentInput;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    subscription = widget.output?.listen((event) {
      if (event != null && event.toString().isNotEmpty) {
        outPut += event;
        _needsScroll = true;
        int length = outPut.length;
        if (length > 1000) outPut = outPut.substring(length - 1000);
        setState(() {});
      }
    });
  }

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _getOutputs() {
      if (!widget.controller.isPlaying) {
        return const Center(
          child: Text(
            "Run the code to view output",
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SizedBox(
            width: double.maxFinite,
            child: Text(
              outPut,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    _getHeader() {
      return AppBar(
        title: const Text('Output'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor:
            widget.headerBakgroundColor ?? widget.controller.theme.mainColor,
        actions: [
          IconButton(
            onPressed: () {
              outPut = '';
              setState(() {});
            },
            icon: const Icon(Icons.clear),
          )
        ],
        elevation: 0,
      );
    }

    _getInput() {
      return Row(
        children: [
          const SizedBox(width: 10),
          const Text(
            '>>>',
            style: TextStyle(color: Colors.white38),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              onChanged: (val) {
                currentInput = val;
                setState(() {});
              },
            ),
          ),
          if (currentInput != null && currentInput!.isNotEmpty)
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  widget.controller.theme.mainColor,
                ),
              ),
              onPressed: () {
                if (currentInput != null) {
                  widget.onInputSend!(currentInput ?? '');
                }
              },
              child: const Text('send'),
            ),
          const SizedBox(width: 10),
        ],
      );
    }

    _getDivider() {
      return const Divider(
        color: Colors.white24,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());

    return Container(
      color: widget.controller.theme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getHeader(),
          // const SizedBox(height: 10),
          if (widget.onInputSend != null) _getInput(),
          if (widget.onInputSend != null) _getDivider(),
          Expanded(child: _getOutputs()),
        ],
      ),
    );
  }
}
