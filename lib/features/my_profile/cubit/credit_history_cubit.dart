import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/features/my_profile/data/models/credit_history_model.dart';
import 'package:sb_mobile/features/my_profile/data/source/sb_backend.dart';

part 'credit_history_state.dart';

class CreditHistoryCubit extends Cubit<CreditHistoryState> {
  CreditHistoryCubit() : super(CreditHistoryInitial());

  final SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  Future<void> getCreditHistory() async {
    emit(CreditHistoryLoading());
    final List<CreditHistory>? history = await apiProvider.getCreditHistory();
    emit(CreditHistorySuccess(history ?? []));
  }
}
