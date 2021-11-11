import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';

class AugmentedFaces extends StatefulWidget {
  @override
  _AugmentedFacesState createState() => _AugmentedFacesState();
}

class _AugmentedFacesState extends State<AugmentedFaces> {
  ArCoreFaceController arCoreController;

  whenArCoreViewCreated(ArCoreFaceController arController) {
    arCoreController = arController;

    // load mesh
    loadMesh();
  }

  loadMesh() async {
    final ByteData textureBytes =
        await rootBundle.load("assets/fox_face_mesh_texture.png");
    arCoreController.loadMesh(
        textureBytes: textureBytes.buffer.asUint8List(),
        skin3DModelFilename: "fox_face.sfb");
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Augmented Faces"),
        centerTitle: true,
      ),
      body: ArCoreFaceView(
        onArCoreViewCreated: whenArCoreViewCreated,
        enableAugmentedFaces: true,
      ),
    );
  }
}
