part of 'credit_history_cubit.dart';

sealed class CreditHistoryState extends Equatable {
  const CreditHistoryState();

  @override
  List<Object> get props => [];
}

final class CreditHistoryInitial extends CreditHistoryState {}

final class CreditHistoryLoading extends CreditHistoryState {}

final class CreditHistorySuccess extends CreditHistoryState {
  final List<CreditHistory> creditHistory;

  const CreditHistorySuccess(this.creditHistory);
}
