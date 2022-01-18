<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->
## Pluto Code Editor

This is a complete code editor with line number, syntax highlighting and an output window.
It is made for python programming, specifically for bonicPython which runs inside Pluto (a modular robotic kit).

![](https://github.com/Autobonics/pluto_code_editor/blob/main/assets/pluto_code_editor_demo.gif)

## Features

1) Editor with line number
2) Syntax highlighting
3) Various Themes including darcula, android_studio etc
4) Output window which listen to a stream
5) Special charectors keyboard_bar for easy coding :).


## Getting started

The Example provided is pretty much everything you need to get started.

## Usage


```dart
return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0088CC),
        elevation: 0,
        title: const Text("Pluto Code Editor"),
      ),
      endDrawer: PlutoOutputViewer(
        controller: controller,
        output: streamController.stream,
      ),
      body: PlutoCodeEditor(
        controller: controller,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: PlutoEditorBottomBar(
        controller: controller,
        keys: const [
          ':',
          '#',
          '(',
          ')',
          '[',
          ']',
          '.',
          "'",
        ],
        onCodeRun: () {
          isRunning = true;
          void showHelloWorld() async {
            if (!isRunning) return;
            streamController.sink.add("Hello world\n");
            await Future.delayed(const Duration(milliseconds: 200));
            showHelloWorld();
          }

          showHelloWorld();
        },
        onPause: () {
          isRunning = false;
        },
      ),
    );
```

## Additional information

The package is made specifically to work inside 'Pluto Code' which is an integrated platform 
for learn programming with pluto hardware. Pluto is a modular robotic kit to learn next-generation 
technology skills such as robotcs, AI, electronics and programming. Feel free to check out
    https://autobonics.com/pluto
