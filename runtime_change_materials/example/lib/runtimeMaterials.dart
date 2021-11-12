import 'package:flutter/material.dart';
import 'dart:math';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class RuntimeMaterials extends StatefulWidget {
  @override
  _RuntimeMaterialsState createState() => _RuntimeMaterialsState();
}

class _RuntimeMaterialsState extends State<RuntimeMaterials> {
  ArCoreController arCoreController;
  ArCoreNode sphereNode;

  double metallic = 0.0;
  double roughness = 0.4;
  double reflectance = 0.5;
  Color color = Colors.yellow;

  _whenArCoreViewCreated(ArCoreController coreController) async {
    arCoreController = coreController;
    _addSphere(arCoreController);
  }

  _addSphere(ArCoreController coreController) {
    final material = ArCoreMaterial(
      color: Colors.yellow,
    );
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    sphereNode = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -1.5),
    );
    arCoreController.addArCoreNode(sphereNode);
  }

  _onColorChange(Color color) {
    print("changing color");
    if (color != this.color) {
      this.color = color;
      print("changed color");
      _updateMaterials();
    }
  }

  _onMetallicChange(double metallic) {
    if (metallic != this.metallic) {
      this.metallic = metallic;
      _updateMaterials();
    }
  }

  _onReflectanceChange(double reflectance) {
    if (reflectance != this.reflectance) {
      this.reflectance = reflectance;
      _updateMaterials();
    }
  }

  _onRoughnessChange(double roughness) {
    if (roughness != this.roughness) {
      this.roughness = roughness;
      _updateMaterials();
    }
  }

  _updateMaterials() {
    debugPrint("updateMaterials");
    if (sphereNode == null) {
      return;
    }
    debugPrint("updateMaterials when sphereNode not null");
    final material = ArCoreMaterial(
      color: this.color,
      metallic: this.metallic,
      reflectance: this.reflectance,
      roughness: this.roughness,
    );
    sphereNode.shape.materials.value = [material];
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
        title: Text("Runtime Change Materials"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SphereControl(
            initialColor: color,
            initialMetallicValue: metallic,
            initialReflectanceValue: reflectance,
            initialRoughnessValue: reflectance,
            onColorChanged: _onColorChange,
            onMetallicChanged: _onMetallicChange,
            onReflectanceChanged: _onReflectanceChange,
            onRoughnessChange: _onRoughnessChange,
          ),
          Expanded(
            child: ArCoreView(
              onArCoreViewCreated: _whenArCoreViewCreated,
            ),
          ),
        ],
      ),
    );
  }
}

class SphereControl extends StatefulWidget {
  final double initialRoughnessValue;
  final double initialReflectanceValue;
  final double initialMetallicValue;
  final Color initialColor;
  final ValueChanged<double> onRoughnessChange;
  final ValueChanged<double> onReflectanceChanged;
  final ValueChanged<double> onMetallicChanged;
  final ValueChanged<Color> onColorChanged;

  const SphereControl({
    Key key,
    this.initialRoughnessValue,
    this.initialReflectanceValue,
    this.initialMetallicValue,
    this.initialColor,
    this.onRoughnessChange,
    this.onReflectanceChanged,
    this.onMetallicChanged,
    this.onColorChanged,
  }) : super(key: key);

  @override
  _SphereControlState createState() => _SphereControlState();
}

class _SphereControlState extends State<SphereControl> {
  double metallicValue;
  double roughnessValue;
  double reflectanceValue;
  Color color;

  @override
  void initState() {
    roughnessValue = widget.initialRoughnessValue;
    reflectanceValue = widget.initialReflectanceValue;
    metallicValue = widget.initialMetallicValue;
    color = widget.initialColor;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              ElevatedButton(
                child: Text("Random Color"),
                onPressed: () {
                  final newColor = Colors.accents[Random().nextInt(14)];
                  widget.onColorChanged(newColor);
                  setState(() {
                    color = newColor;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: color,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("Metallic"),
              Checkbox(
                value: metallicValue == 1.0,
                onChanged: (value) {
                  widget.onMetallicChanged(metallicValue);
                  setState(() {
                    metallicValue = value ? 1.0 : 0.0;
                  });
                },
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text("Roughness"),
              Expanded(
                child: Slider(
                  value: roughnessValue,
                  onChangeEnd: (value) {
                    roughnessValue = value;
                    widget.onRoughnessChange(roughnessValue);
                  },
                  onChanged: (double value) {
                    setState(() {
                      roughnessValue = value;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("Reflectance"),
              Expanded(
                child: Slider(
                  value: reflectanceValue,
                  divisions: 10,
                  onChangeEnd: (value) {
                    reflectanceValue = value;
                    widget.onReflectanceChanged(reflectanceValue);
                  },
                  onChanged: (double value) {
                    setState(() {
                      reflectanceValue = value;
                    });
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
