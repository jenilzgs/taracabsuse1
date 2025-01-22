import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/home/controller/address_controller.dart';
import 'package:ride_sharing_user_app/view/screens/home/model/address_model.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_text_field.dart';

class AddNewAddress extends StatefulWidget {
  final Address? address;
  const AddNewAddress({super.key, this.address});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController roadController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  CameraPosition? _cameraPosition;
  GoogleMapController? _mapController;

  @override
  void initState() {
    if(widget.address != null) {
      Get.find<LocationController>().locationController.text = widget.address!.address!;
      houseController.text = widget.address!.house ?? '';
      roadController.text = widget.address!.street ?? '';
      Get.find<AddressController>().updateAddressIndex(widget.address!.addressLabel! == 'home' ? 0 : widget.address!.addressLabel! == 'office' ? 1 : 2, false);
      _cameraPosition = CameraPosition(target: LatLng(widget.address!.latitude!, widget.address!.longitude!));
    }
    phoneController.text = Get.find<ProfileController>().profileModel!.data!.phone! ?? "";
    nameController.text = '${Get.find<ProfileController>().profileModel!.data!.firstName!} ${Get.find<ProfileController>().profileModel!.data!.lastName!}';
    super.initState();
  }
  @override
  void dispose() {
    Get.find<LocationController>().mapController?.dispose();
    _mapController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: CustomAppBar(title: 'add_address'.tr, centerTitle: true),
        body: GetBuilder<AddressController>(builder: (addressController) {
          return GetBuilder<LocationController>(builder: (locationController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Stack(children: [

                    ClipRRect(borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.paddingSizeExtraLarge),
                        topRight: Radius.circular(Dimensions.paddingSizeExtraLarge)),
                      child: SizedBox(height: 300, width: Get.width, child: GoogleMap(
                        mapType: MapType.terrain,
                        initialCameraPosition:  CameraPosition(
                          target: widget.address != null ? LatLng(
                            widget.address!.latitude!, widget.address!.longitude!,
                          ) : locationController.initialPosition, zoom: 16),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                          _mapController!.setMapStyle(
                            Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                          );

                          locationController.mapController = controller;


                        },
                        onCameraIdle: () {
                          if(_cameraPosition != null) {
                            locationController.updatePosition(_cameraPosition!, false, null);
                          }
                        },
                        onCameraMove: ((position) => _cameraPosition = position),
                        minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        indoorViewEnabled: true,
                        mapToolbarEnabled: true,
                      )),
                    ),

                    Positioned(child: Padding(
                      padding: const EdgeInsets.only(top: 120),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(width: 50,height: 50, child: Image.asset(Images.pickLocation)),
                      ),
                    )),

                    Positioned(child: Padding(
                      padding: const EdgeInsets.only(top: 230),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: ()=> Get.to(() => PickMapScreen(type: LocationType.location, onLocationPicked: (Position position, String address) {
                            locationController.mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                              position.latitude, position.longitude,
                            ), zoom: 16)));
                            locationController.locationController.text = address;
                          })),
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                              ),
                              width: 40,height: 40,
                              child: Icon(Icons.fullscreen, color: Theme.of(context).hintColor),
                            ),
                          ),
                        ),
                      ),
                    )),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    child: Text('choose_label'.tr,style: textMedium.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall),
                    child: SizedBox(height: 74, child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: addressController.addressTypeList.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => addressController.updateAddressIndex(index, true),
                        child: Padding(padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                          child: Column(children: [
                            Container(width: 50,height: 50,
                              padding: const EdgeInsets.all(Dimensions.paddingSize),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),
                                color: addressController.selectAddressIndex == index
                                    ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                border: Border.all(color: addressController.selectAddressIndex == index
                                    ? Theme.of(context).primaryColor : Theme.of(context).hintColor)),
                              child: Image.asset(addressController.addressTypeList[index].icon,
                                color: addressController.selectAddressIndex == index ? Colors.white : Theme.of(context).hintColor,
                                scale: 0.5)),
                            Text(addressController.addressTypeList[index].title.tr),
                          ]),
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomTextField(
                    hintText: 'pick_location'.tr,
                    inputType: TextInputType.name,
                    prefixIcon: Images.location,
                    controller: Get.find<LocationController>().locationController,
                    inputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomTextField(
                    hintText: 'name'.tr,
                    inputType: TextInputType.name,
                    prefixIcon: Images.person,
                    controller: nameController,
                    inputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomTextField(
                    hintText: 'phone'.tr,
                    inputType: TextInputType.name,
                    prefixIcon: Images.call,
                    controller: phoneController,
                    inputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomTextField(
                    hintText: 'street'.tr,
                    inputType: TextInputType.name,
                    controller: roadController,
                    prefixIcon: Images.road,
                    inputAction: TextInputAction.next,
                  ),

                ]),
              ),
            );
          });
        }),
      ),
      bottomNavigationBar: GetBuilder<AddressController>(builder: (addressController) {
        return GetBuilder<LocationController>(builder: (locationController) {
          return Container(
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(.1),spreadRadius: 1, blurRadius: 5, offset: Offset.fromDirection(1,1))],
            ),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: !addressController.isLoading ? CustomButton(
                buttonText: widget.address != null ? 'update_address'.tr : 'save_address'.tr,
                onPressed: () {
                  String location = Get.find<LocationController>().locationController.text;
                  String name = nameController.text;
                  String phone = phoneController.text;
                  String street = roadController.text;

                  if(location.isEmpty) {
                    showCustomSnackBar('address_is_required'.tr);
                  }else if(name.isEmpty) {
                    showCustomSnackBar('name_is_required'.tr);
                  }if(phone.isEmpty) {
                    showCustomSnackBar('phone_is_required'.tr);
                  }else{
                    Address address = Address (
                      id: widget.address?.id,
                      address: location,
                      latitude: locationController.pickPosition.latitude,
                      longitude: locationController.pickPosition.longitude,
                      contactPersonName: name,
                      contactPersonPhone: phone,
                      street: street,
                      addressLabel: addressController.selectAddress,
                    );
                    addressController.addNewAddress(address, updateAddress: widget.address != null);
                  }
                },
              ) :  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)),
            ),
          );
        });
      }),
    );
  }
}
