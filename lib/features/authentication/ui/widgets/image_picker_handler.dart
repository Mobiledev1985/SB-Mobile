import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sb_mobile/features/authentication/cubit/angler_profile_page_cubit.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';

import 'image_picker_dialog.dart';

class ImagePickerHandler {
  late ImagePickerDialog imagePicker;
  late final ImagePickerListener _listener;
  final AnimationController _controller;
  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();
  final BuildContext context;
  ImagePickerHandler(this._listener, this._controller, this.context);
  final ImagePicker picker = ImagePicker();

  openCamera() async {
    imagePicker.dismissDialog();

    var image = await picker.pickImage(source: ImageSource.camera);
    await cropImage(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await picker.pickImage(source: ImageSource.gallery);
    await cropImage(image);
  }

  void init() {
    imagePicker = ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  Future cropImage(XFile? image) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      // androidUiSettings: AndroidUiSettings( toolbarTitle: 'Cropper',
      //     toolbarColor: appStyles.sbBlue,
      //     toolbarWidgetColor: Colors.white,
      //     initAspectRatio: CropAspectRatioPreset.original,
      //     lockAspectRatio: false),
      // iosUiSettings: IOSUiSettings(title: 'Cropper',),
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (croppedFile != null) {
      final file = File(croppedFile.path);

      await apiProvider
          .uploadProfilePicture(croppedFile: file)
          .then((value) async {
        await context.read<AnglerProfilePageCubit>().fetchAnglerProfile();

        _listener.userImage(file);
      });
    }
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File image);
}
