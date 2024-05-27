part of 'fishery_profile_cubit.dart';

enum FisheryProfileStatus { loading, success, failure }

enum UserReviewStatus { loading, success, failure }

class FisheryProfileState extends Equatable {
  const FisheryProfileState({
    this.status = FisheryProfileStatus.loading,
    this.fishery,
    this.allImages = const [],
    this.catchReports = const [],
    this.isFavorite = false,
    this.sliderIndex = 0,
    this.fisheryQuickFactsAndFacilities = (
      quickFacts: const [],
      facilities: const []
    ),
  });

  final FisheryProfileStatus status;
  final List<String> allImages;
  final List<CatchReport> catchReports;
  final FisheryPropertyDetails? fishery;
  final bool isFavorite;
  final int sliderIndex;
  final FisheryQuickFactsAndFacilities fisheryQuickFactsAndFacilities;

  FisheryProfileState copyWith({
    FisheryProfileStatus Function()? status,
    FisheryPropertyDetails Function()? fishery,
    FisheryQuickFactsAndFacilities Function()? fisheryQuickFactsAndFacilities,
    List<String> Function()? allImages,
    List<CatchReport> Function()? catchReports,
    bool Function()? isFavorite,
    int Function()? sliderIndex,
  }) {
    return FisheryProfileState(
      status: status != null ? status() : this.status,
      fishery: fishery != null ? fishery() : this.fishery,
      allImages: allImages != null ? allImages() : this.allImages,
      isFavorite: isFavorite != null ? isFavorite() : this.isFavorite,
      sliderIndex: sliderIndex != null ? sliderIndex() : this.sliderIndex,
      catchReports: catchReports != null ? catchReports() : this.catchReports,
      fisheryQuickFactsAndFacilities: fisheryQuickFactsAndFacilities != null
          ? fisheryQuickFactsAndFacilities()
          : this.fisheryQuickFactsAndFacilities,
    );
  }

  @override
  List<Object?> get props => [
        status,
        fishery,
        allImages,
        isFavorite,
        sliderIndex,
        fisheryQuickFactsAndFacilities,
      ];
}
