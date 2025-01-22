import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';

class CustomBody extends StatefulWidget {
  final Widget body;
  final CustomAppBar appBar;
  final double topMargin;
  const CustomBody({super.key, required this.body, required this.appBar, this.topMargin = 10});

  @override
  State<CustomBody> createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  @override
  Widget build(BuildContext context) {
    return  Column(children: [

      widget.appBar,

      Expanded(child: Container(
        margin: EdgeInsets.only(top: widget.topMargin),
        width: Dimensions.webMaxWidth,
        decoration:  BoxDecoration(borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25), topLeft: Radius.circular(25)),
          color: Theme.of(context).cardColor),
        child: widget.body,
      )),

    ]);
  }
}
