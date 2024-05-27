part of 'booking_cubit.dart';

sealed class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

final class BookingInitial extends BookingState {}

final class BookingLoading extends BookingState {}

final class BookingLoaded extends BookingState {
  final BookingModel bookingModel;

  const BookingLoaded({required this.bookingModel});
}

final class BookingFailed extends BookingState {}
