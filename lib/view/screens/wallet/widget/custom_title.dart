import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final Color? color;
  final String? icon;
  final String? count;
  const CustomTitle({super.key, required this.title, this.color, this.icon, this.count});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeExtraSmall,
        Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

        Row(children: [Text(title.tr, style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge,
            color: color??Theme.of(context).textTheme.bodyMedium!.color)),

          if(icon!=null)
            Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSeven),
              child: Image.asset(icon!,height: 15,width: 15))]),


          if(count!=null)
            Text( count.toString(), style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                color:Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5))),
        ],
      ),
    );
  }
}
