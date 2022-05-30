// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:health_connector/enums/enums.dart' as enums;
import 'package:flutter/material.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/models/exercise_meta.dart';
import 'package:health_connector/models/nodes_comparator.dart';
import 'package:health_connector/screens/components/rounded_input_field.dart';
import 'package:health_connector/util/enum_utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:health_connector/util/utils.dart';
import 'package:health_connector/util/view_utils.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';
import '../services/firebase/upload_meta.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  XFile? exerciseImage;
  late Size _size;
  final List<NodesComparator> _nodesComparator = [];
  final ImagePicker _picker = ImagePicker();
  late final ScrollController _scrollController = ScrollController();

  final TextEditingController _exerciseTitleController =
      TextEditingController();

  final TextEditingController _exerciseDurationController =
      TextEditingController();

  String? _selectedIntensity = '';
  String? _selectedLocation = '';

  bool isRightPose = false;
  bool isLeftPose = false;
  bool? _isVideoAvailable = false;
  @override
  void initState() {
    super.initState();
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
              left: _size.width / 16,
              right: _size.width / 16,
            ),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(top: _size.height / 32),
                child: SizedBox(
                  width: _size.width,
                  height: _size.height / 4.5,
                  child: exerciseImage == null
                      ? GestureDetector(
                          onTap: _addImage,
                          child: Container(
                            width: _size.width,
                            height: _size.height / 4.5,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(color: Colors.grey),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: Colors.grey,
                            ),
                            child: Icon(
                              Icons.image_rounded,
                              size: _size.height / 6,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Stack(
                          alignment: AlignmentDirectional.topEnd,
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(exerciseImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            GestureDetector(
                              onTap: _dropImage,
                              child: Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                                size: _size.width / 12,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _size.height / 32),
                child: RoundedInputField(
                  textEditingController: _exerciseTitleController,
                  onTap: _onTap,
                  labelText: 'Exercise Title',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: _size.height / 32),
                child: RoundedInputField(
                  textEditingController: _exerciseDurationController,
                  keyboardType: TextInputType.number,
                  onTap: _onTap,
                  labelText: 'Exercise duration',
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: _size.height / 32),
              //   child: DropdownSearch<String>(
              //     mode: Mode.BOTTOM_SHEET,
              //     showSelectedItems: true,
              //     selectedItem: _selectedIntensity,
              //     items: const ['Low', 'Medium', 'High'],
              //     label: "Intensity",
              //     onChanged: (value) =>
              //         setState(() => _selectedIntensity = value),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(top: _size.height / 32),
              //   child: DropdownSearch<String>(
              //     mode: Mode.BOTTOM_SHEET,
              //     showSelectedItems: true,
              //     selectedItem: _selectedLocation,
              //     items: const ['Indoor', 'Outdoor', 'Indoor/Outdoor'],
              //     label: "Location",
              //     onChanged: (value) =>
              //         setState(() => _selectedLocation = value),
              //   ),
              // ),
              CheckboxListTile(
                title: const Text("Is video available"),
                activeColor: Constants.primaryColor,
                value: _isVideoAvailable,
                enableFeedback: true,
                onChanged: (newValue) =>
                    setState(() => _isVideoAvailable = newValue),
              ),
              CheckboxListTile(
                title: const Text("Is Right Pose"),
                activeColor: Constants.primaryColor,
                value: isRightPose,
                enableFeedback: true,
                onChanged: (newValue) => setState(
                  () {
                    isRightPose = newValue ?? false;
                    isLeftPose = !isRightPose;
                  },
                ),
              ),
              CheckboxListTile(
                title: const Text("Is Left Pose"),
                activeColor: Constants.primaryColor,
                value: isLeftPose,
                enableFeedback: true,
                onChanged: (newValue) => setState(() {
                  isLeftPose = newValue ?? false;
                  isRightPose = !isLeftPose;
                }),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _nodesComparator.length,
                itemBuilder: (context, index) =>
                    _nodeComaprison(_nodesComparator[index], index),
              ),
              GestureDetector(
                  onTap: _onAddComparisonNode,
                  child: const Icon(Icons.add_circle,
                      color: Colors.green, size: 48)),
              SizedBox(height: _size.height / 16),
              ElevatedButton(
                  onPressed: _saveExercise, child: const Text('Save')),
              const SizedBox(height: 800),
            ])));
  }

  _addImage() => _picker
      .pickImage(source: ImageSource.gallery)
      .then((value) => setState((() => exerciseImage = value)));

  _onAddComparisonNode() {
    setState(() {
      if (_nodesComparator.isEmpty) {
        _nodesComparator.add(NodesComparator());
      } else if (_nodesComparator
          .where((element) =>
              element.greaterLandmark == null ||
              element.smallerLandmark == null ||
              element.axis == null)
          .isNotEmpty) {
        Constants.showMessage(context, 'Please complete previous node');
      } else {
        _nodesComparator.add(NodesComparator());
      }
    });
    // _scrollController.animateTo(
    //     _scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 100),
    //     curve: Curves.easeIn);
  }

  _dropImage() => setState(() => exerciseImage = null);

  _onTap() {
    Logger.debug('Tap Event occurred');
  }

  _saveExercise() {
    if (_validateExercise()) {
      Map<String, dynamic> poseData = {};
      int i = 0;
      for (var element in _nodesComparator) {
        poseData.addAll({'$i': element.toJson()});
        i++;
      }
      // print(poseData);

      ExerciseMeta metaData = ExerciseMeta(
        _exerciseTitleController.text,
        int.parse(_exerciseDurationController.text),
        _selectedIntensity!,
        _selectedLocation!,
        exerciseImage!.path,
        Utils.getBlurHash(exerciseImage!.path),
        true, // "TODO",
        _isVideoAvailable ?? false,
        [poseData],
        0,
        '',
      );

      Logger.info(metaData.toMap());

      ViewUtils.popup(const Center(child: CircularProgressIndicator()),
          const Center(child: Text("Uploading exercise")), context);

      UploadMeta.upload(metaData).then((isUploaded) {
        if (isUploaded) {
          Constants.showMessage(
              context, "New Exercise ${metaData.title} uploaded successfully");
        } else {
          Constants.showMessage(
              context, "Uploading exercise ${metaData.title} failed");
        }
        ViewUtils.pop(context);
      });
    }
  }

  bool _validateExercise() {
    try {
      if (exerciseImage == null) {
        Constants.showMessage(context, "Please select image for exercise");
        return false;
      }
      if (_exerciseTitleController.text.isEmpty) {
        Constants.showMessage(context, "Please add title for exercise");
        return false;
      }
      if (_exerciseDurationController.text.isEmpty) {
        Constants.showMessage(context, "Please add duration for exercise");
        return false;
      }
      if (_selectedIntensity == null || _selectedIntensity!.isEmpty) {
        Constants.showMessage(context, "Please add intensity for exercise");
        return false;
      }
      if (_selectedLocation == null || _selectedLocation!.isEmpty) {
        Constants.showMessage(context, "Please add location for exercise");
        return false;
      }
      if (isRightPose == false && isLeftPose == false) {
        Constants.showMessage(context, "Please select pose direction");
        return false;
      }
      if (_nodesComparator.isEmpty) {
        Constants.showMessage(context, "Please add pose estimation data");
        return false;
      }
      for (var node in _nodesComparator) {
        if (node.axis == null ||
            node.greaterLandmark == null ||
            node.smallerLandmark == null) {
          Constants.showMessage(context, "Please fill all fields of last node");
          return false;
        }
      }
    } catch (error) {
      return false;
    }
    return true;
  }

  Widget _nodeComaprison(NodesComparator node, int index) => SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Flexible(
            //   child: DropdownSearch<String>(
            //     mode: Mode.BOTTOM_SHEET,
            //     showSelectedItems: true,
            //     selectedItem: node.axis != null
            //         ? Utils.splitListBySeperatorAsList([node.axis], '.')[0]
            //         : '',
            //     items: Utils.splitListBySeperatorAsList(enums.Axis.values, '.'),
            //     label: "Axis",
            //     onChanged: (value) => _onAxisSelect(value!, index),
            //   ),
            // ),
            // Flexible(
            //   child: DropdownSearch<String>(
            //     showSearchBox: true,
            //     mode: Mode.BOTTOM_SHEET,
            //     showSelectedItems: true,
            //     selectedItem: node.greaterLandmark != null
            //         ? Utils.splitListBySeperatorAsList(
            //             [node.greaterLandmark], '.')[0]
            //         : '',
            //     items: Utils.splitListBySeperatorAsList(
            //         PoseLandmarkType.values, '.'),
            //     label: "Greater",
            //     onChanged: (value) => _onLandmarkSelect(value!, true, index),
            //   ),
            // ),
            const Flexible(
              child: Text('>'),
            ),
            // Flexible(
            //   child: DropdownSearch<String>(
            //     mode: Mode.MENU,
            //     showSearchBox: true,
            //     showSelectedItems: true,
            //     selectedItem: node.smallerLandmark != null
            //         ? Utils.splitListBySeperatorAsList(
            //             [node.smallerLandmark], '.')[0]
            //         : '',
            //     items: Utils.splitListBySeperatorAsList(
            //         PoseLandmarkType.values, '.'),
            //     label: "Smaller",
            //     onChanged: (value) => _onLandmarkSelect(value!, false, index),
            //   ),
            // ),
            GestureDetector(
              onTap: () => _onComparisonRemoved(node),
              child: const Icon(Icons.remove_circle, color: Colors.red),
            ),
          ],
        ),
      );

  _onLandmarkSelect(String landmark, bool isFirst, int index) {
    isFirst
        ? _nodesComparator[index].greaterLandmark =
            EnumUtils.toEnum(landmark, PoseLandmarkType.values, true)!
        : _nodesComparator[index].smallerLandmark =
            EnumUtils.toEnum(landmark, PoseLandmarkType.values, true)!;
    setState(() {});
  }

  _onAxisSelect(String axis, int index) {
    Logger.info('axis = $axis ');
    setState(() {
      _nodesComparator[index].axis =
          EnumUtils.toEnum(axis, enums.Axis.values, true)!;
    });
  }

  _onComparisonRemoved(NodesComparator node) {
    setState(() => _nodesComparator.remove(node));
  }
}
