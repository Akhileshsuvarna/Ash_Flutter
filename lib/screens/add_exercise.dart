import 'dart:io';
import 'package:health_connector/enums/enums.dart' as enums;
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/models/exercise_meta.dart';
import 'package:health_connector/models/nodes_comparator.dart';
import 'package:health_connector/screens/components/rounded_input_field.dart';
import 'package:health_connector/util/enum_utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:health_connector/util/utils.dart';
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
  List<NodesComparator> _nodesComparator = [];
  final ImagePicker _picker = ImagePicker();
  late final ScrollController _scrollController = ScrollController();

  final TextEditingController _exerciseTitleController =
      TextEditingController();

  final TextEditingController _exerciseDescriptionController =
      TextEditingController();

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
                  textEditingController: _exerciseDescriptionController,
                  onTap: _onTap,
                  labelText: 'Exercise Description',
                ),
              ),
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
                  onTap: () {
                    setState(() {
                      if (_nodesComparator.isEmpty) {
                        _nodesComparator.add(NodesComparator());
                      }
                      // ignore: prefer_is_empty
                      else if (_nodesComparator
                              .where((element) =>
                                  element.firstlandmark == null ||
                                  element.isFirstGreater == null ||
                                  element.secondLandmark == null ||
                                  element.axis == null)
                              .length >
                          0) {
                        Constants.showMessage(
                            context, 'Please complete previous node');
                      } else {
                        _nodesComparator.add(NodesComparator());
                      }
                    });
                    // _scrollController.animateTo(
                    //     _scrollController.position.maxScrollExtent,
                    //     duration: const Duration(milliseconds: 100),
                    //     curve: Curves.easeIn);
                  },
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
        _exerciseDescriptionController.text,
        exerciseImage!.path,
        Utils.getBlurHash(exerciseImage!.path),
        true, // "TODO",
        _isVideoAvailable ?? false,
        poseData,
      );

      Logger.info(metaData.toMap());

      UploadMeta.upload(metaData).then((isUploaded) {
        if (isUploaded) {
          Constants.showMessage(
              context, "New Exercise ${metaData.title} uploaded successfully");
        } else {
          Constants.showMessage(
              context, "Uploading exercise ${metaData.title} failed");
        }
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
      if (_exerciseDescriptionController.text.isEmpty) {
        Constants.showMessage(context, "Please add description for exercise");
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
            node.firstlandmark == null ||
            node.isFirstGreater == null ||
            node.secondLandmark == null) {
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
            Flexible(
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSelectedItems: true,
                selectedItem: node.axis != null
                    ? Utils.splitListBySeperatorAsList([node.axis], '.')[0]
                    : 'select axis',
                items: Utils.splitListBySeperatorAsList(enums.Axis.values, '.'),
                label: "Axis",
                onChanged: (value) => _onAxisSelect(value!, index),
              ),
            ),
            Flexible(
              child: DropdownSearch<String>(
                showSearchBox: true,
                mode: Mode.MENU,
                showSelectedItems: true,
                selectedItem: node.firstlandmark != null
                    ? Utils.splitListBySeperatorAsList(
                        [node.firstlandmark], '.')[0]
                    : 'select landmark',
                items: node.axis != null
                    ? Utils.splitListBySeperatorAsList(
                        PoseLandmarkType.values, '.')
                    : ['Please select Axis'],
                label: "1st landmark",
                onChanged: (value) => _onLandmarkSelect(value!, true, index),
              ),
            ),
            Flexible(
              child: DropdownSearch<String>(
                showSearchBox: true,
                mode: Mode.MENU,
                showSelectedItems: true,
                selectedItem: node.isFirstGreater != null
                    ? node.isFirstGreater!
                        ? '>'
                        : '<'
                    : 'select greater node',
                items: const ['>', '<'],
                label: "comparison",
                onChanged: (value) => _onCompare(value ?? '?', index),
              ),
            ),
            Flexible(
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                showSearchBox: true,
                showSelectedItems: true,
                selectedItem: node.secondLandmark != null
                    ? Utils.splitListBySeperatorAsList(
                        [node.secondLandmark], '.')[0]
                    : 'select landmark',
                items: Utils.splitListBySeperatorAsList(
                    PoseLandmarkType.values, '.'),
                label: "2nd landmark",
                onChanged: (value) => _onLandmarkSelect(value!, false, index),
              ),
            ),
            GestureDetector(
              onTap: () => _onComparisonRemoved(node),
              child: const Icon(Icons.remove_circle, color: Colors.red),
            ),
          ],
        ),
      );

  _onCompare(String symbol, int index) {
    if (symbol == '>') {
      _nodesComparator[index].isFirstGreater = true;
    } else if (symbol == '<') {
      _nodesComparator[index].isFirstGreater = false;
    } else {
      _nodesComparator[index].isFirstGreater = null;
    }
  }

  _onLandmarkSelect(String landmark, bool isFirst, int index) {
    if (_nodesComparator[index].firstlandmark != null &&
        _nodesComparator[index].secondLandmark != null &&
        _nodesComparator[index].axis != null) {}
    setState(() {
      isFirst
          ? _nodesComparator[index].firstlandmark =
              EnumUtils.toEnum(landmark, PoseLandmarkType.values, true)!
          : _nodesComparator[index].secondLandmark =
              EnumUtils.toEnum(landmark, PoseLandmarkType.values, true)!;
    });
  }

  _onAxisSelect(String axis, int index) {
    if (Constants.isDebug) {
      print('axis = $axis ');
    }
    setState(() {
      _nodesComparator[index].axis =
          EnumUtils.toEnum(axis, enums.Axis.values, true)!;
    });
  }

  _onComparisonRemoved(NodesComparator node) {
    setState(() => _nodesComparator.remove(node));
  }
}
