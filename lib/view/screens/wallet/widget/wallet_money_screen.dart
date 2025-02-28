import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/controller/wallet_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/transaction_card_widget.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/wallet_money_amount_widget.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/custom_title.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';


class WalletMoneyScreen extends StatefulWidget {
  const WalletMoneyScreen({super.key});

  @override
  State<WalletMoneyScreen> createState() => _WalletMoneyScreenState();
}

class _WalletMoneyScreenState extends State<WalletMoneyScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<WalletController>(builder: (walletController) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        const SizedBox(height: Dimensions.paddingSizeDefault),
        const WalletMoneyAmountWidget(walletMoney: true),

        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: CustomTitle(title: 'wallet_history'.tr,color: Theme.of(context).textTheme.displayLarge!.color),),
        const Padding(padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault), child:  Divider(thickness: .25,)),

        walletController.transactionModel?.data != null ? (walletController.transactionModel!.data!.isNotEmpty) ? Expanded(child: SingleChildScrollView(
          controller: scrollController,
          child: PaginatedListView(
            scrollController: scrollController,
            totalSize: walletController.transactionModel!.totalSize,
            offset: (walletController.transactionModel?.offset != null) ? int.parse(walletController.transactionModel!.offset.toString()) : null,
            onPaginate: (int? offset) async {
              await walletController.getTransactionList(offset!);
            },
            itemView: ListView.builder(
              itemCount: walletController.transactionModel!.data!.length,
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return TransactionCard(transaction: walletController.transactionModel!.data![index]);
              },
            ),
          ),
        )) : const Expanded(child: NoDataScreen(title: 'no_transaction_found')) : const Expanded(child: NotificationShimmer()),


      ]);
    });
  }
}

