part of 'favourite_cubit.dart';

sealed class FavouriteState extends Equatable {
  const FavouriteState();

  @override
  List<Object> get props => [];
}

final class FavouriteInitial extends FavouriteState {}

final class FavouriteLoading extends FavouriteState {}

final class FavouriteLoaded extends FavouriteState {
  final List<BookedFishery> favourites;

  const FavouriteLoaded({required this.favourites});

  // Create a copyWith method to update the list
  FavouriteLoaded copyWith({List<BookedFishery>? favourites}) {
    return FavouriteLoaded(
      favourites: favourites ?? this.favourites,
    );
  }
}

final class FavouriteFailed extends FavouriteState {}

final class FavouriteDummyState extends FavouriteState {}
