import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/controller/wallet_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/convert_point_to_wallet_money.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/custom_title.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/loyalty_point_card.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/wallet_money_amount_widget.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';


class LoyaltyPointScreen extends StatefulWidget {
  const LoyaltyPointScreen({super.key});

  @override
  State<LoyaltyPointScreen> createState() => _LoyaltyPointScreenState();
}

class _LoyaltyPointScreenState extends State<LoyaltyPointScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<WalletController>(builder: (walletController) {
      return  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        const WalletMoneyAmountWidget(),

        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: CustomTitle(title: 'point_history'.tr, color: Theme.of(context).textTheme.displayLarge!.color),),
        const Padding(padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault), child:  Divider(thickness: .125,)),

        walletController.isConvert == false ? Expanded(
          child: walletController.loyaltyPointModel?.data != null ? (walletController.loyaltyPointModel!.data!.isNotEmpty) ? SingleChildScrollView(
            controller: scrollController,
            child: PaginatedListView(scrollController: scrollController,
              totalSize: walletController.loyaltyPointModel!.totalSize,
              offset: (walletController.loyaltyPointModel?.offset != null) ? int.parse(walletController.loyaltyPointModel!.offset.toString()) : null,
              onPaginate: (int? offset) async {
                await walletController.getTransactionList(offset!);
              },
              itemView: ListView.builder(
                itemCount: walletController.loyaltyPointModel!.data!.length,
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return LoyaltyPointCard(points: walletController.loyaltyPointModel!.data![index]);
                },
              ),
            ),
          ) : const NoDataScreen(title: 'no_transaction_found') : const NotificationShimmer(),

        ) : Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

          InkWell(
            onTap: () => walletController.toggleConvertCard(false),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall,
              ),
              child: Text('back_to_transaction'.tr,
                style: textMedium.copyWith(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline),
              ),
            ),
          ),
          const ConvertPointToWalletMoney(),

        ])),

        walletController.isConvert ? Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: walletController.isLoading ?  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)) : CustomButton(
            buttonText: 'convert_point'.tr,
            onPressed: () {
            String point = walletController.inputController.text;
              if(point.isEmpty) {
                showCustomSnackBar('please_input_point'.tr);
              }else if(double.parse(point)< Get.find<ConfigController>().config!.conversionRate!) {
                showCustomSnackBar('${'minimum_conversion_point'.tr}: ${Get.find<ConfigController>().config!.conversionRate!}');
              }else{
                walletController.convertPoint(point).then((value) {
                  if(value.statusCode == 200){
                    walletController.inputController.clear();
                    walletController.toggleConvertCard(true);
                  }
                });
              }
            },
          ),
        ) : const SizedBox(),

      ]);
    });
  }
}

