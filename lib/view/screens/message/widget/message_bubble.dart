import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/message/model/message_model.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';
import 'package:ride_sharing_user_app/view/widgets/image_dialog.dart';

class ConversationBubble extends StatefulWidget {
  final Message message;
  const ConversationBubble({super.key,  required this.message});

  @override
  State<ConversationBubble> createState() => _ConversationBubbleState();
}

class _ConversationBubbleState extends State<ConversationBubble> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = widget.message.user!.id! == Get.find<ProfileController>().profileModel!.data!.id!;

    return Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
      Padding(padding: isMe ? const EdgeInsets.fromLTRB(20, 5, 5, 5) : const EdgeInsets.fromLTRB(5, 5, 20, 5),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            SizedBox(height:Dimensions.fontSizeExtraSmall),

            Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [isMe ? const SizedBox() : Column(children: [
                ClipRRect(borderRadius: BorderRadius.circular(50),
                  child: CustomImage(height: 30, width: 30,
                    image: '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImageDriver!}/${widget.message.user!.profileImage ?? ''}',
                  ),
                ),
              ],
              ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Flexible(child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end:CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, children: [
                    if(widget.message.message != null)
                      Flexible(child: Container(decoration: BoxDecoration(
                          color: isMe ? Theme.of(context).hintColor : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10)),
                          child:  Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            child: Text(widget.message.message??'')))),



                       if( widget.message.conversationFiles!.isNotEmpty) const SizedBox(height: Dimensions.paddingSizeSmall),
                        widget.message.conversationFiles!.isNotEmpty?
                        Directionality(textDirection:Get.find<LocalizationController>().isLtr ? isMe ?
                        TextDirection.rtl : TextDirection.ltr : isMe ? TextDirection.ltr : TextDirection.rtl,
                          child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1, crossAxisCount: 3,
                            mainAxisSpacing: Dimensions.paddingSizeSmall, crossAxisSpacing: Dimensions.paddingSizeSmall),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.message.conversationFiles!.length,
                            itemBuilder: (BuildContext context, index) {
                              bool isImage = widget.message.conversationFiles![index].fileType!.toLowerCase() == 'png'
                                  || widget.message.conversationFiles![index].fileType!.toLowerCase() == 'jpg'
                                  || widget.message.conversationFiles![index].fileType!.toLowerCase() == 'jpeg';
                              return isImage ? InkWell(onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialog(
                                  imageUrl: '${Get.find<ConfigController>().config!.imageBaseUrl!.conversation}/${widget.message.conversationFiles![index].fileName ?? ''}')),
                                child: ClipRRect(borderRadius: BorderRadius.circular(5),
                                  child:CustomImage(height: 100, width: 100, fit: BoxFit.cover,
                                    image: '${Get.find<ConfigController>().config!.imageBaseUrl!.conversation!}/${widget.message.conversationFiles![index].fileName ?? ''}')),) :
                              InkWell(onTap : () async {
                                final status = await Permission.storage.request();
                                if(status.isGranted){
                                  Directory? directory = Directory('/storage/emulated/0/Download');
                                  if (!await directory.exists()) {
                                    directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationSupportDirectory();
                                    }
                                  }
                                },

                                child: Container(height: 50,width: 50,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).hoverColor),
                                  child: Stack(children: [
                                    Center(child: SizedBox(width: 50, child: Image.asset(Images.folder))),
                                    Center(child: Text('${widget.message.conversationFiles![index].fileName}'.substring(widget.message.conversationFiles![index].fileName!.length-7),
                                        maxLines: 5, overflow: TextOverflow.clip)),
                                    ],
                                  ),),
                              );
                            },),
                        ):
                        const SizedBox.shrink(),
                    ],
                  ),
                ),

                const SizedBox(width: 10,),
                isMe ? ClipRRect(borderRadius: BorderRadius.circular(50),
                  child: CustomImage(height: 30, width: 30,
                    image: '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImage!}/${widget.message.user!.profileImage??''}'),
                ) : const SizedBox(),
              ],
            ),
          ],
        ),
      ),

      Padding(padding: isMe ? const EdgeInsets.fromLTRB(5, 0, 50, 5) : const EdgeInsets.fromLTRB(50, 0, 5, 5),
        child: Text(DateConverter.isoStringToDateTimeString(widget.message.updatedAt!),
          textDirection: TextDirection.ltr,
          style: textRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall))),

    ]);
  }
}


