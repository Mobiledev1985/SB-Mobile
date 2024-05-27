import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sb_mobile/core/constant/app_colors.dart';
import 'package:sb_mobile/core/constant/app_images.dart';
import 'package:sb_mobile/core/constant/app_strings.dart';
import 'package:sb_mobile/core/extension/context_extension.dart';
import 'package:sb_mobile/core/notification/web_view_screen.dart';
import 'package:sb_mobile/core/routes/route_paths.dart';
import 'package:sb_mobile/core/widgets/back_button.dart';
import 'package:sb_mobile/core/widgets/space_horizontal.dart';
import 'package:sb_mobile/core/widgets/space_vertical.dart';
import 'package:sb_mobile/features/authentication/data/models/angler_profile_details_model.dart';
import 'package:sb_mobile/features/my_profile/data/models/booking_model.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/booking_item_widget.dart';
import 'package:sb_mobile/features/my_profile/ui/widgets/profile_bar.dart';
import 'package:url_launcher/url_launcher.dart';

typedef ViewTicketScreenData = ({
  BookingItem bookingItem,
  AnglerProfile profile
});

class ViewTicketScreen extends StatefulWidget {
  const ViewTicketScreen({
    super.key,
    required this.viewTicketScreenData,
  });

  final ViewTicketScreenData viewTicketScreenData;

  @override
  State<ViewTicketScreen> createState() => _ViewTicketScreenState();

  static MaterialPageRoute<dynamic> buildRouter(
      ViewTicketScreenData viewTicketScreenData) {
    return MaterialPageRoute(
      builder: (_) {
        return ViewTicketScreen(
          viewTicketScreenData: viewTicketScreenData,
        );
      },
    );
  }

  static void navigateTo(
    BuildContext context,
    ViewTicketScreenData viewTicketScreenData,
  ) {
    Navigator.pushNamed(
      context,
      RoutePaths.viewTicketScreen,
      arguments: viewTicketScreenData,
    );
  }
}

class _ViewTicketScreenState extends State<ViewTicketScreen> {
  @override
  Widget build(BuildContext context) {
    final BookingItem bookingItem = widget.viewTicketScreenData.bookingItem;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileBar(level: 5, profile: widget.viewTicketScreenData.profile),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 20,
              ),
              child: Row(
                children: [
                  const BackButtonWidget(),
                  const Spacer(),
                  Text(
                    'Ticket',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            ColoredBox(
              color: AppColors.darkBlue,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 26,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            text: '#',
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.blueLightTextColor,
                            ),
                            children: [
                              TextSpan(
                                text: '${bookingItem.bookingPublicId}',
                                style:
                                    context.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blueTextColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SpaceHorizontal(10),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // SvgPicture.asset(
                              //   AppImages.copy,
                              //   colorFilter: const ColorFilter.mode(
                              //     AppColors.blueLightTextColor,
                              //     BlendMode.srcIn,
                              //   ),
                              // ),
                              const SpaceHorizontal(6),
                              Flexible(
                                child: Text(
                                  bookingItem.name ?? '',
                                  style:
                                      context.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blueTextColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SpaceVertical(22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booking Date:',
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blueLightTextColor,
                              ),
                            ),
                            const SpaceVertical(6),
                            if (bookingItem.bookingDate != null)
                              Text(
                                DateFormat('d/M/yyyy').format(
                                  DateTime.parse(bookingItem.bookingDate ?? ''),
                                ),
                                style:
                                    context.textTheme.headlineSmall?.copyWith(
                                  color: AppColors.blueTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Paid:',
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blueLightTextColor,
                              ),
                            ),
                            const SpaceVertical(6),
                            Text(
                              '£${bookingItem.paymentTotal}',
                              style: context.textTheme.headlineSmall?.copyWith(
                                color: AppColors.blueTextColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status:',
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blueLightTextColor,
                              ),
                            ),
                            const SpaceVertical(6),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff3D8CCC),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                bookingItem.arrival != null &&
                                        DateTime.parse(bookingItem.arrival!)
                                            .isAfter(DateTime.now())
                                    ? 'Upcoming'.toUpperCase()
                                    : '${bookingItem.status?.toUpperCase()}',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment:',
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.blueLightTextColor,
                              ),
                            ),
                            const SpaceVertical(6),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff3D8CCC),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                '${bookingItem.paymentStatus?.toUpperCase()}',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            ColoredBox(
              color: AppColors.blueTextColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SpaceVertical(20),
                    Text(
                      'Ticket Details',
                      style: context.textTheme.displaySmall?.copyWith(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SpaceVertical(16),
                    BookingItemWidget(
                      title: AppStrings.noOfAnlers,
                      value:
                          '${widget.viewTicketScreenData.bookingItem.anglers}',
                      isFromTicketView: true,
                    ),
                    BookingItemWidget(
                      title: AppStrings.noOfGuests,
                      value:
                          '${widget.viewTicketScreenData.bookingItem.guests}',
                      isFromTicketView: true,
                    ),
                    BookingItemWidget(
                      title: AppStrings.selected,
                      value:
                          '${widget.viewTicketScreenData.bookingItem.selected}',
                      isFromTicketView: true,
                    ),
                    BookingItemWidget(
                      title: AppStrings.lake,
                      value: '${widget.viewTicketScreenData.bookingItem.name}',
                      isFromTicketView: true,
                    ),
                    BookingItemWidget(
                      title: AppStrings.arrivalDetails,
                      value: DateFormat('HH:mm - d/M/yyyy').format(
                        DateTime.parse(
                            widget.viewTicketScreenData.bookingItem.arrival!),
                      ),
                      isFromTicketView: true,
                    ),
                    BookingItemWidget(
                      title: AppStrings.departureDetails,
                      value: DateFormat('HH:mm - d/M/yyyy').format(
                        DateTime.parse(
                            widget.viewTicketScreenData.bookingItem.departure!),
                      ),
                      isFromTicketView: true,
                    ),
                    if (bookingItem.gateCodes != null)
                      Column(
                        children: [
                          ...bookingItem.gateCodes!
                              .map(
                                (e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: RichText(
                                          text: TextSpan(
                                            text: "${e.name}:",
                                            style: context
                                                .textTheme.headlineSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff174A73),
                                            ),
                                            children: e.description != null &&
                                                    e.description!.isNotEmpty
                                                ? [
                                                    WidgetSpan(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                GateCodeDescriptionDialog(
                                                              description:
                                                                  e.description ??
                                                                      '',
                                                            ),
                                                          );
                                                        },
                                                        child: const Icon(
                                                          CupertinoIcons.info,
                                                          size: 18,
                                                          color: AppColors.blue,
                                                        ),
                                                      ),
                                                    )
                                                  ]
                                                : null,
                                          ),
                                        ),
                                      ),
                                      const SpaceHorizontal(40),
                                      Expanded(
                                        flex: 10,
                                        child: GestureDetector(
                                          onTap: () async {
                                            // Regular expression for URL validation
                                            String url = e.code ?? '';

                                            RegExp regExp = RegExp(
                                              r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?(www\.)?[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$",
                                              caseSensitive: false,
                                              multiLine: false,
                                            );
                                            if (regExp.hasMatch(url)) {
                                              if (url.startsWith('www.')) {
                                                url = 'https://$url';
                                              }
                                              launchUrl(Uri.parse(url));
                                            }
                                          },
                                          child: Text(
                                            e.code ?? '',
                                            textAlign: TextAlign.right,
                                            style: context
                                                .textTheme.headlineSmall
                                                ?.copyWith(
                                              color: const Color(0xff174A73),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList()
                        ],
                      ),
                    const SpaceVertical(20),
                    Text(
                      'Lead Angler Details',
                      style: context.textTheme.displaySmall?.copyWith(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SpaceVertical(16),
                    BookingItemWidget(
                      title: AppStrings.name,
                      value:
                          '${bookingItem.anglerDetails?.firstName} ${bookingItem.anglerDetails?.lastName}',
                      isFromTicketView: true,
                    ),
                    BookingItemWidget(
                      title: AppStrings.contactNumber,
                      value: '${bookingItem.anglerDetails?.phoneNumber}',
                      isFromTicketView: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Text(
                            "${AppStrings.emailAddress}:",
                            textAlign: TextAlign.left,
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff174A73),
                            ),
                          ),
                          const SpaceHorizontal(40),
                          Expanded(
                            flex: 10,
                            child: Text(
                              '${bookingItem.anglerDetails?.email}',
                              textAlign: TextAlign.right,
                              style: context.textTheme.headlineSmall?.copyWith(
                                color: const Color(0xff174A73),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      indent: 76,
                      endIndent: 76,
                      color: AppColors.blueLightTextColor,
                    ),
                    const SpaceVertical(20),
                    Text(
                      'Need to change or cancel this booking?',
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SpaceVertical(4),
                    Text(
                      '(You may not be eligible for a refund)',
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SpaceVertical(16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WebViewScreen(
                              url: '',
                              isGoBackToHomeScreen: false,
                              title: 'Contact us',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffD95757),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Cancel Booking',
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SpaceVertical(16),
                    const Divider(
                      indent: 76,
                      endIndent: 76,
                      color: AppColors.blueLightTextColor,
                    ),
                    const SpaceVertical(16),
                    Text(
                      'Questions?',
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SpaceVertical(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.phone,
                            width: 16,
                            height: 16,
                          ),
                          const SpaceHorizontal(6),
                          Text(
                            'Phone',
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '+44 (0)208 194 9396',
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceVertical(6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.emailInviteIcon,
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                              AppColors.darkBlue,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SpaceHorizontal(6),
                          Text(
                            'Email',
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'support@swimbooker.com',
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: AppColors.darkBlue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpaceVertical(60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GateCodeDescriptionDialog extends StatelessWidget {
  const GateCodeDescriptionDialog({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: AppColors.secondaryBlue,
          width: 3,
        ),
      ),
      backgroundColor: AppColors.blue,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Text(
                        'Description',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.close,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceVertical(10),
              GestureDetector(
                onTap: () async {
                  String url = description;

                  RegExp regExp = RegExp(
                    r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?(www\.)?[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$",
                    caseSensitive: false,
                    multiLine: false,
                  );
                  if (regExp.hasMatch(url)) {
                    if (url.startsWith('www.')) {
                      url = 'https://$url';
                    }
                    launchUrl(Uri.parse(url));
                  }
                },
                child: Text(
                  description,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    height: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
