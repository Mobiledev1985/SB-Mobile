import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/features/my_profile/data/models/booking_model.dart';
import 'package:sb_mobile/features/my_profile/data/source/sb_backend.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  Future<void> getBookings() async {
    emit(BookingLoading());
    final BookingModel? bookingModel = await apiProvider.getBookings();
    if (bookingModel != null) {
      emit(
        BookingLoaded(bookingModel: bookingModel),
      );
    } else {
      emit(BookingFailed());
    }
  }
}
