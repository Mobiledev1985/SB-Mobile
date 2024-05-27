import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/features/home_page/data/models/promotion_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/perks_model.dart';
import 'package:sb_mobile/features/my_profile/data/source/sb_backend.dart';

part 'offer_state.dart';

class OfferCubit extends Cubit<OfferState> {
  OfferCubit() : super(OfferInitial());
  final SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  Future<void> getPerks() async {
    emit(OfferLoading());
    final PerksModel? perksModel = await apiProvider.getPerks();
    final List<PromotionModel>? promotions = await apiProvider.getPromotion();
    if (perksModel != null) {
      emit(OfferSuccess(perksModel, promotions ?? []));
    } else {
      emit(const OfferFailed('Server Failed to respond, try again later.'));
    }
  }
}
