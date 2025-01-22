import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/model/transaction_model.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/wallet_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';


class PointGainedCard extends StatelessWidget {
  final Transaction myEarnModel;
  const PointGainedCard({super.key, required this.myEarnModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: const CustomAppBar(title: "Con",showBackButton: true,),
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: Get.height*0.2,),
            Image.asset(Images.loyaltyPoint,width: 100,),
            const SizedBox(height: Dimensions.paddingSizeDefault),

            Text.rich(TextSpan(style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)),
              children:  [TextSpan(text: 'your_point'.tr,),
                TextSpan(text: 'just_converted'.tr,style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
                TextSpan(text: 'to_your_wallet'.tr),
                TextSpan(text: 'successfully'.tr,style: textMedium.copyWith(color: Theme.of(context).primaryColor))]),
                textAlign: TextAlign.center),


              const Expanded(child: SizedBox()),
              Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: TextButton(onPressed: () => Get.to(() => const WalletScreen()),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero,
                    minimumSize: const Size(50,30), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text('check_wallet'.tr, style: textMedium.copyWith(decoration: TextDecoration.underline,
                    color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
                ),
              )


            ],
          ),
      ),
    );
  }
}
