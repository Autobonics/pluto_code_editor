import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';

class PlutoOutputViewer extends StatefulWidget {
  final Stream? output;
  final PlutoCodeEditorController controller;
  final Color? headerBakgroundColor;
  const PlutoOutputViewer({
    Key? key,
    required this.output,
    required this.controller,
    this.headerBakgroundColor,
  }) : super(key: key);

  @override
  _PlutoOutputViewerState createState() => _PlutoOutputViewerState();
}

class _PlutoOutputViewerState extends State<PlutoOutputViewer> {
  StreamSubscription? subscription;
  bool _needsScroll = false;
  late ScrollController _scrollController;
  String outPut = '';

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
      return SingleChildScrollView(
        controller: _scrollController,
        child: SizedBox(
          width: double.maxFinite,
          child: Text(
            outPut,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
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

    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToEnd());

    return Container(
      color: widget.controller.theme.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getHeader(),
          const SizedBox(height: 10),
          Expanded(child: _getOutputs()),
        ],
      ),
    );
  }
}
