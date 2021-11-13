import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class Object3DScreen extends StatefulWidget {
  @override
  _Object3DScreenState createState() => _Object3DScreenState();
}

class _Object3DScreenState extends State<Object3DScreen> {
  ArCoreController arCoreController;
  String objectSelected;

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("3D Object"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _whenArCoreViewCreated,
            enableTapRecognizer: true,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: ListObjectSelection(
              onTap: (value) {
                objectSelected = value;
              },
            ),
          )
        ],
      ),
    );
  }

  void _whenArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => _removeObject(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _add3DObject(hit);
  }

  void _add3DObject(ArCoreHitTestResult plane) {
    if (objectSelected != null) {
      final node = ArCoreReferenceNode(
        name: objectSelected,
        object3DFileName: objectSelected,
        position: plane.pose.translation,
        rotation: plane.pose.rotation,
      );
      arCoreController.addArCoreNodeWithAnchor(node);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text("Select and image."),
        ),
      );
    }
  }

  void _removeObject(String name) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        content: Row(
          children: [
            Text("Remove $name?"),
            IconButton(
              onPressed: () {
                arCoreController.removeNode(
                  nodeName: name,
                );
                Navigator.pop(ctx);
              },
              icon: Icon(Icons.delete),
            )
          ],
        ),
      ),
    );
  }
}

// ui
class ListObjectSelection extends StatefulWidget {
  final Function onTap;
  ListObjectSelection({this.onTap});

  @override
  _ListObjectSelectionState createState() => _ListObjectSelectionState();
}

class _ListObjectSelectionState extends State<ListObjectSelection> {
  // files can be found in folder 'example/assets'
  List<String> gifs = [
    "assets/TocoToucan.gif",
    "assets/AndroidRobot.gif",
    "assets/ArcticFox.gif",
  ];

  // files can be found in folder 'example/android/app/src/main/assets'
  List<String> objectFilename = [
    "toucan.sfb",
    "andy.sfb",
    "artic_fox.fsb",
  ];

  String selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView.builder(
        itemCount: gifs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selected = gifs[index];
                widget.onTap(objectFilename[index]);
              });
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Container(
                color:
                    selected == gifs[index] ? Colors.blue : Colors.transparent,
                padding: selected == gifs[index] ? EdgeInsets.all(8.0) : null,
                child: Image.asset(gifs[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
