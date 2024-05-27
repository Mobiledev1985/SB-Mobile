// import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sb_mobile/features/fishery_profile/cubit/fishery_profile_cubit.dart';
import 'package:sb_mobile/features/fishery_profile/view/widgets.dart/sb_close_button.dart';

class FullScreenSlider extends StatefulWidget {
  final List<String> images;
  final int index;
  final CarouselController prevPageController;

  const FullScreenSlider({
    super.key,
    required this.images,
    required this.index,
    required this.prevPageController,
  });

  @override
  State<FullScreenSlider> createState() => _FullScreenSliderState();
}

class _FullScreenSliderState extends State<FullScreenSlider> {
  late PageController controller;
  @override
  void initState() {
    controller = PageController(
        initialPage: context.read<FisheryProfileCubit>().state.sliderIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FisheryProfileCubit, FisheryProfileState>(
      builder: (context, state) {
        // print(state.sliderIndex);
        return Scaffold(
          backgroundColor: Colors.grey,
          body: Stack(
            children: [
              InteractiveViewer(
                child: Center(
                  child: PageView.builder(
                    controller: controller,
                    itemCount: widget.images.length,
                    itemBuilder: (context, index) {
                      return InteractiveViewer(
                        child: CachedNetworkImage(
                          imageUrl: widget.images[index],
                          width: double.infinity,
                          height: 280.h,
                          errorWidget: (context, url, error) => Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 280.h,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      // context
                      //     .read<FisheryProfileCubit>()
                      //     .updateSliderIndex(index);

                      widget.prevPageController.jumpToPage(state.sliderIndex);
                    },
                  ),
                ),
              ),
              const SbCloseButton(),
            ],
          ),
        );
      },
    );
  }
}
