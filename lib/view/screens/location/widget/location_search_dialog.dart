import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/model/prediction_model.dart';


class LocationSearchDialog extends StatelessWidget {
  final GoogleMapController? mapController;
  final LocationType type;
  const LocationSearchDialog({super.key, required this.mapController, required this.type});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
        alignment: Alignment.topCenter,
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          child: SizedBox(
            width: Get.width, child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              textInputAction: TextInputAction.search,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: 'search_location'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                ),
                hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor,
                ),
                filled: true, fillColor: Theme.of(context).cardColor,
              ),
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
              ),
            ),
            hideSuggestionsOnKeyboardHide: true,
            suggestionsCallback: (pattern) async {
              return await Get.find<LocationController>().searchLocation(context, pattern, fromMap: true);
            },
            itemBuilder: (context, PredictionModel suggestion) {
              return Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                child: Row(children: [
                  const Icon(Icons.location_on),
                  Expanded(
                    child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                    )),
                  ),
                ]),
              );
            },
            onSuggestionSelected: (PredictionModel suggestion) {
              Get.find<LocationController>().setLocation(suggestion.placeId!, suggestion.description!, mapController, type: type);
              Get.back();
            },
            noItemsFoundBuilder: (value) {
              return const SizedBox();
            },
          ),),
        ),
      ),
    );
  }
}
