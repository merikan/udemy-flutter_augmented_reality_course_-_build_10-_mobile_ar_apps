import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vector;

class Matrix3DRendering extends StatefulWidget {

  @override
  _Matrix3DRenderingState createState() => _Matrix3DRenderingState();
}

class _Matrix3DRenderingState extends State<Matrix3DRendering> {

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
          title: Text("3D Matrix"),
          centerTitle: true,
        ),
        body: ArCoreView(
          onArCoreViewCreated: _whenArCoreCreated,
          enableTapRecognizer: true,
        ),
      ),
    );
  }

  void _whenArCoreCreated(ArCoreController controller) {
    arCoreController = controller;

    arCoreController.onNodeTap = (name) => _onTapHandler(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  _onTapHandler(String name) {
    print("Flutter: onNodeTap");
    showDialog(context: context,
              builder: (BuildContext context) => AlertDialog(content: Text("onNodeTap on $name"),),
    );
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addMatrix3D(arCoreController, hit);
  }

  void _addMatrix3D(ArCoreController arCoreController, ArCoreHitTestResult hit) {
    final List<ArCoreNode> list = [];
    for (var i = 0; i < 8; i++) {
      for (var j = 0; j < 8; j++) {
        list.add(_createNode(_createCube(), i, j));
      }
    }

    var node = ArCoreNode(
      shape: null,
      position: hit.pose.translation + vector.Vector3(0.0,0.5,0.0),
      rotation: hit.pose.rotation,
      children: list,
    );

    arCoreController.addArCoreNodeWithAnchor(node);

  }

  ArCoreCube _createCube() {
    final material = ArCoreMaterial(
      color: Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255),),
      metallic: 1.0,
    );
    final cube = ArCoreCube(
      materials: [material],
      size: vector.Vector3(0.1, 0.1 ,0.1),
    );
    return cube;
  }

  ArCoreNode _createNode(ArCoreCube shape, int i, int j) {
    var cubeNode = ArCoreNode(
      shape: shape,
      position: vector.Vector3(0.1 * j, 0.0, -0.01 * i),
    );

    return cubeNode;
  }

}


