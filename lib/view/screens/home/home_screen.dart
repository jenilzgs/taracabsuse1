
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/home/controller/address_controller.dart';
import 'package:ride_sharing_user_app/view/screens/home/controller/banner_controller.dart';
import 'package:ride_sharing_user_app/view/screens/home/controller/category_controller.dart';
import 'package:ride_sharing_user_app/view/screens/home/widgets/banner_view.dart';
import 'package:ride_sharing_user_app/view/screens/home/widgets/category_view.dart';
import 'package:ride_sharing_user_app/view/screens/home/widgets/home_map_view.dart';
import 'package:ride_sharing_user_app/view/screens/home/widgets/home_my_address.dart';
import 'package:ride_sharing_user_app/view/screens/home/widgets/home_search_widget.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/controller/parcel_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/ongoing_parcel_list_view.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/rider_details_widget.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  String greetingMessage() {
    var timeNow = DateTime.now().hour;
    if (timeNow <= 12) {
      return 'good_morning'.tr;
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'good_afternoon'.tr;
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'good_evening'.tr;
    } else {
      return 'good_night'.tr;
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  bool clickedMenu = false;
  Future<void> loadData() async{
    Get.find<ParcelController>().getOngoingParcelList();
    Get.find<ParcelController>().getUnpaidParcelList();
    Get.find<BannerController>().getBannerList();
    Get.find<CategoryController>().getCategoryList();
    Get.find<AddressController>().getAddressList(1);
    Get.find<RideController>().getCurrentRide();
    Get.find<RideController>().getNearestDriverList(Get.find<LocationController>().getUserAddress()!.latitude!.toString(), Get.find<LocationController>().getUserAddress()!.longitude!.toString());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RideController>(
        builder: (rideController) {
          return GetBuilder<ParcelController>(
            builder: (parcelController) {
              int parcelCount = parcelController.parcelListModel?.totalSize??0;
              int rideCount = (rideController.tripDetails != null && rideController.tripDetails!.type == 'ride_request')?1:0;
              return Stack(children: [
                  GetBuilder<ProfileController>(builder: (profileController) {
                    return GetBuilder<RideController>(
                      builder: (rideController) {
                        return GetBuilder<ParcelController>(
                          builder: (parcelController) {
                            return CustomBody(
                              appBar:  CustomAppBar(title: '${greetingMessage()} ${profileController.customerFirstName()}',
                                showBackButton: false, isHome: true, fontSize: Dimensions.fontSizeDefault),
                              body: RefreshIndicator(
                                onRefresh: () async {
                                  await loadData();
                                },
                                child:  CustomScrollView(slivers: [
                                  SliverToBoxAdapter(child: Column(children: [
                                    Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                      child: Stack(
                                        children: [
                                           Column(children: [

                                            const BannerView(),

                                            const CategoryView(),

                                             rideController.tripDetails != null? const SizedBox():
                                            const HomeSearchWidget(),

                                            const HomeMyAddress(addressPage: AddressPage.home),

                                            const HomeMapView(title: 'rider_around_you'),

                                          ]),

                                        ],
                                      ),
                                    ),

                                  ])),

                                ]),
                              ),
                            );
                          }
                        );
                      }
                    );
                  }),
                Positioned(child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: (){
                         setState(() {
                           clickedMenu = true;
                         });
                        },
                        onHorizontalDragEnd: (DragEndDetails details){
                          _onHorizontalDrag(details);

                        },

                        child: Stack(children: [
                          SizedBox(width: 70,
                              child: Image.asset(Images.homeMapIcon, color: Theme.of(context).primaryColor)),
                          Positioned(top: 0, bottom: 15, left: 35, right: 0, child: SizedBox(height: 10,child: Image.asset(Images.ongoing, scale: 2.7,))),

                          Positioned( bottom: 85,  right: 5, child: Container(width: 20, height: 20,padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(50)),

                              child: Center(child: Text('${ rideCount + parcelCount}', style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall),))))

                        ],
                        )))),
                if(clickedMenu)
                Positioned(child: Align(
                    alignment: Alignment.centerRight,
                    child: GetBuilder<RideController>(
                      builder: (rideController) {
                        return GetBuilder<ParcelController>(
                          builder: (parcelController) {
                            return Container(width: 220, height: 120,
                                decoration: BoxDecoration(
                                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.5), blurRadius: 1, spreadRadius: 1, offset: const Offset(1,1))],
                                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                                  color: Theme.of(context).cardColor),
                                child: Row(children: [
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          clickedMenu = false;
                                        });
                                      },
                                      child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        child: Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).hintColor,size: Dimensions.iconSizeMedium,),),
                                    ),
                                    Column(children: [
                                      Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                                        child: InkWell(onTap: () async {
                                            await rideController.getCurrentRideStatus(fromRefresh: true);
                                            setState(() {
                                              clickedMenu = false;
                                            });

                                        },
                                          child: Container(width: 150,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.5)),
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Theme.of(context).primaryColor.withOpacity(.125)),
                                              child: Padding(padding: const EdgeInsets.all(8.0),
                                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                    Text('ongoing_ride'.tr),
                                                  CircleAvatar(radius: 10,backgroundColor: Theme.of(context).colorScheme.error,
                                                    child: Text('$rideCount', style: textRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),),)
                                                  ]))))),

                                      InkWell(onTap: (){
                                        if(parcelController.parcelListModel != null && parcelController.parcelListModel!.data != null && parcelController.parcelListModel!.data!.isNotEmpty){
                                          Get.to(()=>  OngoingParcelListView(title: 'ongoing_parcel_list', parcelListModel: parcelController.parcelListModel!));
                                        }else{
                                          showCustomSnackBar('no_parcel_available'.tr);
                                        }
                                      },
                                        child: Container(width: 150,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.5)),
                                                borderRadius: BorderRadius.circular(10),
                                                color: Theme.of(context).primaryColor.withOpacity(.125)
                                            ),
                                            child: Padding(padding: const EdgeInsets.all(8.0),
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Text('parcel_delivery'.tr),
                                                CircleAvatar(radius: 10,backgroundColor: Theme.of(context).colorScheme.error,
                                                  child: Text('${parcelController.parcelListModel?.totalSize??0}', style: textRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeSmall),),)
                                              ],
                                              ))),
                                      ),
                                    ],),
                                  ],
                                ));
                          }
                        );
                      }
                    ))),

                if(rideController.biddingList.isNotEmpty && rideController.tripDetails?.currentStatus == 'pending' )
                  Positioned(bottom: 90, left: 15, right: 15,child: Align(
                    alignment: Alignment.bottomLeft,
                    child: GetBuilder<RideController>(
                        builder: (rideController) {
                          return SizedBox(height: 170,
                            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: ListView.builder(padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: rideController.biddingList.length,
                                  addRepaintBoundaries: false,
                                  addAutomaticKeepAlives: false,
                                  itemBuilder: (context, index){
                                    return Container(width: Get.width-70,
                                        decoration: BoxDecoration(
                                          boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.125), blurRadius: 1, spreadRadius: 1, offset: const Offset(0,0))]
                                        ),
                                        child: RiderDetailsWidget(bidding: rideController.biddingList[index], tripId: rideController.tripDetails!.id!,));
                                  }),
                            ),
                          );
                        }
                    )))
                ],
              );
            }
          );
        }
      ),
    );
  }
  void _onHorizontalDrag(DragEndDetails details) {
    if(details.primaryVelocity == 0) return;

    if (details.primaryVelocity!.compareTo(0) == -1) {
      debugPrint('dragged from left');
    } else {
      debugPrint('dragged from right');
    }
  }
}




