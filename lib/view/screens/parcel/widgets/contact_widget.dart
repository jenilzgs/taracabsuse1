import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/message/controller/message_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactWidget extends StatelessWidget {
  final String driverId;
   ContactWidget({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(
      builder: (rideController) {
        return Center(child: Container(width: 250,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              border: Border.all(width: .75, color: Theme.of(context).primaryColor)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [


              InkWell(onTap: () => Get.find<MessageController>().createChannel(driverId),
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                    child: SizedBox(width: Dimensions.iconSizeLarge,child: Image.asset(Images.customerMessage)))),


              Container(width: 1,height: 25,color: Theme.of(context).primaryColor),
              InkWell(onTap: () async  =>  await launchUrl(launchUri,mode: LaunchMode.externalApplication),
                child: Padding(padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                  child: SizedBox(width: Dimensions.iconSizeLarge, child: Image.asset(Images.customerCall)))),

            ],),
          ),
        );
      }
    );
  }

  final Uri launchUri =  Uri(
    scheme: 'tel',
    path: "https://6amtech.com",
  );
}
