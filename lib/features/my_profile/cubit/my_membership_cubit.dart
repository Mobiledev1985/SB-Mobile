import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/features/my_profile/data/models/my_membership_model.dart';
import 'package:sb_mobile/features/my_profile/data/source/sb_backend.dart';

part 'my_membership_state.dart';

class MyMembershipCubit extends Cubit<MyMembershipState> {
  MyMembershipCubit() : super(MyMembershipInitial());

  final SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  Future<void> getMemberships() async {
    emit(MyMembershipsLoading());
    final MyMemberShipModel? memberShipModel =
        await apiProvider.getMemberships();
    if (memberShipModel != null) {
      emit(
        MyMembershipsLoaded(
          memberships: memberShipModel.memberships ?? [],
          seasonTickets: memberShipModel.seasonTickets ?? [],
        ),
      );
    } else {
      emit(MyMembershipsFailed());
    }
  }
}
