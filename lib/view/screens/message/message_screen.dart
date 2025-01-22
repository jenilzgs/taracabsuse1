import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/message/controller/message_controller.dart';
import 'package:ride_sharing_user_app/view/screens/message/widget/message_bubble.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';
import 'dart:math' as math;

class MessageScreen extends StatefulWidget {
  final String channelId;
  const MessageScreen({super.key, required this.channelId});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  @override
  void initState() {
    Get.find<MessageController>().getConversation(widget.channelId, 1);
    super.initState();
  }


  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: CustomAppBar(title: 'see_driver_want_to_say'.tr, showBackButton: true, centerTitle: false),
        body:  GetBuilder<MessageController>(builder: (messageController) {
          return Column(children: [



            (messageController.messageModel?.data != null) ? messageController.messageModel!.data!.isNotEmpty ?
            Expanded(child: SingleChildScrollView(controller: scrollController,
              reverse: true,
              child: PaginatedListView(
                reverse: true,
                scrollController: scrollController,
                totalSize: messageController.messageModel!.totalSize,
                offset: (messageController.messageModel != null && messageController.messageModel!.offset != null) ?
                int.parse(messageController.messageModel!.offset.toString()) : null,
                onPaginate: (int? offset) async {
                  await messageController.getConversation(widget.channelId, offset!);
                },
                itemView: ListView.builder(
                  reverse: true,
                  itemCount: messageController.messageModel!.data!.length,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ConversationBubble(message: messageController.messageModel!.data![index]);
                  },
                ),
              ),
            ),
            ) : Expanded(child: NoDataScreen(title: 'no_message_found'.tr)) : const Expanded(child: NotificationShimmer()),

            (messageController.pickedImageFile != null && messageController.pickedImageFile!.isNotEmpty) ? Container(
              height: 90, width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: messageController.pickedImageFile!.length,
                itemBuilder: (context, index) {
                  return  Stack(children: [
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(height: 80, width: 80, child: Image.file(
                        File(messageController.pickedImageFile![index].path), fit: BoxFit.cover,
                      )),
                    )),
                    Positioned(right: 5, child: InkWell(
                      onTap: () => messageController.pickMultipleImage(true,index: index),
                      child: const Icon(Icons.cancel_outlined, color: Colors.red),
                    )),
                  ]);
                },
              ),
            ) : const SizedBox(),

            messageController.otherFile != null ? Stack(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 25),
                height: 25, child: Text(messageController.otherFile!.names.toString()),),

              Positioned(top: 0, right: 0,
                child: InkWell(onTap: () => messageController.pickOtherFile(true),
                  child: const Icon(Icons.cancel_outlined, color: Colors.red)))]) : const SizedBox(),


            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(margin: const EdgeInsets.only(
                left: Dimensions.paddingSizeSmall,
                right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall,),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(offset: const Offset(2,4), blurRadius: 5, color: Colors.black.withOpacity(0.2))],
                  color: Theme.of(context).cardColor, borderRadius: const BorderRadius.all(Radius.circular(100))),
                child: Form(key: messageController.conversationKey,
                  child: Row(children: [

                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(child: TextField(minLines: 1,
                      controller: messageController.conversationController,
                      textCapitalization: TextCapitalization.sentences,
                      style: textMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color:Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "type_here".tr,
                        hintStyle: textRegular.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
                          fontSize: 16)),
                      onChanged: (String newText) {})),

                    Row(children: [

                      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: InkWell(onTap: () => messageController.pickMultipleImage(false),
                          child: Image.asset(Images.pickImage, color: Get.isDarkMode ? Colors.white : Colors.black))),


                      InkWell(onTap: () {
                        messageController.pickOtherFile(false);

                        },
                        child: Image.asset(Images.pickFile, color: Get.isDarkMode?Colors.white:Colors.black)),


                      InkWell(onTap: () {
                          if(messageController.conversationController.text.isEmpty && messageController.pickedImageFile!.isEmpty
                              && messageController.otherFile==null) {

                          } else if(messageController.conversationKey.currentState!.validate()) {
                            messageController.sendMessage(widget.channelId).then((value) {

                            });
                          }
                          messageController.conversationController.clear();
                        },
                        child: messageController.isSending? SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,) :
                        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Get.find<LocalizationController>().isLtr? Matrix4.rotationY(0):Matrix4.rotationY(math.pi),
                              child: Image.asset(Images.sendMessage, width: 25, height: 25, color: Theme.of(context).primaryColor)),
                        ),
                      ),
                    ]),

                  ]),
                ),
              ),
            ]),

          ]);
        }),
      ),
    );
  }
}
