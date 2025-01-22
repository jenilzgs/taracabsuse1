import 'package:file_picker/file_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';



class MessageRepo {

  final ApiClient apiClient;
  MessageRepo({required this.apiClient});

  Future<Response> createChannel(String userId,) async {
    return await apiClient.postData(AppConstants.createChannel,
        {
          "to": userId,
          "_method": "put"
        });
  }

  Future<Response> getChannelList(int offset) async {
    return await apiClient.getData('${AppConstants.channelList}?limit=10&offset=$offset');
  }


  Future<Response> getConversation(String channelId,int offset) async {
    return await apiClient.getData('${AppConstants.conversationList}?channel_id=$channelId&limit=10&offset=$offset');
  }

  Future<Response> sendMessage(String message,String channelID,  List<MultipartBody> file, PlatformFile? platformFile) async {
    return await apiClient.postMultipartDataConversation(
        AppConstants.sendMessage,
        {
          "message": message,
          "channel_id" : channelID,
          "_method":"put"
        },
        file ,
        otherFile: platformFile
    );
  }
}