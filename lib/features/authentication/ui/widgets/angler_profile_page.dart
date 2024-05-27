import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sb_mobile/core/config/authenticator.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/utility/styles/app_styles.dart';
import 'package:sb_mobile/core/widgets/alert.dart';
import 'package:sb_mobile/features/authentication/cubit/angler_profile_page_cubit.dart';
import 'package:sb_mobile/features/authentication/cubit/authentication_status_cubit.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/authentication/data/sources/api/sb_backend.dart';
import 'package:sb_mobile/features/home_page/cubit/home_page_cubit.dart';

import 'image_picker_handler.dart';

class AnglerProfilePage extends StatefulWidget {
  const AnglerProfilePage({Key? key}) : super(key: key);

  @override
  State<AnglerProfilePage> createState() {
    return _AnglerProfilePageState();
  }
}

class _AnglerProfilePageState extends State<AnglerProfilePage>
    // with TickerProviderStateMixin {
    with
        TickerProviderStateMixin
    implements
        ImagePickerListener {
  AppStyles appStyles = AppStyles();
  final _formKey = GlobalKey<FormState>();
  final scrollController = ScrollController();

  File? _image;
  late AnimationController _controller;
  late ImagePickerHandler imagePicker;
  bool isReadOnly = true;

  Center get buildCenterLoading =>
      Center(child: CircularProgressIndicator(color: appStyles.sbBlue));
  String _currentSelectedValue = '';
  String _currentSelectedSpecies1 = '';
  String _currentSelectedSpecies2 = '';
  String _currentSelectedWeight1 = '';
  String _currentSelectedWeight2 = '';
  bool checkedValue = false;

  SwimbookerApiProvider apiProvider = SwimbookerApiProvider();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // imagePicker = new ImagePickerHandler(this, _controller);
    // imagePicker.init();
  }

  Widget getFormRow({
    required String fieldName,
    required String initialValue,
    required AnglerProfile profile,
  }) {
    EdgeInsets padding = const EdgeInsets.only(left: 20.0);
    List<String> mandatoryColumns = ["First Name", "Last Name"];
    EdgeInsets expandedPadding =
        const EdgeInsets.only(top: 5.0, bottom: 0.0, right: 20.0);

    TextStyle labelTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: appStyles.fontGilroy,
        fontSize: 16);

    TextStyle valueTextStyle = TextStyle(
        fontSize: 15,
        fontFamily: appStyles.fontGilroy,
        color: isReadOnly ? Colors.grey.shade500 : Colors.black,
        fontWeight: FontWeight.w300);

    InputDecoration valueDecoration = InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      fillColor: isReadOnly ? appStyles.sbGrey : Colors.white,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: isReadOnly ? appStyles.sbGrey : appStyles.sbBlue),
      ),

      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 0.0),
      ),
      border: const OutlineInputBorder(),
      // labelText: fieldName == "Address" ? "Line 1" :  fieldName == "" ? "Line 2" : fieldName
    );

    validator(String? value) {
      if ((value == null || value.isEmpty || value.trim().isEmpty) &&
          (mandatoryColumns.contains(fieldName))) {
        return 'This field cannot be empty';
      }
      if (value != null) {
        switch (fieldName) {
          case 'First Name':
            profile.firstName = value;
            break;
          case 'Last Name':
            profile.lastName = value;
            break;
          case 'Address':
            profile.addressLine1 = value;
            break;
          case 'Address Line 2':
            profile.addressLine2 = value;
            break;
          case 'City':
            profile.city = value;
            break;
          case 'Post Code':
            profile.postcode = value;
            break;
        }
      }

      return null;
    }

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Padding(
            padding: padding,
            child: Text(
              fieldName,
              maxLines: 1,
              style: labelTextStyle,
            ),
          )),
          Expanded(
              flex: 2,
              child: Padding(
                padding: expandedPadding,
                child: TextFormField(
                  readOnly: isReadOnly,
                  initialValue: initialValue,
                  maxLines: 1,
                  style: valueTextStyle,
                  decoration: valueDecoration,
                  // The validator receives the text that the user has entered.
                  validator: validator,
                ),
              ))
        ],
      ),
    );
  }

  Widget getDropDown({
    required String fieldName,
    required String initialValue,
    required builder,
  }) {
    EdgeInsets padding = const EdgeInsets.only(left: 20.0);

    EdgeInsets expandedPadding =
        const EdgeInsets.only(top: 5.0, bottom: 0.0, right: 20.0);

    TextStyle labelTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: appStyles.fontGilroy,
        fontSize: 16);

    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Padding(
                  padding: padding,
                  child: Text(
                    fieldName,
                    maxLines: 1,
                    style: labelTextStyle,
                  ))),
          Expanded(
              flex: 2,
              child: Padding(
                padding: expandedPadding,
                child: FormField<String>(
                  builder: builder,
                ),
              ))
        ],
      ),
    );
  }

  Widget getUserCreds(
      {required String fieldName,
      required String initialValue,
      required validator,
      bool isPassword = false}) {
    EdgeInsets padding = const EdgeInsets.only(left: 20.0);

    EdgeInsets expandedPadding =
        const EdgeInsets.only(top: 5.0, bottom: 0.0, right: 20.0);

    TextStyle labelTextStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: appStyles.fontGilroy,
        fontSize: 16);

    TextStyle valueTextStyle = TextStyle(
        fontSize: 15,
        fontFamily: appStyles.fontGilroy,
        color: Colors.grey.shade500,
        fontWeight: FontWeight.w300);

    InputDecoration valueDecoration = InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      fillColor: appStyles.sbGrey,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: appStyles.sbBlue),
      ),

      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 0.0),
      ),
      border: const OutlineInputBorder(),
      // labelText: fieldName == "Address" ? "Line 1" :  fieldName == "" ? "Line 2" : fieldName
    );

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: Padding(
            padding: padding,
            child: Text(
              fieldName,
              maxLines: 1,
              style: labelTextStyle,
            ),
          )),
          Expanded(
              flex: 2,
              child: Padding(
                padding: expandedPadding,
                child: TextFormField(
                    readOnly: true,
                    obscureText: isPassword,
                    enableSuggestions: false,
                    autocorrect: false,
                    initialValue: initialValue,
                    maxLines: 1,
                    style: valueTextStyle,
                    decoration: valueDecoration,
                    // The validator receives the text that the user has entered.
                    validator: validator),
              ))
        ],
      ),
    );
  }

  // Cubit calls -> Start <-
  Future<void> fetchProfile({required BuildContext context}) async {
    Future.microtask(() {
      context.read<AnglerProfilePageCubit>().fetchAnglerProfile();
    });
  }

  void logout({required BuildContext context}) async {
    await deleteAuthBox();
    await Future.microtask(() {
      context.read<AnglerProfilePageCubit>().logout();
      context.read<AuthenticationStatusCubit>().onLogoutStateChange();
      context.read<HomePageCubit>().refresh(true);
    });
  }

  void resetPassword({required BuildContext context}) {
    Future.microtask(() {
      context.read<AnglerProfilePageCubit>().resetPassword();
    });
  }

  void updateUserDetails(
      {required BuildContext context, required AnglerProfile profile}) {
    Future.microtask(() {
      context
          .read<AnglerProfilePageCubit>()
          .updateUserDetails(profile: profile);
    });
    // fetchProfile(context:context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                AnglerProfilePageCubit(apiProvider: apiProvider)),
      ],
      child: BlocConsumer<AnglerProfilePageCubit, AnglerProfilePageState>(
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case AnglerProfilePageInitial:
              fetchProfile(context: context);
              return buildCenterLoading;

            case AnglerProfileLoaded:
              state as AnglerProfileLoaded;
              return getUserProfileWidget(
                  context: context, profile: state.profile);

            case AnglerProfileFailed:
              return const Center(
                child: Text("Server Failed to respond, try again later."),
              );

            case AnglerLogout:
              return const Center(
                child: Text("Server Failed to respond, try again later."),
              );

            default:
              return buildCenterLoading;
          }
        },
      ),
    );
  }

  Widget getUserProfileWidget(
      {required BuildContext context, required AnglerProfile profile}) {
    _currentSelectedValue = profile.yearsAngling;
    _currentSelectedSpecies1 = profile.personalBest[0].speciesName!;
    _currentSelectedSpecies2 = profile.personalBest[1].speciesName!;

    _currentSelectedWeight1 = profile.personalBest[0].weight!;
    _currentSelectedWeight2 = profile.personalBest[1].weight!;
    checkedValue = profile.isPublic ?? false;

    List<String> anglingExperience = [
      "",
      "1",
      "2",
      "3",
      "4",
      "5+",
      "10+",
      "20+",
      "30+"
    ];

    List<String> species = [
      "",
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

    List<String> weights = [
      "",
      "<10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
      "20",
      "21",
      "22",
      "23",
      "24",
      "25",
      "26",
      "27",
      "28",
      "29",
      "30",
      "31",
      "32",
      "33",
      "34",
      "35",
      "36",
      "37",
      "38",
      "39",
      "40",
      "41",
      "42",
      "43",
      "44",
      "45",
      "46",
      "47",
      "48",
      "49",
      "50+"
    ];

    imagePicker = ImagePickerHandler(this, _controller, context);
    imagePicker.init();

    species1Builder(FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          fillColor: isReadOnly ? appStyles.sbGrey : Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appStyles.sbBlue),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          border: const OutlineInputBorder(),
        ),
        isEmpty: _currentSelectedSpecies1 == '',
        child: IgnorePointer(
          ignoring: isReadOnly,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: appStyles.sbBlue,
              value: _currentSelectedSpecies1,
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  _currentSelectedSpecies1 = newValue!;
                  profile.personalBest[0].speciesName = newValue;
                  state.didChange(newValue);
                });
              },
              items: species.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: appStyles.fontGilroy,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }

    species2Builder(FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          fillColor: isReadOnly ? appStyles.sbGrey : Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appStyles.sbBlue),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          border: const OutlineInputBorder(),
        ),
        isEmpty: _currentSelectedSpecies2 == '',
        child: IgnorePointer(
          ignoring: isReadOnly,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: appStyles.sbBlue,
              value: _currentSelectedSpecies2,
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  _currentSelectedSpecies2 = newValue!;
                  profile.personalBest[1].speciesName = newValue;
                  state.didChange(newValue);
                });
              },
              items: species.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: appStyles.fontGilroy,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }

    weight1Builder(FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          fillColor: isReadOnly ? appStyles.sbGrey : Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appStyles.sbBlue),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          border: const OutlineInputBorder(),
        ),
        isEmpty: _currentSelectedWeight1 == '',
        child: IgnorePointer(
          ignoring: isReadOnly,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: appStyles.sbBlue,
              value: _currentSelectedWeight1,
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  _currentSelectedWeight1 = newValue!;
                  profile.personalBest[0].weight = newValue;
                  state.didChange(newValue);
                });
              },
              items: weights.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: appStyles.fontGilroy,
                      fontSize: 15,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }

    weight2Builder(FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          fillColor: isReadOnly ? appStyles.sbGrey : Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appStyles.sbBlue),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          border: const OutlineInputBorder(),
        ),
        isEmpty: _currentSelectedWeight2 == '',
        child: IgnorePointer(
          ignoring: isReadOnly,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: appStyles.sbBlue,
              value: _currentSelectedWeight2,
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  _currentSelectedWeight2 = newValue!;
                  profile.personalBest[1].weight = newValue;
                  state.didChange(newValue);
                });
              },
              items: weights.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: appStyles.fontGilroy,
                      fontSize: 13,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }

    yearsAnglingBuilder(FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          fillColor: isReadOnly ? appStyles.sbGrey : Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appStyles.sbBlue),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.0),
          ),
          border: const OutlineInputBorder(),
        ),
        isEmpty: _currentSelectedValue == '',
        child: IgnorePointer(
          ignoring: isReadOnly,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: appStyles.sbBlue,
              value: _currentSelectedValue,
              isDense: true,
              onChanged: (newValue) {
                setState(() {
                  _currentSelectedValue = newValue!;
                  profile.yearsAngling = newValue;
                  state.didChange(newValue);
                });
              },
              items: anglingExperience.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontFamily: appStyles.fontGilroy,
                      fontSize: 15,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/fishingmotif.png"),
          alignment: Alignment.bottomRight,
          fit: BoxFit.cover,
          scale: 0.5,
          colorFilter:
              ColorFilter.mode(Colors.white.withOpacity(0.1), BlendMode.dstIn),
        ),
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: context.dynamicHeight(0.05),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: context.dynamicHeight(0.05),
                  left: context.dynamicWidth(0.0)),
              child: Text("Your Profile",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontFamily: appStyles.fontGilroy,
                      fontWeight: FontWeight.w500)),
            ),
            Container(
              margin: EdgeInsets.only(
                top: context.dynamicHeight(0.014),
              ),
              child: AutoSizeText(
                "Welcome back ${profile.firstName}",
                style: TextStyle(
                    fontSize: 22.0,
                    color: appStyles.sbBlue,
                    fontFamily: appStyles.fontGilroy,
                    fontWeight: FontWeight.bold),
                minFontSize: 15,
                maxFontSize: 22,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: context.dynamicHeight(0.025),
              ),
              child: SizedBox(
                height: 200,
                width: 200,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTap: () => imagePicker.showDialog(context),
                      child: Center(
                          child: _image == null
                              ? Stack(
                                  children: <Widget>[
                                    Center(
                                      child: CircleAvatar(
                                          radius: 180.0,
                                          backgroundColor: appStyles.sbBlue,
                                          backgroundImage:
                                              profile.profileImage != null
                                                  ? NetworkImage(
                                                      profile.profileImage!)
                                                  : null),
                                    ),
                                  ],
                                )
                              : CircleAvatar(
                                  radius: 100.0,
                                  backgroundImage:
                                      NetworkImage(profile.profileImage!),
                                  backgroundColor: Colors.transparent,
                                )),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: context.dynamicHeight(0.03)),
              child: Text("Personal Details",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontFamily: appStyles.fontGilroy,
                      fontWeight: FontWeight.w500)),
            ),
            Form(
                key: _formKey,
                child: Column(children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  getFormRow(
                      fieldName: "First Name",
                      initialValue: profile.firstName,
                      profile: profile),
                  getFormRow(
                      fieldName: "Last Name",
                      initialValue: profile.lastName,
                      profile: profile),
                  getFormRow(
                      fieldName: "Address",
                      initialValue: profile.addressLine1 ?? '',
                      profile: profile),
                  getFormRow(
                      fieldName: "",
                      initialValue: profile.addressLine2 ?? '',
                      profile: profile),
                  getFormRow(
                      fieldName: "City",
                      initialValue: profile.city ?? '',
                      profile: profile),
                  getFormRow(
                      fieldName: "Post Code",
                      initialValue: profile.postcode ?? '',
                      profile: profile),
                  const SizedBox(
                    height: 50.0,
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'swim',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: appStyles.fontGilroy,
                                color: appStyles.sbBlue,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: 'booker Login Details',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: appStyles.fontGilroy,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  getUserCreds(
                    fieldName: 'Email',
                    initialValue: profile.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  getUserCreds(
                    fieldName: 'Password',
                    initialValue: "getAlifeMan!",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      child: Text(
                        "Reset Password",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: appStyles.fontGilroy,
                          color: Colors.red,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        resetPassword(context: context);
                        Navigator.of(context).pushNamed('/angler/login/home');
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Text("Angling Experience",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontFamily: appStyles.fontGilroy,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 20.0,
                  ),
                  isReadOnly
                      ? getFormRow(
                          fieldName: 'Years Angling',
                          initialValue: profile.yearsAngling,
                          profile: profile)
                      : getDropDown(
                          fieldName: 'Years Angling',
                          initialValue: profile.yearsAngling,
                          builder: yearsAnglingBuilder),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Text("Personal Best (PB)",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontFamily: appStyles.fontGilroy,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 10.0,
                  ),
                  isReadOnly
                      ? getFormRow(
                          fieldName: 'Species',
                          initialValue: _currentSelectedSpecies1,
                          profile: profile)
                      : getDropDown(
                          fieldName: 'Species',
                          initialValue: _currentSelectedSpecies1,
                          builder: species1Builder),
                  isReadOnly
                      ? getFormRow(
                          fieldName: 'Weight',
                          initialValue: _currentSelectedWeight1,
                          profile: profile)
                      : getDropDown(
                          fieldName: 'Weight',
                          initialValue: _currentSelectedWeight1,
                          builder: weight1Builder),
                  const SizedBox(
                    height: 20.0,
                  ),
                  isReadOnly
                      ? getFormRow(
                          fieldName: 'Species',
                          initialValue: _currentSelectedSpecies2,
                          profile: profile)
                      : getDropDown(
                          fieldName: 'Species',
                          initialValue: _currentSelectedSpecies2,
                          builder: species2Builder),
                  isReadOnly
                      ? getFormRow(
                          fieldName: 'Weight',
                          initialValue: _currentSelectedWeight2,
                          profile: profile)
                      : getDropDown(
                          fieldName: 'Weight',
                          initialValue: _currentSelectedWeight2,
                          builder: weight2Builder),
                  const SizedBox(height: 20.0),
                  IgnorePointer(
                    ignoring: isReadOnly,
                    child: CheckboxListTile(
                      title: AutoSizeText(
                        "Allow my angling experiences to be displayed publicly on comments and interactions on the site",
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 17, fontFamily: appStyles.fontGilroy),
                      ),
                      value: checkedValue,
                      onChanged: (newValue) {
                        setState(() {
                          checkedValue = newValue!;
                          profile.isPublic = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.dynamicWidth(0.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ImageIcon(
                                  const AssetImage("assets/auth/lock.png"),
                                  size: 30.0,
                                  color: isReadOnly
                                      ? appStyles.sbBlue
                                      : Colors.green),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                isReadOnly ? "Edit Details" : "Save Details",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: appStyles.fontGilroy,
                                  fontWeight: FontWeight.bold,
                                  color: isReadOnly
                                      ? appStyles.sbBlue
                                      : Colors.green,
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            if (_formKey.currentState!.validate() == true) {
                              setState(() {
                                bool expression = isReadOnly ? false : true;
                                if (isReadOnly == false && expression == true) {
                                  if (_formKey.currentState!.validate() ==
                                      true) {
                                    updateUserDetails(
                                        context: context, profile: profile);
                                  } else {
                                    showAlert(
                                        "Invalid value found in the form");
                                  }
                                }
                                isReadOnly = expression;
                                Timer(
                                  const Duration(milliseconds: 600),
                                  () => scrollController.jumpTo(0.0),
                                );
                              });
                            } else {
                              showAlert("Invalid value found in the form");
                            }
                          },
                        ),
                        GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.clear,
                                size: 30,
                                color: Colors.red,
                              ),
                              AutoSizeText(
                                "Sign Out",
                                maxLines: 1,
                                minFontSize: 12,
                                maxFontSize: 20,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: appStyles.fontGilroy,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            logout(context: context);
                            // Navigator.of(context).pushNamed('/angler/login');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80.0,
                  ),
                ])),
          ],
        ),
      ),
    );
  }

  @override
  userImage(File image) {
    setState(() {
      // print(image);
      _image = image;
    });
  }
}
