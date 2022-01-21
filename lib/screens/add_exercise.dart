import 'dart:io';
import 'package:health_connector/enums/enums.dart' as enums;
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/models/nodes_comparator.dart';
import 'package:health_connector/screens/components/rounded_input_field.dart';
import 'package:health_connector/screens/painters/pose_painter.dart';
import 'package:health_connector/util/enum_utils.dart';
import 'package:health_connector/util/pose_data.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:health_connector/util/utils.dart';

class AddExercise extends StatefulWidget {
  const AddExercise(
      {Key? key,
      required this.pose,
      required this.customPaint,
      required this.imagePath})
      : super(key: key);
  final Pose pose;
  final CustomPaint customPaint;
  final String imagePath;

  @override
  State<StatefulWidget> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  enums.ExerciseType? _selectedExerciseType;
  late Size _size;
  PoseData? poseData;
  List<NodesComparator> _nodesComparator = [];
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startActivity();
  }

  _startActivity() {
    poseData = PoseData.fromMap(widget.pose.landmarks);
    // widget.pose.landmarks.forEach((key, value) {
    //   if(key)
    // });
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: const Text('Add new exercise')),
        body: SingleChildScrollView(
            controller: _scrollController,
            physics: const ScrollPhysics(),
            padding: EdgeInsets.only(
                left: _size.width / 16, right: _size.width / 16),
            child: Column(children: [
              Padding(
                  padding: EdgeInsets.only(top: _size.height / 32),
                  child: _pose()),
              Padding(
                  padding: EdgeInsets.only(top: _size.height / 32),
                  child: Container(
                      width: _size.width,
                      height: _size.height / 4.5,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          color: Colors.grey),
                      child: Icon(Icons.image_rounded,
                          size: _size.height / 6, color: Colors.white))),
              Padding(
                  padding: EdgeInsets.only(top: _size.height / 32),
                  child: RoundedInputField(
                    onTap: _onTap,
                    labelText: 'Exercise Title',
                  )),
              Padding(
                  padding: EdgeInsets.only(top: _size.height / 32),
                  child: RoundedInputField(
                    onTap: _onTap,
                    labelText: 'Exercise Description',
                  )),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _nodesComparator.length,
                  itemBuilder: (context, index) =>
                      _nodeComaprison(_nodesComparator[index], index)),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _nodesComparator.add(NodesComparator(
                          PoseLandmarkType.leftAnkle,
                          PoseLandmarkType.leftAnkle,
                          PoseLandmarkType.leftAnkle,
                          enums.Axis.X));
                    });
                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeIn);
                  },
                  child: const Icon(Icons.add_circle,
                      color: Colors.green, size: 48)),
              SizedBox(height: _size.height / 16),
              ElevatedButton(
                  onPressed: _saveExercise, child: const Text('Save')),
            ])));
  }

  _onTap() {
    Logger.debug('Tap Event occurred');
  }

  _saveExercise() {
    Map<String, dynamic> map = {};
    int i = 0;
    for (var element in _nodesComparator) {
      map.addAll({'$i': element.toJson()});
      i++;
    }
    print(map);
    List<NodesComparator> newN = [];
    map.forEach((key, value) {
      newN.add(NodesComparator.fromJson(value));
    });
    print(newN);
  }

  Widget _nodeComaprison(NodesComparator node, int index) => SizedBox(
      height: 100,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Flexible(
            child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSelectedItems: true,
                selectedItem: Utils.splitListBySeperatorAsList(
                    [node.firstlandmark], '.')[0],
                items: Utils.splitListBySeperatorAsList(
                    PoseLandmarkType.values, '.'),
                label: "1st landmark",
                onChanged: (value) => _onLandmarkSelect(value!, true, index))),
        Flexible(
            child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSelectedItems: true,
                selectedItem: Utils.splitListBySeperatorAsList(
                    [node.secondLandmark], '.')[0],
                items: Utils.splitListBySeperatorAsList(
                    PoseLandmarkType.values, '.'),
                label: "2nd landmark",
                onChanged: (value) => _onLandmarkSelect(value!, false, index))),
        Flexible(
            child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSelectedItems: true,
                selectedItem:
                    Utils.splitListBySeperatorAsList([node.axis], '.')[0],
                items: Utils.splitListBySeperatorAsList(enums.Axis.values, '.'),
                label: "Axis",
                onChanged: (value) => _onAxisSelect(value!, index))),
        GestureDetector(
            onTap: () => _onComparisonRemoved(node),
            child: const Icon(Icons.remove_circle, color: Colors.red))
      ]));
  _onLandmarkSelect(String landmark, bool isFirst, int index) {
    print('landmark = $landmark ');
    setState(() {
      isFirst
          ? _nodesComparator[index].firstlandmark =
              EnumUtils.toEnum(landmark, PoseLandmarkType.values, true)!
          : _nodesComparator[index].secondLandmark =
              EnumUtils.toEnum(landmark, PoseLandmarkType.values, true)!;
    });
  }

  _onAxisSelect(String axis, int index) {
    print('axis = $axis ');
    setState(() {
      _nodesComparator[index].axis =
          EnumUtils.toEnum(axis, enums.Axis.values, true)!;
    });
  }

  _onComparisonRemoved(NodesComparator node) {
    setState(() => _nodesComparator.remove(node));
  }

// TODO(Sikander) Make container dimensions dynamic.
// Note: Dimensions should be same as camera resoultion preset
  Widget _pose() => Container(
      width: 480,
      height: 640,
      color: Colors.transparent,
      child: Stack(fit: StackFit.expand, children: <Widget>[
        Image.file(File(widget.imagePath)),
        widget.customPaint
      ]));

  CustomPaint _getSkeltonPaint(List<Pose> poses, InputImage inputImage) =>
      CustomPaint(
          painter: PosePainter(poses, const Size(480, 640),
              inputImage.inputImageData!.imageRotation, Colors.green));
}
