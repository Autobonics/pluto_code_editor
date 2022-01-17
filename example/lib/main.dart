import 'package:flutter/material.dart';
import 'package:pluto_code_editor/pluto_code_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pluto Code Editor Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PlutoCodeEditorDemo(),
    );
  }
}

class PlutoCodeEditorDemo extends StatefulWidget {
  const PlutoCodeEditorDemo({Key? key}) : super(key: key);

  @override
  _PlutoCodeEditorDemoState createState() => _PlutoCodeEditorDemoState();
}

class _PlutoCodeEditorDemoState extends State<PlutoCodeEditorDemo> {
  PlutoCodeEditorController controller = PlutoCodeEditorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PlutoCodeEditor(
          controller: controller,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 75,
        // color: Colors.red,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        controller.addCharacter('  ');
                      },
                      child: Container(
                        width: 70,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: Container(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: FloatingActionButton(
                onPressed: () {
                  print(controller.getCode);
                  controller.setControllers('def main():\n  print("shahir")');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
