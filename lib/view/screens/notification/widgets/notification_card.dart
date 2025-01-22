import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/notification/model/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final Notifications notification;
  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).primaryColor.withOpacity(0.07),
        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(children: [

          Expanded(child: Text(
            notification.title ?? '',
            style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
          )),

          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall), child: Row(children: [
            Text(DateConverter.isoStringToLocalDateOnly(notification.createdAt!)),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Icon(Icons.alarm, size: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor.withOpacity(0.5)),
          ])),
        ]),

        Text(notification.description ?? ''),

      ]),
    );
  }
}
