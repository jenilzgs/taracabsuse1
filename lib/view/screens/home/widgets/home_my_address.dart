import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/home/controller/address_controller.dart';
import 'package:ride_sharing_user_app/view/screens/address/add_new_address.dart';
import 'package:ride_sharing_user_app/view/screens/address/widgets/address_item_card.dart';
import 'package:ride_sharing_user_app/view/screens/home/widgets/address_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/custom_title.dart';

enum AddressPage{home, sender, receiver}

class HomeMyAddress extends StatefulWidget {
  final String? title;
  final AddressPage? addressPage;
  const HomeMyAddress({super.key, this.title, this.addressPage});

  @override
  State<HomeMyAddress> createState() => _HomeMyAddressState();
}

class _HomeMyAddressState extends State<HomeMyAddress> {
  bool listEmpty = true;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<AddressController>(builder: (addressController) {
        return Column(children: [

          CustomTitle(title: widget.title ?? 'my_address'.tr, color: Theme.of(context).textTheme.displayLarge!.color),

          addressController.addressList != null ? addressController.addressList!.isNotEmpty ? SizedBox(
            height: 35,
            child: ListView.builder(
              itemCount: addressController.addressList!.length,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index) {
                return AddressItemCard(address: addressController.addressList![index], addressPage: widget.addressPage);
              },
            ),
          ) : InkWell(
            onTap: ()=> Get.to(() =>   const AddNewAddress(address: null)),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  color : Get.isDarkMode? Theme.of(context).canvasColor : Theme.of(context).colorScheme.onSecondary.withOpacity(.03)
              ),
              child: Row(children: [

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Container(width: Dimensions.buttonSize,
                    height: Dimensions.buttonSize,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode? Theme.of(context).cardColor :Theme.of(context).primaryColor.withOpacity(.07),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                    ),child: Center(child: Icon(Icons.add, color: Theme.of(context).primaryColor)),),
                ),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('add_address'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    Text('type_or_select_from_map'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  ]),
                ),
                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: SizedBox(width: 100, child: Image.asset(Images.addNewAddress)),
                ),

              ]),
            ),
          ) : const AddressShimmer(),

        ]);
      }
    );
  }
}
