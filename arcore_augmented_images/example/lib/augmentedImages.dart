import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';

class AugmentedImages extends StatefulWidget {
  @override
  _AugmentedImagesState createState() => _AugmentedImagesState();
}

class _AugmentedImagesState extends State<AugmentedImages> {
  ArCoreController arCoreController;
  Map<int, ArCoreAugmentedImage> augmentedImageMap = Map();

  whenArCoreViewCreated(ArCoreController arController) {
    arCoreController = arController;
    arCoreController.onTrackingImage = controlOnTrackingImage;

    // load single image
    loadSingleImage();
  }

  loadSingleImage() async {
    final ByteData bytes =
        await rootBundle.load("assets/earth_augmented_image.jpg");
    arCoreController.loadSingleAugmentedImage(
        bytes: bytes.buffer.asUint8List());
  }

  controlOnTrackingImage(ArCoreAugmentedImage augmentedImage) {
    if (!augmentedImageMap.containsKey(augmentedImage.index)) {
      augmentedImageMap[augmentedImage.index] = augmentedImage;
    }
    addSphere(augmentedImage);
  }

  Future addSphere(ArCoreAugmentedImage augmentedImage) async {
    final ByteData textureBytes = await rootBundle.load("assets/earth.jpg");
    final material = ArCoreMaterial(
        color: Color.fromARGB(120, 66, 134, 244),
        textureBytes: textureBytes.buffer.asUint8List());
    final sphere = ArCoreSphere(
      materials: [material],
      radius: augmentedImage.extentX / 2,
    );
    final node = ArCoreNode(
      shape: sphere,
    );
    arCoreController.addArCoreNodeToAugmentedImage(node, augmentedImage.index);
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
        title: Text("Augmented Images"),
        centerTitle: true,
      ),
      body: ArCoreView(
        onArCoreViewCreated: whenArCoreViewCreated,
        type: ArCoreViewType.AUGMENTEDIMAGES,
      ),
    );
  }
}
