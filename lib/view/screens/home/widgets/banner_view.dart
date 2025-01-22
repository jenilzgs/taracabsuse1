import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/home/controller/banner_controller.dart';
import 'package:ride_sharing_user_app/view/screens/home/widgets/banner_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerView extends StatefulWidget {
  const BannerView({super.key});

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  @override
  Widget build(BuildContext context) {
    String baseurl = Get.find<ConfigController>().config!.imageBaseUrl!.banner!;
    return GetBuilder<BannerController>(
      builder: (bannerController) {

        return  SizedBox(width: MediaQuery.of(context).size.width,
          height: (bannerController.bannerList != null && bannerController.bannerList!.isNotEmpty)? 130 : 0,
          child: bannerController.bannerList != null? bannerController.bannerList!.isNotEmpty?
          CarouselSlider.builder(
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: false,
              viewportFraction: 1,
              disableCenter: true,
              autoPlayInterval: const Duration(seconds: 7),
              onPageChanged: (index, reason) {
              },
            ),
            itemCount: bannerController.bannerList!.length,
            itemBuilder: (context, index, _) {
              return InkWell(onTap: (){
                bannerController.updateBannerClickCount(bannerController.bannerList![index].id!);
                debugPrint("=click===> ${bannerController.bannerList![index].redirectLink!}");
                if(bannerController.bannerList![index].redirectLink != null){
                  _launchUrl(Uri.parse(bannerController.bannerList![index].redirectLink!));
                }},
                child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
                  child: CustomImage(image: '$baseurl/${bannerController.bannerList![index].image}', fit: BoxFit.cover)),
              );
            },
          ):const SizedBox() : const BannerShimmer()
        );
      },
    );
  }
}
Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}