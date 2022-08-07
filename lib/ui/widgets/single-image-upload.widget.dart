import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/image_upload.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';

import 'cached_image.dart';

enum AppState {
  uploaded,
  picked,
  cropped,
}

// ignore: must_be_immutable
class SingleImageUpload extends StatefulWidget {
  FormGroup form;
  String imageController;
  String title;
  Function() afterUpload;
  Widget placeholder;
  bool viewOnly;
  double width;
  double height;
  SingleImageUpload(
      {Key key,
      this.width = 100,
      this.height = 100,
      this.imageController,
      this.title,
      this.form,
      this.viewOnly = false,
      this.placeholder,
      this.afterUpload})
      : super(key: key);

  @override
  _SingleImageUploadState createState() => _SingleImageUploadState();
}

class _SingleImageUploadState extends State<SingleImageUpload> {
  AppState state;
  XFile imageFile;
  File imageFileCropper;

  @override
  void initState() {
    super.initState();
    state = AppState.uploaded;
  }

  final progress = BehaviorSubject<double>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              if (!widget.viewOnly) {
                _pickImage();
              }
            },
            child: StreamBuilder<double>(
                stream: progress.stream,
                builder: (context, snapshot) {
                  return snapshot.data != null &&
                          snapshot.data > 0 &&
                          snapshot.data < 1
                      ? CircularProgressIndicator(
                          color: AppColors.accentText,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.accentElement),
                          value: snapshot.data)
                      : Container(
                          width: widget.width,
                          height: widget.height,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(color: AppColors.greyColor)),
                          child: Center(
                            child: widget.placeholder ??
                                Image.asset('assets/images/appicon.png'),
                          ),
                        );
                })),
        if (widget.form.control(widget.imageController).valid)
          InkWell(
            onLongPress: () {
              if (!widget.viewOnly) {
                _pickImage();
              }
            },
            child: AnimatedContainer(
              width: widget.width,
              height: widget.height,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceInOut,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                      color: AppColors.accentElement,
                      style: BorderStyle.solid,
                      width: 0.5)),
              child: imageFile != null && state != AppState.uploaded
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        imageFileCropper ?? File(imageFile?.path ?? ''),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedImage(
                        width: widget.width,
                        height: widget.height,
                        imageUrl:
                            '$BaseFileUrl${widget.form.control(widget.imageController).value}',
                        boxFit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
      ],
    );
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      state = AppState.picked;
      await _cropImage();
      setState(() {});
    }
  }

  Future<void> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: AppLocalizations.of(context).get('Edit your Image'),
            toolbarColor: AppColors.accentElement,
            toolbarWidgetColor: AppColors.ternaryBackground,
            dimmedLayerColor: AppColors.ternaryBackground.withOpacity(0.7),
            initAspectRatio: CropAspectRatioPreset.original,
            statusBarColor: AppColors.primaryColor,
            showCropGrid: true,
            backgroundColor: AppColors.primaryBackground,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: AppLocalizations.of(context).get('Edit your Image'),
        ));
    if (croppedFile != null) {
      imageFileCropper = croppedFile;
      uploadImage();
      state = AppState.cropped;
      setState(() {});
    }
  }

  void uploadImage() {
    ImageUplaod().uploadImageProfile(context, onSendProgress: (sent, total) {
      progress.add((sent / total));
    }, file: imageFileCropper).then((value) {
      value.fold((err) => UI.toast('Error While Uploading'), (data) {
        widget.form.control(widget.imageController).updateValue(data['id']);
        setState(() {});
        widget.afterUpload();
      });
    });
  }
}
