import 'dart:typed_data';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class CustomObject extends StatefulWidget {
  @override
  _CustomObjectState createState() => _CustomObjectState();
}

class _CustomObjectState extends State<CustomObject> {
  ArCoreController arCoreController;

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Custom Anchor Object onTap"),
          centerTitle: true,
        ),
        body: ArCoreView(
          onArCoreViewCreated: _whenArCoreViewCreated,
          enableTapRecognizer: true,
        ),
      ),
    );
  }

  void _whenArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => _onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  _onTapHandler(String name) {
    print("Flutter: onNodeTap");
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text("onNodeTap on $name"),
      ),
    );
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    var hit = hits.first;
    _addSphere(hit);
  }

  Future _addSphere(ArCoreHitTestResult hit) async {

    // create the moon
    final moonMaterial = ArCoreMaterial(
      color: Colors.grey,
    );
    final moonShape = ArCoreSphere(
      materials: [moonMaterial],
      radius: 0.03,
    );
    final moon = ArCoreNode(
      shape: moonShape,
      position: vector.Vector3(0.2, 0, 0),
      rotation: vector.Vector4(0, 0, 0, 0),
    );

  // create the earth with the moon as child
    final ByteData textureByte = await rootBundle.load("assets/earth.jpg");
    final earthMaterial = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      textureBytes: textureByte.buffer.asUint8List(),
    );
    final earthShape = ArCoreSphere(
      materials: [earthMaterial],
      radius: 0.1,
    );
    final earth = ArCoreNode(
      shape: earthShape,
      children: [moon],
      position: hit.pose.translation + vector.Vector3(0.0, 1.0, 0.0),
      rotation: hit.pose.rotation,
    );

    arCoreController.addArCoreNodeWithAnchor(earth);
  }
}
