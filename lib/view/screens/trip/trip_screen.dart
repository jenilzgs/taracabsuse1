import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/trip/controller/trip_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widgets/trip_item_view.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_calender.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_drop_down.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';

class TripScreen extends StatefulWidget {
  final bool fromProfile;
  const TripScreen({super.key, required this.fromProfile});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<TripController>().initData();
    Get.find<TripController>().getTripList(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: CustomAppBar(title: 'trip_history'.tr, showBackButton: widget.fromProfile),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: GetBuilder<TripController>(builder: (tripController) {
            return Column(children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Text('my_trips'.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodyLarge?.color)),

                tripController.showCustomDate?
                InkWell(onTap: () => tripController.updateShowCustomDateState(false),
                  child: Container(height: 35,
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.2))),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child:  Center(child:  Text("${tripController.filterStartDate} - ${tripController.filterEndDate}",
                        style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5)),
                      ),
                    )
                  ),
                ) : Container(width: 120, height: 35,
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
                    border: Border.all(width: 1, color: Theme.of(context).primaryColor.withOpacity(0.2))),
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Center(child: CustomDropDown<int>(
                    icon: Icon(Icons.expand_more,
                        color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5)),
                    maxListHeight: 200,
                    items: tripController.filterList.map((item) => CustomDropdownMenuItem<int>(
                      value: tripController.filterList.indexOf(item),
                      child: Text(item.tr,
                          style: textRegular.copyWith(color: Get.isDarkMode ? Colors.white :Theme.of(context).primaryColor)),
                    )).toList(),
                    hintText: tripController.filterList[tripController.filterIndex].tr,
                    borderRadius: 5,
                    onChanged: (int selectedItem) {
                      if(selectedItem == tripController.filterList.length-1) {
                        showDialog(context: context, builder: (_) => CustomCalender(onChanged: (value) => Get.back()));
                      }else {
                        tripController.setFilterTypeName(selectedItem);
                      }
                    },
                  )),
                ),
              ]),
              Divider(color: Theme.of(context).primaryColor.withOpacity(0.2),),

              (tripController.tripModel != null && tripController.tripModel!.data != null) ? tripController.tripModel!.data!.isNotEmpty ? Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: PaginatedListView(
                    scrollController: scrollController,
                    totalSize: tripController.tripModel!.totalSize,
                    offset: (tripController.tripModel != null && tripController.tripModel!.offset != null) ? int.parse(tripController.tripModel!.offset.toString()) : null,
                    onPaginate: (int? offset) async {
                      await tripController.getTripList(offset!);
                    },

                    itemView: Padding(padding: const EdgeInsets.only(bottom: 70.0),
                      child: ListView.builder(
                        itemCount: tripController.tripModel!.data!.length,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return TripItemView(tripDetails: tripController.tripModel!.data![index]);
                        },
                      ),
                    ),
                  ),
                ),
              ): const Expanded(child: NoDataScreen(title: 'no_trip_found',)) :
              const Expanded(child: NotificationShimmer()),

            ]);
          }),
        ),
      ),
    );
  }
}