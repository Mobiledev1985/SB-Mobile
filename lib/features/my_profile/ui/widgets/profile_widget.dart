import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/utility/utils/utils.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/cubit/my_profile_cubit.dart';

class ProfileWidget extends StatelessWidget {
  final AnglerProfile profile;

  const ProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16),
              margin:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Text(
                      AppStrings.customiseYourSBProfile,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SpaceVertical(16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await showImagePickBottomSheet(context).then((file) {
                          if (file != null) {
                            context
                                .read<MyProfileCubit>()
                                .onProfileImageSelect(file);
                          }
                          Navigator.pop(context);
                        });
                      },
                      child: const Text(AppStrings.changeProfilePicture),
                    ),
                    const SpaceVertical(10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await showImagePickBottomSheet(context).then(
                          (file) {
                            if (file != null) {
                              context
                                  .read<MyProfileCubit>()
                                  .onBackgroundImageSelected(file);
                            }
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: const Text(AppStrings.changeBackgroundImage),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: BlocBuilder<MyProfileCubit, MyProfileState>(
              builder: (context, state) {
                state as MyProfileLoaded;
                return Hero(
                  tag: 'ProfileImage',
                  child: Material(
                    color: Colors.transparent,
                    child: CircleAvatar(
                      radius: 66,
                      backgroundColor: AppColors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: ClipOval(
                          child: Image.network(
                            (state.profileImage != null)
                                ? state.profileImage!
                                    .replaceAll('https', 'http')
                                : '',
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                SvgPicture.asset(
                              'assets/images/user.svg',
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 8,
            right: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(AppImages.addIcon),
            ),
          ),
        ],
      ),
    );
  }
}
