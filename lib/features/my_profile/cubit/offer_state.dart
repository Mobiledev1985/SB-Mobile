part of 'offer_cubit.dart';

sealed class OfferState extends Equatable {
  const OfferState();

  @override
  List<Object> get props => [];
}

final class OfferInitial extends OfferState {}

final class OfferLoading extends OfferState {}

final class OfferSuccess extends OfferState {
  final PerksModel perksModel;
  final List<PromotionModel> promotions;
  const OfferSuccess(this.perksModel, this.promotions);
}

final class OfferFailed extends OfferState {
  final String message;
  const OfferFailed(this.message);
}
