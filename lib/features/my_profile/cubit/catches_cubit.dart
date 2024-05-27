import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/features/fishery_property_details/data/models/catch_report_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/catch_report_with_address.dart';
import 'package:sb_mobile/features/my_profile/data/source/sb_backend.dart';

part 'catches_state.dart';

class CatchesCubit extends Cubit<CatchesState> {
  CatchesCubit() : super(CatchesInitial());

  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  Future<void> getCatchReports() async {
    emit(CatchesLoading());
    final List<CatchReportWithAddress>? catchReports =
        await apiProvider.getCatches();
    emit(CatchesLoaded(cathesList: catchReports ?? []));
  }

  Future<void> deleteCatchReport(
      CatchReport deleteCatchReport, Function(bool isFromCacthes) onTap) async {
    if (state is CatchesLoaded) {
      final catchLoadedState = state as CatchesLoaded;
      CatchReportWithAddress? catchReportWithAddress;
      int? removedIndex;

      for (int i = 0; i < catchLoadedState.cathesList.length; i++) {
        final catchReports = catchLoadedState.cathesList[i];
        if (catchReports.reports != null) {
          for (final catchReport in catchReports.reports!) {
            if (catchReport.id == deleteCatchReport.id) {
              catchReports.reports!.remove(catchReport);
              catchReportWithAddress = catchReports;
              removedIndex = i;
              break;
            }
          }
        }
        if (removedIndex != null) {
          break;
        }
      }

      emit(CatchesInitial());

      emit(
        catchLoadedState.copyWith(
          cathesList: catchLoadedState.cathesList,
        ),
      );
      onTap.call(true);

      bool isDeleted =
          await apiProvider.deleteCatche(deleteCatchReport.id ?? '');

      if (isDeleted) {
        showAlert('The catch report has been successfully deleted.');
      } else {
        if (catchReportWithAddress != null && removedIndex != null) {
          catchLoadedState.cathesList[removedIndex].reports!.insert(
            0,
            deleteCatchReport,
          );
          emit(CatchesInitial());
          emit(
            catchLoadedState.copyWith(
              cathesList: catchLoadedState.cathesList,
            ),
          );
        }
        // showAlert('The catch report deletion failed');
      }
    } else {
      bool isDeleted =
          await apiProvider.deleteCatche(deleteCatchReport.id ?? '');

      if (isDeleted) {
        showAlert('The catch report has been successfully deleted.');
        onTap.call(false);
      }
    }
  }
}
