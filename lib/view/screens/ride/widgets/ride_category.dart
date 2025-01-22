import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/view/screens/home/controller/category_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/category_widget.dart';

class RideCategoryWidget extends StatelessWidget {

  const RideCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(
      builder: (rideController){
        return GetBuilder<CategoryController>(builder: (categoryController) {
            return categoryController.categoryList != null ? categoryController.categoryList!.isNotEmpty ? SizedBox(height: 110, width: Get.width,
              child: ListView.builder(
                itemCount: categoryController.categoryList!.length,
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {

                  return Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: CategoryWidget(
                      index: index,
                      fromSelect: true,
                      category: categoryController.categoryList![index],
                      isSelected: rideController.rideCategoryIndex == index,
                    ),
                  );
                }
              ),
            ) : Center(child: Text('no_category_found'.tr)) : Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,));
          }
        );
      }
    );
  }
}
