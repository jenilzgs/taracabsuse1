import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/home/model/categoty_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/set_map/set_map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;
  final bool? isSelected;
  final bool fromSelect;
  final int index;
  const CategoryWidget({super.key, required this.category, this.isSelected, this.fromSelect = false, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<RideController>().setRideCategoryIndex(index);
        if(!fromSelect) {
          Get.to(() => const SetDestinationScreen());
        }
      },
      child: SizedBox(height: 90, width: 80, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Container(height: isSelected != null ? 80 : 70, width: isSelected != null ? 90 : 70,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color:  (isSelected != null && isSelected!) ? Theme.of(context).primaryColor.withOpacity(0.8)
                : Theme.of(context).hintColor.withOpacity(0.1)),
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            child: category.id == '0' ? Image.asset(category.image!) : CustomImage(
              image: '${Get.find<ConfigController>().config!.imageBaseUrl!.vehicleCategory!}/${category.image!}',
              fit: BoxFit.contain))),


        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        Text(category.name!, style: textSemiBold.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
          fontSize: Dimensions.fontSizeSmall), maxLines: 1, overflow: TextOverflow.ellipsis,),
      ])),
    );
  }
}