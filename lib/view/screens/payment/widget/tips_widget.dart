import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/payment/controller/payment_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class TipsWidget extends StatefulWidget {
  const TipsWidget({super.key});

  @override
  State<TipsWidget> createState() => _TipsWidgetState();
}

class _TipsWidgetState extends State<TipsWidget> {
  final List<int> _suggestedAmount = [10,20,30,40,50, 60,70, 100];
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(surfaceTintColor: Theme.of(context).cardColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault)),
      child: Container(

        padding:  const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center,children: [
          Padding(padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: Text('tip_amount'.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),),

          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('\$ ', style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                  color: Theme.of(context).primaryColor)),
              IntrinsicWidth(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: amountController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'enter_amount'.tr,
                    hintStyle: textRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(.5)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:  BorderSide(width: 0.5,
                          color: Theme.of(context).hintColor.withOpacity(0.0))),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:  BorderSide(width: 0.5,
                          color: Theme.of(context).hintColor.withOpacity(0.0)),
                    ),
                  ),

                ),
              ),
            ],
          ),
          Divider(color: Theme.of(context).primaryColor.withOpacity(.25)),
          Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault),
            child: SizedBox(height: 70,
              child: ListView.builder(itemCount: _suggestedAmount.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (amountContext, index){
                    return GestureDetector(
                      onTap: (){
                        amountController.text = _suggestedAmount[index].toString();
                      },
                      child: Padding(padding:  const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                        child: Container(decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(.1),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color:Get.isDarkMode? Theme.of(context).hintColor.withOpacity(.25):
                              Theme.of(context).primaryColor.withOpacity(.35))),
                          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                child: Text(_suggestedAmount[index].toString(),
                                  style: textRegular.copyWith(color:Get.isDarkMode
                                      ? Theme.of(context).hintColor.withOpacity(.5)
                                      : Theme.of(context).primaryColor),),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

                              index==1?
                              Container(height: 20,width: 120,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                                color: Theme.of(context).primaryColor
                              ),child: Center(child: Text('most_given'.tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.white),)),)
                                  :const SizedBox(height: 10,width: 120,)

                            ],
                          ),),
                      ),
                    );
                  }),
            ),
          ),
          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
            child: Text('trip_note'.tr,style: textRegular.copyWith(color: Theme.of(context).hintColor),),),
          Padding(padding:  const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraLarge),
            child: SizedBox(width: 100, child: CustomButton(buttonText: 'pay'.tr,
              radius: 10,
              onPressed: (){
              Get.find<PaymentController>().setTipAmount(amountController.text);
              Get.back();},)),
          ),


        ],),),
    );
  }
}
