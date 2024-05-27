import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/constant/ui_constant.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/validators/validators.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/cubit/my_profile_cubit.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/delete_account_dialog.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/text_field_item.dart';
import 'package:sb_mobile/features/submit_catch_report/ui/widgets/outside_touch_hide_keyboard.dart';

typedef MyDetailScreenData = ({AnglerProfile profile, VoidCallback onSave});

class MyDetailsScreen extends StatefulWidget {
  final MyDetailScreenData myDetailScreenData;
  const MyDetailsScreen({super.key, required this.myDetailScreenData});

  @override
  State<MyDetailsScreen> createState() => _MyDetailsScreenState();

  static PageRouteBuilder<dynamic> buildRouter(
      MyDetailScreenData myDetailScreenData) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MyDetailsScreen(myDetailScreenData: myDetailScreenData),
      settings: const RouteSettings(name: RoutePaths.myDetailsScreen),
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween<double>(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.ease), // Replace with your desired curve
        );
        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static void navigateTo(
      BuildContext context, MyDetailScreenData myDetailScreenData) {
    Navigator.pushNamed(context, RoutePaths.myDetailsScreen,
        arguments: myDetailScreenData);
  }
}

class _MyDetailsScreenState extends State<MyDetailsScreen> {
  final ValueNotifier<bool> _readOnly = ValueNotifier<bool>(true);

  bool get readOnly => _readOnly.value;
  set readOnly(bool readOnly) => _readOnly.value = readOnly;

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController postcode = TextEditingController();
  final TextEditingController address1 = TextEditingController();
  final TextEditingController address2 = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password =
      TextEditingController(text: '**********');
  final List<PersonalBest> personalBests = [];
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  final ValueNotifier<bool> _isChecked = ValueNotifier(false);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final List<String> years = [
    "1",
    "2",
    "3",
    "4",
    "5+",
    "10+",
    "20+",
    "30+",
    "40+",
    "50+"
  ];

  final List<String> species = [
    "Carp",
    "Catfish",
    "Pike",
    "Tench",
    "Barbel",
    "Perch",
    "Roach",
    "Trout",
    "Rudd",
    "Chub",
    "Sturgeon",
    "Bream"
  ];

  final List<String> weight = [
    "<10",
    ...List.generate(39, (index) => "${index + 11}"),
    "50+",
  ];

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
      );
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
      FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    }
    firstName.text = widget.myDetailScreenData.profile.firstName;
    lastName.text = widget.myDetailScreenData.profile.lastName;
    city.text = widget.myDetailScreenData.profile.city ?? "";
    postcode.text = widget.myDetailScreenData.profile.postcode ?? "";
    address1.text = widget.myDetailScreenData.profile.addressLine1 ?? "";
    address2.text = widget.myDetailScreenData.profile.addressLine2 ?? "";
    email.text = widget.myDetailScreenData.profile.email;
    _isChecked.value = widget.myDetailScreenData.profile.isPublic ?? false;
    for (var element in widget.myDetailScreenData.profile.personalBest) {
      personalBests.add(
        PersonalBest(
          species: element.speciesName ?? "",
          weight: element.weight ?? "",
        ),
      );
    }
  }

  @override
  void dispose() {
    _isChecked.dispose();
    isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: OutSideTouchHideKeyboard(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileBar(profile: widget.myDetailScreenData.profile),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              left: defaultSidePadding, top: 34, bottom: 22),
                          child: BackButtonWidget(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultSidePadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.myDetails,
                                style: textTheme.headlineMedium?.copyWith(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                height: 32,
                                child: ValueListenableBuilder(
                                  valueListenable: _readOnly,
                                  builder: (context, value, _) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: value
                                              ? AppColors.green
                                              : AppColors.blue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          disabledBackgroundColor:
                                              Colors.transparent),
                                      onPressed: value
                                          ? () {
                                              // _onEditDetailsButtonTap();
                                              readOnly = !readOnly;
                                            }
                                          : () async {
                                              if (form.currentState!
                                                  .validate()) {
                                                widget
                                                    .myDetailScreenData
                                                    .profile
                                                    .firstName = firstName.text;
                                                widget
                                                    .myDetailScreenData
                                                    .profile
                                                    .lastName = lastName.text;
                                                widget.myDetailScreenData
                                                        .profile.addressLine1 =
                                                    address1.text;
                                                widget.myDetailScreenData
                                                        .profile.addressLine2 =
                                                    address2.text;
                                                widget.myDetailScreenData
                                                    .profile.city = city.text;
                                                widget
                                                    .myDetailScreenData
                                                    .profile
                                                    .postcode = postcode.text;
                                                widget.myDetailScreenData
                                                        .profile.isPublic =
                                                    _isChecked.value;
                                                isLoading.value = true;
                                                await context
                                                    .read<MyProfileCubit>()
                                                    .editProfile(
                                                      widget.myDetailScreenData
                                                          .profile,
                                                    );
                                                widget.myDetailScreenData.onSave
                                                    .call();
                                                // _onSaveDetailsButtonTap();
                                                // ignore: use_build_context_synchronously
                                                Navigator.pop(context);
                                                readOnly = !readOnly;
                                                isLoading.value = false;
                                                // _showHeroOverlayForSave
                                                //     .value = false;
                                                // _showEditDetailsButton.value =
                                                //     true;
                                              }
                                            },
                                      child: ValueListenableBuilder(
                                        valueListenable: isLoading,
                                        builder: (context, isLoading, _) {
                                          return isLoading
                                              ? const SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: AppColors.white,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  value
                                                      ? AppStrings.editDetails
                                                      : AppStrings.saveChanges
                                                          .toUpperCase(),
                                                  style: textTheme.bodyMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              AppColors.white),
                                                );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SpaceVertical(34),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: defaultSidePadding,
                          ),
                          child: TextFieldItem(
                            title: 'Angler ID',
                            controller: TextEditingController(
                              text: widget.myDetailScreenData.profile.publicId
                                  .toString(),
                            ),
                            readOnly: true,
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _readOnly,
                          builder: (context, readOnly, _) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultSidePadding,
                              ),
                              child: Form(
                                key: form,
                                child: Column(
                                  children: [
                                    TextFieldItem(
                                      title: AppStrings.firstName,
                                      controller: firstName,
                                      readOnly: readOnly,
                                      validator: Validators.nameValidator,
                                    ),
                                    TextFieldItem(
                                      title: AppStrings.lastName,
                                      controller: lastName,
                                      readOnly: readOnly,
                                      validator: Validators.nameValidator,
                                    ),
                                    TextFieldItem(
                                      title: AppStrings.address,
                                      controller: address1,
                                      readOnly: readOnly,
                                      validator: Validators.emptyValidator,
                                    ),
                                    TextFieldItem(
                                      title: '',
                                      controller: address2,
                                      readOnly: readOnly,
                                      validator: Validators.emptyValidator,
                                    ),
                                    TextFieldItem(
                                      title: AppStrings.city,
                                      controller: city,
                                      readOnly: readOnly,
                                      validator: Validators.emptyValidator,
                                    ),
                                    TextFieldItem(
                                      title: '',
                                      controller: postcode,
                                      readOnly: readOnly,
                                      validator: Validators.emptyValidator,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 36),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: AppStrings.swim,
                                              ),
                                              TextSpan(
                                                text: AppStrings
                                                    .bookerLoginDetails,
                                                style: textTheme.headlineSmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                            style: textTheme.headlineSmall
                                                ?.copyWith(
                                              color: AppColors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextFieldItem(
                                      title: AppStrings.email,
                                      controller: email,
                                      readOnly: true,
                                    ),
                                    TextFieldItem(
                                      title: AppStrings.password,
                                      obscureText: true,
                                      controller: password,
                                      readOnly: true,
                                    ),
                                    const SpaceVertical(22),
                                    SizedBox(
                                      height: 36,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<MyProfileCubit>()
                                              .resetPassword();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                        child: Text(
                                          AppStrings.sendPasswordReset,
                                          style: textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SpaceVertical(34),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        AppStrings.anglingDetails,
                                        style:
                                            textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SpaceVertical(20),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 6.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            AppStrings.yearsAngling,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          SizedBox(
                                            width: 240,
                                            child:
                                                DropdownButtonFormField<String>(
                                              value: widget
                                                      .myDetailScreenData
                                                      .profile
                                                      .yearsAngling
                                                      .isEmpty
                                                  ? null
                                                  : widget.myDetailScreenData
                                                      .profile.yearsAngling,
                                              hint: const Text('Select years'),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 8,
                                                  horizontal: 10,
                                                ),
                                                filled: true,
                                                fillColor: readOnly
                                                    ? const Color(0xffEDEDED)
                                                    : AppColors.white,
                                              ),
                                              items: years
                                                  .map(
                                                    (e) => DropdownMenuItem<
                                                        String>(
                                                      value: e,
                                                      child: Text(e),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: readOnly
                                                  ? null
                                                  : (value) {
                                                      widget
                                                          .myDetailScreenData
                                                          .profile
                                                          .yearsAngling = value!;
                                                    },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ...personalBests.indexed
                                        .map(
                                          (e) => Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      AppStrings.species,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    const Expanded(
                                                      child: SizedBox(),
                                                    ),
                                                    SizedBox(
                                                      width: 240,
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        value:
                                                            e.$2.species.isEmpty
                                                                ? null
                                                                : e.$2.species,
                                                        hint: const Text(
                                                            'Select species'),
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 8,
                                                            horizontal: 10,
                                                          ),
                                                          filled: true,
                                                          fillColor: readOnly
                                                              ? const Color(
                                                                  0xffEDEDED)
                                                              : AppColors.white,
                                                        ),
                                                        items: species
                                                            .map(
                                                              (e) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                value: e,
                                                                child: Text(e),
                                                              ),
                                                            )
                                                            .toList(),
                                                        onChanged: readOnly
                                                            ? null
                                                            : (value) {
                                                                widget
                                                                    .myDetailScreenData
                                                                    .profile
                                                                    .personalBest[
                                                                        e.$1]
                                                                    .speciesName = value!;
                                                              },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      AppStrings.weight,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    const Expanded(
                                                      child: SizedBox(),
                                                    ),
                                                    SizedBox(
                                                      width: 240,
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        value:
                                                            e.$2.weight.isEmpty
                                                                ? null
                                                                : e.$2.weight,
                                                        hint: const Text(
                                                            'Select Weight'),
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 8,
                                                            horizontal: 10,
                                                          ),
                                                          filled: true,
                                                          fillColor: readOnly
                                                              ? const Color(
                                                                  0xffEDEDED)
                                                              : AppColors.white,
                                                        ),
                                                        items: weight
                                                            .map(
                                                              (e) =>
                                                                  DropdownMenuItem<
                                                                      String>(
                                                                value: e,
                                                                child: Text(e),
                                                              ),
                                                            )
                                                            .toList(),
                                                        onChanged: readOnly
                                                            ? null
                                                            : (value) {
                                                                widget
                                                                    .myDetailScreenData
                                                                    .profile
                                                                    .personalBest[
                                                                        e.$1]
                                                                    .weight = value!;
                                                              },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SpaceVertical(24),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _readOnly,
                              builder: (context, readOnly, __) {
                                return ValueListenableBuilder(
                                  valueListenable: _isChecked,
                                  builder: (context, isChecked, _) {
                                    return Theme(
                                      data: context.appTheme.copyWith(
                                        unselectedWidgetColor: AppColors
                                            .blue, // Change this to your desired border color
                                      ),
                                      child: Checkbox(
                                        value: isChecked,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: const BorderSide(
                                            color: AppColors.grey,
                                            width: 4,
                                          ),
                                        ),
                                        checkColor: AppColors.white,
                                        fillColor: MaterialStatePropertyAll(
                                          readOnly
                                              ? Colors.grey
                                              : isChecked
                                                  ? AppColors.blue
                                                  : AppColors.white,
                                        ),
                                        onChanged: readOnly
                                            ? null
                                            : (value) {
                                                _isChecked.value =
                                                    !_isChecked.value;
                                              },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SpaceHorizontal(12),
                            Expanded(
                              child: Text(
                                'Allow my angling experience to be displayed publicly on comments and interactions on the site',
                                style: context.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        const SpaceVertical(30),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: defaultSidePadding,
                            ),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => DeleteAccountDialog(
                                    email:
                                        widget.myDetailScreenData.profile.email,
                                    publicId: widget
                                        .myDetailScreenData.profile.publicId,
                                  ),
                                );
                              },
                              child: Text(
                                'Delete Account',
                                style:
                                    context.textTheme.headlineSmall?.copyWith(
                                  color: AppColors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SpaceVertical(50),
                      ],
                    ),
                  ),
                )
              ],
            ),
            // Positioned(
            //   left: 0,
            //   right: 0,
            //   bottom: 12,
            //   child: Visibility(
            //     visible: MediaQuery.viewInsetsOf(context).bottom <= 0,
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 24.0),
            //       child: ValueListenableBuilder(
            //           valueListenable: isLoading,
            //           builder: (context, isLoading, _) {
            //             return ValueListenableBuilder(
            //               valueListenable: _showSaveButton,
            //               builder: (context, value, _) {
            //                 return IgnorePointer(
            //                   ignoring: !value,
            //                   child: ElevatedButton(
            //                     onPressed: value ? () async {} : null,
            //                     style: ElevatedButton.styleFrom(
            //                         backgroundColor: value
            //                             ? AppColors.blue
            //                             : Colors.transparent,
            //                         shape: RoundedRectangleBorder(
            //                           borderRadius: BorderRadius.circular(50),
            //                         ),
            //                         disabledBackgroundColor:
            //                             Colors.transparent),
            //                     child: isLoading
            //                         ? const CircularProgressIndicator(
            //                             color: AppColors.white,
            //                           )
            //                         : Text(
            //                             AppStrings.saveChanges,
            //                             key: _saveChangesButtonKey,
            //                             style: textTheme.headlineMedium
            //                                 ?.copyWith(
            //                                     fontWeight: FontWeight.bold,
            //                                     color: value
            //                                         ? AppColors.white
            //                                         : Colors.transparent),
            //                           ),
            //                   ),
            //                 );
            //               },
            //             );
            //           }),
            //     ),
            //   ),
            // ),

            // ValueListenableBuilder(
            //   valueListenable: _showHeroOverlay,
            //   builder: (context, value, _) {
            //     return Visibility(
            //       visible: value,
            //       child: OverlayAnimationWidget(
            //         editDetailsButtonKey: _editDetailsButtonKey,
            //         saveChangesButtonKey: _saveChangesButtonKey,
            //         isClickOnEditButton: true,
            //         onEnd: () {
            //           _showHeroOverlay.value = false;
            //           _showSaveButton.value = true;
            //         },
            //       ),
            //     );
            //   },
            // ),

            // ValueListenableBuilder(
            //   valueListenable: _showHeroOverlayForSave,
            //   builder: (context, value, _) {
            //     return Visibility(
            //       visible: value,
            //       child: OverlayAnimationWidget(
            //         editDetailsButtonKey: _editDetailsButtonKey,
            //         saveChangesButtonKey: _saveChangesButtonKey,
            //         isClickOnEditButton: false,
            //         onEnd: () {
            //           _showHeroOverlayForSave.value = false;
            //           _showEditDetailsButton.value = true;
            //         },
            //       ),
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }
}

class PersonalBest {
  String species;
  String weight;

  PersonalBest({required this.species, required this.weight});
}
