import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/view/screens/coupon/controller/coupon_controller.dart';
import 'package:ride_sharing_user_app/view/screens/coupon/widget/coupon_widget.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<CouponController>().getCouponList(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CustomBody(
      appBar: CustomAppBar(title: 'coupon'.tr, centerTitle: true),
      body: GetBuilder<CouponController>(builder: (couponController) {
        return Column(children: [


          couponController.couponModel != null ? (couponController.couponModel!.data != null && couponController.couponModel!.data!.isNotEmpty) ? SingleChildScrollView(
            controller: scrollController,
            child: PaginatedListView(
              scrollController: scrollController,
              totalSize: couponController.couponModel!.totalSize,
              offset: (couponController.couponModel != null && couponController.couponModel!.offset != null) ? int.parse(couponController.couponModel!.offset.toString()) : null,
              onPaginate: (int? offset) async {
                await couponController.getCouponList(offset!);
              },
              itemView: ListView.builder(
                itemCount: couponController.couponModel!.data!.length,
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return CouponWidget(coupon: couponController.couponModel!.data![index]);
                },
              ),
            ),
          ) : const Expanded(child: NoDataScreen(title: 'no_coupon_found',)):const Expanded(child: NotificationShimmer()),

        ]);
      }),
    ));
  }
}
