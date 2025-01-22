import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/home/controller/address_controller.dart';
import 'package:ride_sharing_user_app/view/screens/home/model/address_model.dart';
import 'package:ride_sharing_user_app/view/screens/address/add_new_address.dart';
import 'package:ride_sharing_user_app/view/widgets/confirmation_dialog.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({super.key});

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<AddressController>().getAddressList(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: CustomAppBar(title: 'my_address'.tr, centerTitle: true,),
        body: GetBuilder<AddressController>(builder: (addressController) {
          return addressController.addressList != null ? addressController.addressList!.isNotEmpty ? ListView.builder(
            itemCount: addressController.addressList!.length,
            shrinkWrap: true,
            addRepaintBoundaries: false,
            addAutomaticKeepAlives: false,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => AddressCard(address: addressController.addressList![index]),
          ) : const NoDataScreen(title: 'no_address_found',) : Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,));
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).cardColor,
        child: Icon(Icons.add_circle, color: Theme.of(context).primaryColor,size: Dimensions.iconSizeExtraLarge,),
        onPressed: () {
          Get.to(() =>  const AddNewAddress());
        }
      ),

    );
  }
}

class AddressCard extends StatelessWidget {
  final Address address;
  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, 0),
      child: Container(decoration: BoxDecoration(color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraLarge),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.25))),
        child: Padding(padding: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
          child: Row(children: [
            Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.5))),
              child: Padding(padding: const EdgeInsets.all(8.0),
                child: SizedBox(width: Dimensions.iconSizeLarge, child: Image.asset(
                  address.addressLabel == 'home' ? Images.homeOutline:address.addressLabel == 'office'
                      ? Images.office: Images.other,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                )),
              ),
            ),

            Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(address.addressLabel!.tr,
                  style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor)),
                Text(address.address!),
              ]),
            )),

            InkWell(
              onTap: ()=> Get.to(() =>  AddNewAddress(address: address)),
              child: SizedBox(width: Dimensions.iconSizeLarge,
                child: Image.asset(Images.editIcon)),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            InkWell(onTap: () {
              Get.dialog(ConfirmationDialog(
                icon: Images.completeIcon,
                description: 'are_you_sure'.tr,
                onYesPressed: () {
                  Get.find<AddressController>().deleteAddress(address.id.toString());
                },
              ), barrierDismissible: false);

            },
              child: SizedBox(width: Dimensions.iconSizeLarge, child: Image.asset(Images.delete))),

          ]),
        ),
      ),
    );
  }
}
