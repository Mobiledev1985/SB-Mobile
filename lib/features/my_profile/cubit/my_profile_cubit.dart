import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/authentication/data/models/profile_response.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/features/home_page/data/models/user_statistics.dart';
import 'package:sb_mobile/features/my_profile/data/models/achivement_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/wallet_model.dart';

part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit() : super(MyProfileInitial());
  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();
  String? subscriptionLevel;
  void onSaveChange(Function onValidationComplete) {
    onValidationComplete.call();
  }

  Future<void> onProfileImageSelect(File? profileImage) async {
    if (profileImage == null) {
      return;
    }
    emit(MyProfileLoading());
    await apiProvider.uploadProfilePicture(croppedFile: profileImage);
    await fetchAnglerProfile(false);
    imageCache.clear();
  }

  Future<void> onBackgroundImageSelected(File? backgroundImage) async {
    if (backgroundImage == null) {
      return;
    }
    emit(MyProfileLoading());
    await apiProvider.uploadBackgroundImage(backgroundImage);
    await fetchAnglerProfile(false);
    imageCache.clear();
  }

  Future<void> fetchAnglerProfile(bool isLoading) async {
    if (isLoading) {
      emit(MyProfileLoading());
    }
    final AnglerProfileApiResponse? response =
        await apiProvider.fetchAnglerProfile();
    final UserStatistics? userStatistics =
        await apiProvider.getUserStatistics();
    final AchievementModel? achievementModel =
        await apiProvider.getAchivements();
    bool isInSessionButtonVisible = false;
    bool isPlusMember = false;
    WalletModel? walletModel;
    subscriptionLevel = await apiProvider.getSubscriptionLevel();
    if (subscriptionLevel != null &&
        (subscriptionLevel!.toLowerCase().contains('pro') ||
            subscriptionLevel!.toLowerCase().contains('plus'))) {
      isPlusMember = true;
      final String? startNextSesstionDate =
          await apiProvider.nextSessionStart();
      walletModel = await apiProvider.getWallet();

      if (startNextSesstionDate != null) {
        final DateTime startNextSesstion =
            DateTime.parse(startNextSesstionDate);
        if (startNextSesstion.isBefore(DateTime.now())) {
          isInSessionButtonVisible = true;
        }
      }
    }

    if (response != null && response.profile != null) {
      final proile = response.profile;
      if (walletModel != null && walletModel.balanceInPence != null) {
        proile!.walletAmount = walletModel.balanceInPence!.toDouble();
      }

      emit(
        MyProfileLoaded(
          profile: proile,
          profileImage: response.profile?.profileImage,
          backgroundImage: response.profile?.backgroundImage,
          userStatistics: userStatistics,
          isInSessionButtonVisible: isInSessionButtonVisible,
          isPlusMember: isPlusMember,
          wallet: walletModel,
          achievementModel: achievementModel,
        ),
      );
    } else {
      emit(
        const MyProfileFailed(message: "API Failure"),
      );
    }
  }

  Future<void> editProfile(AnglerProfile profile) async {
    await apiProvider.updateUserDetails(profile: profile);
    // final currentState = state as MyProfileLoaded;
    // emit(
    //   currentState.copyWith(profile: profile),
    // );
  }

  Future<void> resetPassword() async {
    apiProvider.resetPassword();
  }
}
