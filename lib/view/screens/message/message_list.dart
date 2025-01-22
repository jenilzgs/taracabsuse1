import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/message/controller/message_controller.dart';
import 'package:ride_sharing_user_app/view/screens/message/model/channel_model.dart';
import 'package:ride_sharing_user_app/view/screens/message/widget/message_item.dart';
import 'package:ride_sharing_user_app/view/screens/notification/widgets/notification_shimmer.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/paginated_list_view.dart';
import 'package:ride_sharing_user_app/view/widgets/search_widget.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({super.key});

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  ScrollController scrollController = ScrollController();


  @override
  void initState() {
    Get.find<MessageController>().getChannelList(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: CustomAppBar(title: "chat".tr,showBackButton: true,),
        body: GetBuilder<MessageController>(builder: (messageController) {
          return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault), child: Column(children:  [

            const SearchWidget(),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            (messageController.channelModel?.data != null) ? messageController.channelModel!.data!.isNotEmpty ? Expanded(child: SingleChildScrollView(
              controller: scrollController,
              child: PaginatedListView(reverse: true,
                scrollController: scrollController,
                totalSize: messageController.channelModel!.totalSize,
                offset: messageController.channelModel != null && messageController.channelModel!.offset != null? int.parse(messageController.channelModel!.offset.toString()) : 1,
                onPaginate: (int? offset) async {
                  await messageController.getChannelList(offset!);
                },
                itemView: ListView.builder(itemCount: messageController.channelModel!.data!.length,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    ChannelUsers? channelUser;
                    for (var element in messageController.channelModel!.data![index].channelUsers!) {
                      if(element.user?.userType == 'driver') {
                        channelUser = element;
                      }
                    }
                    return  MessageItem(
                      isRead: false, channelUsers: channelUser,
                      lastMessage: messageController.channelModel!.data![index].lastChannelConversations?.message ?? '',
                    );
                  },
                ),
              ),
            )) : Expanded(child: NoDataScreen(title: 'no_chat_found'.tr)) : const Expanded(child: NotificationShimmer()),

          ]));
        }),
      ),
    );
  }
}
