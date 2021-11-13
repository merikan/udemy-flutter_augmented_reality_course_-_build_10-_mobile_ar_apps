import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARQuotes extends StatefulWidget {
  @override
  _ARQuotesState createState() => _ARQuotesState();
}

class _ARQuotesState extends State<ARQuotes> {
  ArCoreController arCoreController;

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Image Object"),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _whenArCoreViewCreated,
          enableTapRecognizer: true,
        ));
  }

  void _whenArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addQuoteImage(hit);
  }

  Future _addQuoteImage(ArCoreHitTestResult hit) async {
    final bytes =
        (await rootBundle.load("assets/kent_beck.jpg")).buffer.asUint8List();
    final imageQuote = ArCoreNode(
      image: ArCoreImage(bytes: bytes, width: 400, height: 400),
      position: hit.pose.translation + vector.Vector3(0.0, 0.0, 0.0),
      rotation: hit.pose.rotation + vector.Vector4(0.0, 0.0, 0.0, 0.0),
    );

    arCoreController.addArCoreNodeWithAnchor(imageQuote);
  }
}
