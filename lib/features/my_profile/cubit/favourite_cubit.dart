import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/features/home_page/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/features/user_bookings/data/models/api_response.dart';
import 'package:sb_mobile/features/user_bookings/data/models/my_bookings_model.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  FavouriteCubit() : super(FavouriteInitial());
  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  Future<void> getFavourites() async {
    emit(FavouriteLoading());
    final SavedFisheriesApiResponse? savedFisheriesApiResponse =
        await apiProvider.getSavedFisheries();
    if (savedFisheriesApiResponse != null) {
      emit(FavouriteLoaded(
          favourites: savedFisheriesApiResponse.results!.fisheries));
    } else {
      emit(FavouriteFailed());
    }
  }

  Future<bool> updateFavourites(String fisheryId) async {
    final bool isRemoved =
        await apiProvider.updateUserFavourite(fisheryId: fisheryId);
    if (isRemoved) {
      final currentState = state as FavouriteLoaded;
      final updatedFavourites = currentState.favourites
          .where((element) => element.id != fisheryId)
          .toList();

      // Create a new state object with the updated list
      final updatedState = currentState.copyWith(favourites: updatedFavourites);
      emit(FavouriteDummyState());
      emit(updatedState);
    }
    return isRemoved;
  }
}
