import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/notification/controller/notification_controller.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widgets/notification_card.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Get.find<NotificationController>().getNotificationList(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBody(
      appBar:  CustomAppBar(title: 'notification'.tr, showBackButton: false,),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Expanded(child: GetBuilder<NotificationController>(builder: (notificationController) {
            return notificationController.notificationModel != null ? (notificationController.notificationModel!.data != null && notificationController.notificationModel!.data!.isNotEmpty) ? SingleChildScrollView(controller: scrollController,
              child: PaginatedListView(
                scrollController: scrollController,
                totalSize: notificationController.notificationModel!.totalSize,
                offset: (notificationController.notificationModel != null && notificationController.notificationModel!.offset != null) ? int.parse(notificationController.notificationModel!.offset.toString()) : null,
                onPaginate: (int? offset) async {
                  await notificationController.getNotificationList(offset!);
                },
                itemView: ListView.builder(
                  itemCount: notificationController.notificationModel!.data!.length,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return NotificationCard(notification: notificationController.notificationModel!.data![index]);
                  },
                ),
              ),
            ) : NoDataScreen(title: 'no_notification_found'.tr) : const NotificationShimmer();
          })),

          Container(height: 70),

        ]),
      ),
    );
  }
}
