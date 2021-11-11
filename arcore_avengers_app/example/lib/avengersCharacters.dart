import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class AvengersCharacters extends StatefulWidget {

  @override
  _AvengersCharactersState createState() => _AvengersCharactersState();
}

class _AvengersCharactersState extends State<AvengersCharacters> {

  ArCoreController arController;

  void whenArCoreViewCreated(ArCoreController arCoreController) {
    arController = arCoreController;
    arController.onPlaneTap = controlOnPlaneTap;
  }

  void controlOnPlaneTap(List<ArCoreHitTestResult> hitsResult) {
     final hit = hitsResult.first;
     // adding the avangers characters
     addCharacter(hit);

  }

  void addCharacter(ArCoreHitTestResult hit) async {
    final bytes = (await rootBundle.load("assets/spiderman.png")).buffer.asUint8List();

    final characterPosition = ArCoreNode(
      image: ArCoreImage(bytes: bytes, height: 500,width: 500),
      position: hit.pose.translation + vector.Vector3(0.0,0.0,0.0),
      rotation: hit.pose.rotation + vector.Vector4(0.0,0.0,0.0,0.0),
    );

    arController.addArCoreNodeWithAnchor(characterPosition);
  }

  @override
  void dispose() {
    arController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AR Avangers"),
          centerTitle: true,
        ),
        body: ArCoreView(
          onArCoreViewCreated: whenArCoreViewCreated,
          enableTapRecognizer: true,
        ),
    );
  }
}
