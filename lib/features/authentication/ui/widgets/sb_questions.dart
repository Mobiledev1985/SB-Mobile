import 'package:flutter/material.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/widgets/custom_expansion_pannel.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'dart:math' as math;

typedef Question = ({String question, String answer});

class SBQuestions extends StatefulWidget {
  const SBQuestions({super.key});

  @override
  State<SBQuestions> createState() => _SBQuestionsState();
}

class _SBQuestionsState extends State<SBQuestions> {
  final ValueNotifier<int> currentOpnedQuestion = ValueNotifier(-1);

  List<Question> questions = [
    (
      question: 'What exactly does the insurance cover?',
      answer:
          'swimbooker+ insurance cover is backed by Aviva and claims at handled by our partners at Marsh Sports.\n\nFor both membership packages, insurance covers anglers whilst they are actively participating in the sport. (i.e actively partaking in fishing)\n\nFull details of each package can be seen here.'
    ),
    (
      question: 'How do I signup to swimbooker+?',
      answer:
          'Signing up is simple! When ready, choose one of the packages above and you will be taken to the secure Stripe billing checkout. Stripe is the most widely used online payment gateway as it is extremely well secured, robust and provides multiple payment options.\n\nWhen on the Stripe billing page, you will be asked to enter an email address. This email will be used to either create a new swimbooker account, or match to an existing swimbooker free account. This is an automated process.\n\nOnce you’ve chosen your preferred payment method and checked out, you will be guided through the final steps of either creating your account, or logging in.'
    ),
    (
      question: 'Am I able to cancel whenever I want?',
      answer:
          'Absolutely! All swimbooker+ packages can be cancelled whenever you wish. Once you’ve signed up, you can manage your subscription directly from the ‘Manage Subscription’ button on your angler profile.'
    ),
    (
      question: 'How do the giveaways work?',
      answer:
          'swimbooker+ members gain access to a weekly giveaway which can be entered for free via the mobile app or website. Simply navigate to your angler profile and click on ‘Giveaways’.\n\nOnce there, users can answer the weekly question. If answered correctly, they will be allocated a ticket number and be included in the weekly live draw. There are no additional charges to enter on a weekly basis.'
    ),
    (
      question: 'Do I earn credit back on all bookings?',
      answer:
          'Once signed up, members earn a percentage back from all fishing bookings made online via the swimbooker platform. This value is accumulated in your SB angler wallet and can be collected or spent as you wish. You can utilise the value in your wallet towards future bookings on swimbooker.'
    ),
    (
      question: 'How do the giveaways work?',
      answer:
          'There are many partners and fisheries offering exclusive perks and benefits to swimbooker+ members. Once you’ve signed up, you will gain access to all of them, including any that are added in the future. We are currently adding new perks weekly to the platform which is providing even more value to anglers on a daily basis.\n\nOn the perks section of the platform, you will find detailed instructions on how to claim each individual perk.'
    ),
  ];

  @override
  void dispose() {
    currentOpnedQuestion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Questions?',
          style: context.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xffF2F6FA),
          ),
        ),
        const SpaceVertical(16),
        Text(
          'We’ve got answers.',
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.greyColor,
          ),
        ),
        const SpaceVertical(24),
        ...List.generate(
          questions.length,
          (index) => ValueListenableBuilder(
            valueListenable: currentOpnedQuestion,
            builder: (context, currentOpnedQuestion, _) {
              return CustomExpansionPanel(
                isBorder: true,
                header: ColoredBox(
                  color: const Color(0xff0D3759),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22.0,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            questions[index].question,
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.greyTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        const SpaceHorizontal(10),
                        Transform.rotate(
                          angle: index == currentOpnedQuestion
                              ? (math.pi / 2.0)
                              : -(math.pi / 2.0),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: AppColors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                body: ColoredBox(
                  color: AppColors.greyTextColor,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22.0,
                        vertical: 22,
                      ),
                      child: Text(
                        questions[index].answer,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff062620),
                        ),
                      ),
                    ),
                  ),
                ),
                isOpenDefault: index == currentOpnedQuestion,
                onTap: () {
                  this.currentOpnedQuestion.value =
                      index == currentOpnedQuestion ? -1 : index;
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
