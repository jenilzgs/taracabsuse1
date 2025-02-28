import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/home/model/address_model.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/set_map/widget/input_field_for_set_route.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_divider.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_search_field.dart';
import 'dart:math' as math;

class SetDestinationScreen extends StatefulWidget {
  final Address? address;
  const SetDestinationScreen({super.key, this.address});

  @override
  State<SetDestinationScreen> createState() => _SetDestinationScreenState();
}

class _SetDestinationScreenState extends State<SetDestinationScreen> {


  @override
  void initState() {
    super.initState();

    Get.find<LocationController>().initAddLocationData();
    Get.find<LocationController>().initTextControllers();
    Get.find<RideController>().clearExtraRoute();
    Get.find<MapController>().initializeData();
    Get.find<RideController>().initData();
    Get.find<LocationController>().setPickUp(Get.find<LocationController>().getUserAddress());
    if(widget.address != null) {
      Get.find<LocationController>().setDestination(widget.address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: CustomAppBar(title: 'select_location'.tr,),
        body: GetBuilder<LocationController>(builder: (locationController) {
          return GetBuilder<RideController>(builder: (rideController) {
            return Stack(clipBehavior: Clip.none, children: [

              SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min,children: [

                Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,
                    Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall),
                  child: Container(decoration: BoxDecoration(color: Get.isDarkMode? Theme.of(context).primaryColorDark : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end,children: [

                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Padding(padding:  const EdgeInsets.fromLTRB(
                          Dimensions.paddingSizeSmall,Dimensions.paddingSizeLarge, Dimensions.paddingSizeSmall, 0,), child: Column(children: [
                            SizedBox(width: Dimensions.iconSizeLarge, child: Image.asset(Images.currentLocation,
                              color: Theme.of(context).colorScheme.onSecondary.withOpacity(.75),)),

                            SizedBox(height: 70, width: 10, child: CustomDivider(height: 5, dashWidth: .75,
                              axis: Axis.vertical,color: Theme.of(context).colorScheme.onSecondary,)),

                            SizedBox(width: Dimensions.iconSizeMedium,
                                child: Transform(alignment: Alignment.center,
                                  transform: Get.find<LocalizationController>().isLtr? Matrix4.rotationY(0):Matrix4.rotationY(math.pi),
                                  child: Image.asset(Images.activityDirection,
                              color: Theme.of(context).colorScheme.onSecondary.withOpacity(.75)),
                                )),
                          ]),
                        ),

                        Expanded(child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(color: Get.isDarkMode? Theme.of(context).cardColor : Theme.of(context).primaryColorDark.withOpacity(.25),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                child: Row(children: [const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Expanded(child: CustomSearchField(
                                    controller: locationController.pickupLocationController,
                                    hint: 'pick_location'.tr,
                                    onChanged: (value) async {
                                      return await Get.find<LocationController>().searchLocation(
                                        context, value, type: LocationType.from,
                                      );
                                    },
                                  )),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  InkWell(
                                    onTap: () => Get.to(() =>  const PickMapScreen(type: LocationType.from)),
                                    child: Icon(Icons.place_outlined, color: Colors.white.withOpacity(0.7)),
                                  ),


                                ]),
                              ),

                              Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                child: Text('to'.tr,style: textRegular.copyWith(color: Colors.white))),

                              if(locationController.extraOneRoute)
                                Container(height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(color: Get.isDarkMode? Theme.of(context).cardColor : Theme.of(context).primaryColorDark.withOpacity(.25),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                  child: Row(children: [const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                    Expanded(child: CustomSearchField(
                                      controller: locationController.extraRouteOneController,
                                      hint: 'extra_route_one'.tr,
                                      onChanged: (value) async {
                                        return await Get.find<LocationController>().searchLocation(
                                          context, value, type: LocationType.extraOne,
                                        );
                                      },
                                    )),
                                    const SizedBox(width: Dimensions.paddingSizeSmall),

                                    InkWell(onTap: () => Get.to(() => const PickMapScreen(type: LocationType.extraOne)),
                                      child: Icon(Icons.place_outlined, color: Colors.white.withOpacity(0.7))),

                                    InkWell(onTap: ()=> locationController.setExtraRoute(remove: true),
                                      child: Icon(Icons.clear, color: Colors.white.withOpacity(0.7))),

                                  ]),
                                ),
                              SizedBox(height: locationController.extraOneRoute ? Dimensions.paddingSizeDefault : 0),

                              locationController.extraTwoRoute ?
                              Container(height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(color: Get.isDarkMode? Theme.of(context).cardColor : Theme.of(context).primaryColorDark.withOpacity(.25),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                child: Row(children: [const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Expanded(child: CustomSearchField(
                                    controller: locationController.extraRouteTwoController,
                                    hint: 'extra_route_two'.tr,
                                    onChanged: (value) async {
                                      return await Get.find<LocationController>().searchLocation(
                                        context, value, type: LocationType.extraTwo,
                                      );
                                    },
                                  )),



                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  InkWell(onTap: () => Get.to(() => const PickMapScreen(type: LocationType.extraTwo)),
                                    child: Icon(Icons.place_outlined, color: Colors.white.withOpacity(0.7))),

                                  InkWell(onTap: () => locationController.setExtraRoute(remove: true),
                                    child: Icon(Icons.clear, color: Colors.white.withOpacity(0.7))),

                                ]),
                              ) : const SizedBox(),



                              SizedBox(height: locationController.extraTwoRoute ? Dimensions.paddingSizeDefault : 0),

                              Row(children: [Expanded(
                                child: Container(height: 50, padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(color: Get.isDarkMode? Theme.of(context).cardColor : Theme.of(context).primaryColorDark.withOpacity(.25),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                    child: Row(children: [const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                      Expanded(child: CustomSearchField(
                                        controller: locationController.destinationLocationController,
                                        hint: 'destination'.tr,
                                        onChanged: (value) async {
                                          return await Get.find<LocationController>().searchLocation(
                                            context, value.trim(), type: LocationType.to);
                                        },
                                      )),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),

                                      locationController.selecting?  SpinKitCircle(color: Theme.of(context).cardColor, size: 40.0):
                                      InkWell(onTap: () => Get.to(() => const PickMapScreen(type: LocationType.to)),
                                        child: Icon(Icons.place_outlined, color: Colors.white.withOpacity(0.7))),

                                    ]),
                                  ),
                                ),


                                SizedBox(width: locationController.extraTwoRoute ? 0 : Dimensions.paddingSizeSmall),
                                (!Get.find<ConfigController>().config!.addIntermediatePoint! || locationController.extraTwoRoute) ? const SizedBox() : InkWell(
                                  onTap: () => locationController.setExtraRoute(),
                                  child: Container(height: 40,width: 40,
                                    decoration: BoxDecoration(color: Get.isDarkMode? Theme.of(context).cardColor : Theme.of(context).primaryColorDark.withOpacity(.35),
                                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                                    child: const Icon(Icons.add, color: Colors.white))),
                              ]),
                              const SizedBox(height: Dimensions.paddingSizeDefault),



                              locationController.addEntrance ? SizedBox(width: 200, child: InputField(

                                showSuffix: false,
                                controller: locationController.entranceController,
                                node: locationController.entranceNode,
                                hint: 'enter_entrance'.tr)) :

                              InkWell(onTap: () => locationController.setAddEntrance(),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [

                                  SizedBox(height: 25, child: Transform(
                                      alignment: Alignment.center,
                                      transform: Get.find<LocalizationController>().isLtr? Matrix4.rotationY(0):Matrix4.rotationY(math.pi),
                                      child: Image.asset(Images.curvedArrow))),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),
                                  Row(crossAxisAlignment: CrossAxisAlignment.end,children: [
                                    const Icon(Icons.add, color: Colors.white),
                                    Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault), child: Text(
                                      'add_entrance'.tr,
                                      style: textMedium.copyWith(
                                        color: Colors.white.withOpacity(.75),
                                        fontSize: Dimensions.fontSizeLarge,
                                      ),
                                    )),
                                  ]),
                                ]),
                              ),
                            ],
                          ),
                        )),
                      ]),


                      Padding(padding: const EdgeInsets.fromLTRB(
                        Dimensions.paddingSizeExtraLarge, Dimensions.paddingSizeSmall,
                        Dimensions.paddingSizeExtraLarge,Dimensions.paddingSizeExtraLarge),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('you_can_add_multiple_route_to'.tr,
                              style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.white.withOpacity(.75))),

                            InkWell(onTap: () {
                                if(locationController.fromAddress == null || locationController.fromAddress!.address == null
                                    || locationController.fromAddress!.address!.isEmpty) {
                                  showCustomSnackBar('pickup_location_is_required'.tr);
                                }else if(locationController.pickupLocationController.text.isEmpty) {
                                  showCustomSnackBar('pickup_location_is_required'.tr);
                                }else if(locationController.toAddress == null || locationController.toAddress!.address == null
                                    || locationController.toAddress!.address!.isEmpty) {
                                  showCustomSnackBar('destination_location_is_required'.tr);
                                }else if(locationController.destinationLocationController.text.isEmpty) {
                                  showCustomSnackBar('destination_location_is_required'.tr);
                                }else{
                                  rideController.getEstimatedFare(false).then((value) {
                                    if(value.statusCode == 200) {
                                      Get.find<LocationController>().initAddLocationData();
                                      Get.off(() => const MapScreen(fromScreen: MapScreenType.ride));
                                      Get.find<RideController>().updateRideCurrentState(RideState.initial);
                                    }
                                  });
                                  // Get.find<RideController>().getDirection();
                                }
                              },
                              child: rideController.loading ? SpinKitCircle(color: Theme.of(context).cardColor, size: 40.0) : Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault), child: Text(
                                'done'.tr,
                                style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraLarge,
                                  color: Theme.of(context).colorScheme.onSecondary.withOpacity(.75),
                                ),
                              )),
                            ),
                          ],
                        ),
                      ),

                    ]),
                  ),
                ),

              ])),

              locationController.resultShow ? Positioned(top: 0, left: 0, right: 0,
                child: InkWell(onTap: () => locationController.setSearchResultShowHide(show: false),
                  child: Container(decoration: BoxDecoration(
                      color: Get.isDarkMode? Theme.of(context).canvasColor : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
                    margin: EdgeInsets.fromLTRB(30, locationController.topPosition, 30, 0),
                    child: ListView.builder(
                        itemCount: locationController.predictionList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          return  InkWell(onTap: () {
                              Get.find<LocationController>().setLocation(
                                  fromSearch: true,
                                locationController.predictionList[index].placeId!,
                                locationController.predictionList[index].description!, null,
                                type: locationController.locationType);
                            },
                            child: Padding(padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
                              child: Row(children: [const Icon(Icons.location_on),
                                Expanded(child: Text(locationController.predictionList[index].description!, maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                    color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeDefault))),
                              ]),
                            ),
                          );
                        }),
                  ),
                ),
              ) : const SizedBox(),
            ]);
          });
        }),
      )
    );
  }
}


