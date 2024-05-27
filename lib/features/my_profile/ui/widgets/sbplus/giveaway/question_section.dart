import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/my_profile/data/models/giveaway_quiz_model.dart';
import 'package:sb_mobile/features/my_profile/ui/view/subscription/giveaways/giveaways_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/giveaway/answer_widget.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/sbplus/giveaway/enter_free_button.dart';

class QuestionSection extends StatefulWidget {
  final List<Options> options;
  final ValueNotifier<QuestionState> questionState;
  final String? ticketNumber;
  final VoidCallback onTap;
  const QuestionSection({
    super.key,
    required this.options,
    required this.questionState,
    this.ticketNumber,
    required this.onTap,
  });

  @override
  State<QuestionSection> createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<QuestionSection> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.questionState,
      builder: (context, state, _) {
        if (state == QuestionState.confirmation) {
          return SizedBox(
            width: double.infinity,
            child: Card(
              color: const Color(0xff606060),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14.0, vertical: 16.0),
                child: Column(
                  children: [
                    Text(
                      'Are you sure?',
                      style: context.textTheme.displayMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SpaceVertical(12),
                    Text(
                      'For this skill-based giveaway, participants are granted a single opportunity to respond. If you’ve chosen the option you believe is accurate, please proceed. Otherwise, reconsider and adjust your selection.',
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    const SpaceVertical(20),
                    EnterFreeButton(onTap: widget.onTap),
                    const SpaceVertical(10),
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffA2A2A2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () {
                            widget.questionState.value =
                                QuestionState.notSubmitted;
                          },
                          child: Center(
                            child: Text(
                              'CHANGE MY ANSWER',
                              style: context.textTheme.headlineMedium?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state == QuestionState.correct ||
            state == QuestionState.wrong) {
          return AnswerWidget(
            isCorrect: state == QuestionState.correct,
            ticketNumber: widget.ticketNumber,
          );
        } else {
          return Column(
            children: [
              ...widget.options.indexed
                  .map(
                    (e) => Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.white,
                          width: e.$2.isSelected ? 3.0 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            for (var element in widget.options) {
                              element.isSelected = false;
                            }
                            widget.options[e.$1].isSelected = true;
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.all(
                              e.$2.isSelected ? 15 : 18.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    e.$2.option,
                                    style: context.textTheme.headlineMedium
                                        ?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: AppColors.white,
                                  radius: 11,
                                  child: e.$2.isSelected
                                      ? const CircleAvatar(
                                          backgroundColor: AppColors.black,
                                          radius: 6,
                                        )
                                      : null,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: EnterFreeButton(
                  onTap: () {
                    if (!widget.options.any((element) => element.isSelected)) {
                      showAlert('Please select the option to proceed');
                    } else {
                      widget.questionState.value = QuestionState.confirmation;
                      // context
                      //     .read<GiveawayQuestionCubit>()
                      //     .onEnterForConfirmation();
                    }
                  },
                ),
              ),
              const SpaceVertical(4),
            ],
          );
        }
      },
    );
  }
}
