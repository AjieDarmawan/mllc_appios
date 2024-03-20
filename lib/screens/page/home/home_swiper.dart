import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/widget/app_placeholder.dart';

class HomeSwipe extends StatelessWidget {
  final double height;
  final List<String>? images;

  final SwiperController? swiperControllerbanner_;

  bool isAutoPlayEnabledbanner = true;
  HomeSwipe({
    Key? key,
    this.images,
    this.swiperControllerbanner_,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images != null) {
      return Swiper(
        controller: swiperControllerbanner_,
        onTap: (int index) {
          print("Banner_State_index ${index}");
        },
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            imageUrl: images![index],
            placeholder: (context, url) {
              return AppPlaceholder(
                child: Container(
                  color: Colors.white,
                ),
              );
            },
            imageBuilder: (context, imageProvider) {
              return Container(
                margin: const EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) {
              return AppPlaceholder(
                  child: Container(
                color: Colors.white,
                child: const Icon(Icons.error),
              ));
            },
          );
        },
        autoplayDelay: 8000,
        autoplayDisableOnInteraction: true,
        autoplay: isAutoPlayEnabledbanner,
        itemCount: images!.length,
        pagination: const SwiperPagination(
          // alignment: Alignment(0.0, 0.3),
          alignment: Alignment.bottomCenter,
          builder: DotSwiperPaginationBuilder(
              color: Colors.white, activeColor: kThirdColor),
        ),
      );
    }

    ///Loading
    return Container(
      color: Theme.of(context).backgroundColor,
      // child: AppPlaceholder(
      //   child: Container(
      //     margin: const EdgeInsets.only(bottom: 2),
      //     color: Colors.white,
      //   ),
      // ),
    );
  }
}
