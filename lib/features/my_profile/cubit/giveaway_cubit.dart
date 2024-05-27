import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/features/my_profile/data/models/giveaway_quiz_model.dart';
import 'package:sb_mobile/features/my_profile/data/source/sb_backend.dart';

part 'giveaway_state.dart';

class GiveawayCubit extends Cubit<GiveawayState> {
  GiveawayCubit() : super(GiveawayInitial());
  final SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  Future<void> getGiveawayQuizzes() async {
    emit(GiveawayLoading());
    final List<GiveawayQuizModel>? qiuzzes =
        await apiProvider.getGiveawayQuizzes();
    if (qiuzzes != null) {
      for (var element in qiuzzes) {
        if (element.ticketNumber == 'NA') {
          element.ticketNumber = null;
          element.questionState!.value = QuestionState.wrong;
        } else if (element.ticketNumber != null) {
          element.questionState!.value = QuestionState.correct;
        }
      }
    }
    emit(
      GiveawaySuccess(
        qiuzzes ?? [],
      ),
    );
  }

  Future<void> onAnswer(GiveawayQuizModel quiz, String answer) async {
    final bool? isSubmitted = await apiProvider.submitAnswer(
      quizId: quiz.id!,
      answer: answer,
      ticketNumber: (ticketNumber) {
        if (ticketNumber != null) {
          quiz.ticketNumber = ticketNumber;
          quiz.questionState!.value = QuestionState.correct;
        } else {
          quiz.questionState!.value = QuestionState.wrong;
        }
      },
    );
    if (isSubmitted == null) {
      showAlert('Server Failed to respond, try again later.');
    }
  }
}
