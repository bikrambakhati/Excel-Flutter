import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Excel(),
    );
  }
}

class Excel extends StatefulWidget {
  const Excel({Key? key}) : super(key: key);

  @override
  State<Excel> createState() => _ExcelState();
}

class _ExcelState extends State<Excel> {
  List<ScrollController> controllers = [];
  TextEditingController textEditingController = TextEditingController();
  int? activeRowIndex;
  int? activeColumnIndex;
  bool isEditing = false;
  bool isHighlighted = false;
  Map<String, String> cellValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (dg) {
          controllers.where((element) => element.hasClients).forEach((element) {
            element.jumpTo(element.position.pixels - dg.delta.dx);
          });
        },
        // onVerticalDragUpdate: (details) => controllers
        //     .where((element) => element.hasClients)
        //     .forEach((element) {
        //   element.jumpTo(element.position.pixels - details.delta.dy);
        // }),
        child: ListView.builder(itemBuilder: (context, columnIndex) {
          ScrollController controller = ScrollController(
            initialScrollOffset: controllers.lastOrNull?.offset ?? 0,
          );
          controllers.add(controller);
          return SizedBox(
            height: 30,
            child: ListView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, rowIndex) {
                String cellKey = '$rowIndex-$columnIndex';
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (!isHighlighted) {
                        isHighlighted = true;
                      } else {
                        isEditing = !isEditing;
                        textEditingController.clear();
                      }

                      activeRowIndex = rowIndex;
                      activeColumnIndex = columnIndex;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: (activeRowIndex == rowIndex &&
                                activeColumnIndex == columnIndex &&
                                isHighlighted)
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                    child: isEditing &&
                            activeRowIndex == rowIndex &&
                            activeColumnIndex == columnIndex
                        ? TextField(
                            controller: textEditingController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                cellValues[cellKey] = value;
                              });
                            },
                          )
                        : Text(cellValues[cellKey] ?? ''),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
    textEditingController.dispose();
    super.dispose();
  }
}
