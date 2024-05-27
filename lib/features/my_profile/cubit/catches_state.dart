part of 'catches_cubit.dart';

sealed class CatchesState extends Equatable {
  const CatchesState();

  @override
  List<Object> get props => [];
}

final class CatchesInitial extends CatchesState {}

final class CatchesLoading extends CatchesState {}

final class CatchesLoaded extends CatchesState {
  final List<CatchReportWithAddress> cathesList;
  const CatchesLoaded({required this.cathesList});

  CatchesLoaded copyWith({
    List<CatchReportWithAddress>? cathesList,
  }) {
    return CatchesLoaded(
      cathesList: cathesList ?? this.cathesList,
    );
  }
}
