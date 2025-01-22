import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/model/parcel_list_model.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/parcel_item.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';

class OngoingParcelListView extends StatefulWidget {
  final String title;
  final ParcelListModel parcelListModel;
  const OngoingParcelListView({super.key, required this.title, required this.parcelListModel});

  @override
  State<OngoingParcelListView> createState() => _OngoingParcelListViewState();
}

class _OngoingParcelListViewState extends State<OngoingParcelListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: CustomAppBar(title: widget.title.tr,),
        body: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: widget.parcelListModel.data!.length,
            itemBuilder: (context, index){
            return ParcelItem(rideRequest: widget.parcelListModel.data![index]);
        }),
      ),
    );
  }
}
