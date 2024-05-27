import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/features/fishery_profile/view/fishery_profile_page.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/fishery_details.dart';
import 'package:sb_mobile/features/fishery_property_details/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/features/search/data/models/selected_item_model.dart';
import 'package:sb_mobile/features/user_bookings/data/source/api/sb_backend.dart'
    as fav_api;

import 'package:sb_mobile/features/search/data/sources/api/sb_backend.dart'
    as search_api;

part 'fishery_profile_state.dart';

class FisheryProfileCubit extends Cubit<FisheryProfileState> {
  FisheryProfileCubit({
    required this.publicId,
    required this.fisheryQuickFactsAndFacilities,
  }) : super(const FisheryProfileState());

  final SwimbookerApiProvider apiProvider = SwimbookerApiProvider();
  final int publicId;

  FisheryQuickFactsAndFacilities? fisheryQuickFactsAndFacilities;

  void updateSliderIndex(int i) {
    emit(
      state.copyWith(sliderIndex: () => i),
    );
  }

  Future<void> fetchFishery() async {
    emit(state.copyWith(
      status: () => FisheryProfileStatus.loading,
    ));

    final response = await apiProvider.getPropertyDetails(publicId: publicId);
    if (response.results != null) {
      try {
        final savedFisheries =
            await fav_api.SwimbookerApiProvider().getSavedFisheries(userId: '');
        final FisheryPropertyDetails fishery = response.results!;
        final List<CatchReport> catchReports =
            await apiProvider.getCatchReports(fishery.fisheryId);

        if (fisheryQuickFactsAndFacilities == null) {
          final [quickFacts, facilities] = await Future.wait([
            apiProvider.getQuickFactsOrFacilities(isQuickFacts: true),
            apiProvider.getQuickFactsOrFacilities(isQuickFacts: false),
          ]);
          fisheryQuickFactsAndFacilities =
              (quickFacts: quickFacts, facilities: facilities);
        }

        List<SelectableItemModel> quickFacts = [], facilities = [];

        if (fisheryQuickFactsAndFacilities != null) {
          quickFacts = fisheryQuickFactsAndFacilities!.quickFacts
              .where((element) => fishery.quickFacts.contains(element.title))
              .toList();

          facilities = fisheryQuickFactsAndFacilities!.facilities
              .where((element) => fishery.facilities.contains(element.title))
              .toList();
        }

        bool? isFavorite;
        if (savedFisheries != null) {
          if (savedFisheries.results != null) {
            isFavorite = savedFisheries.results!.fisheries.any(
              (element) => element.id == fishery.fisheryId,
            );
          }
        }
        List<String> images = [];
        images.add(fishery.images.primary);

        for (var element in fishery.images.secondary) {
          images.add(element);
        }
        emit(
          state.copyWith(
            fishery: () => fishery,
            allImages: () => images,
            isFavorite: () => isFavorite ?? false,
            status: () => FisheryProfileStatus.success,
            catchReports: () => catchReports,
            fisheryQuickFactsAndFacilities: () =>
                (quickFacts: quickFacts, facilities: facilities),
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: () => FisheryProfileStatus.failure));
      }
    } else {
      emit(state.copyWith(status: () => FisheryProfileStatus.failure));
    }
  }

  Future<void> setFav(bool fav) async {
    search_api.SwimbookerApiProvider searchApiProvider =
        search_api.SwimbookerApiProvider();

    await searchApiProvider.updateUserFavourite(
        fisheryId: state.fishery!.fisheryId);

    emit(state.copyWith(isFavorite: () => fav));
  }

  Future<void> submitUserReview({
    required String fisheryId,
    required int rating,
    required String comment,
  }) async {
    bool response = await apiProvider.submitUserReview(
        fisheryId: fisheryId, rating: rating, comment: comment);
    if (response == true) {
      // emit(PropertyWaiting());
      fetchFishery();
    } else {
      // emit(PropertyDetailsFailed(message: "API Failure"));
    }
  }
}
