import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/features/home_page/ui/views/bottom_bar_provider.dart';
import 'package:sb_mobile/features/my_profile/cubit/my_profile_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/view/bookings_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/view/catches_screen.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/state_item.dart';

class StatesWidget extends StatelessWidget {
  const StatesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        if (state is MyProfileLoaded) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 56,
                        maxHeight: 56,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            StateItem(
                              value:
                                  '${state.userStatistics?.fishCaught ?? ''}',
                              title: AppStrings.catches,
                              onTap: () {
                                CatchesScreen.navigateTo(
                                  context,
                                  state.profile,
                                );
                              },
                            ),
                            const VerticalDivider(
                              color: AppColors.dividerGreyColor,
                              width: 0,
                            ),
                            const SpaceHorizontal(10),
                            StateItem(
                              value:
                                  '${state.userStatistics?.sessionsBooked ?? ''}',
                              title: AppStrings.sessionsBooked,
                              onTap: () {
                                if (state.isPlusMember) {
                                  BookingsScreen.navigateTo(
                                    context,
                                    state.profile,
                                  );
                                }
                              },
                            ),
                            const SpaceHorizontal(10),
                            const VerticalDivider(
                              color: AppColors.dividerGreyColor,
                              width: 0,
                            ),
                            StateItem(
                              value:
                                  '${state.userStatistics?.fisheryReviews ?? ''}',
                              title: AppStrings.reviews,
                              onTap: () {
                                BottomBarProvider.of(context)
                                    .selectedBottomBarItem
                                    .value = 1;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                child: Container(
                  // width: 116,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.dividerColor)),
                  child: BlocBuilder<MyProfileCubit, MyProfileState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          state is MyProfileLoaded &&
                                      context
                                              .read<MyProfileCubit>()
                                              .subscriptionLevel ==
                                          null ||
                                  !(context
                                          .read<MyProfileCubit>()
                                          .subscriptionLevel!
                                          .toLowerCase()
                                          .contains('pro') ||
                                      context
                                          .read<MyProfileCubit>()
                                          .subscriptionLevel!
                                          .toLowerCase()
                                          .contains('plus'))
                              ? AppStrings.standardMember
                              : '${context.read<MyProfileCubit>().subscriptionLevel} Member',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blue,
                                  ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        } else {
          return SizedBox.fromSize();
        }
      },
    );
  }
}
