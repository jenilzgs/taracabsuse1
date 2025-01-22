import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/view/screens/message/message_screen.dart';
import 'package:ride_sharing_user_app/view/screens/message/model/channel_model.dart';
import 'package:ride_sharing_user_app/view/screens/message/model/message_model.dart';
import 'package:ride_sharing_user_app/view/screens/message/repository/message_repo.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_snackbar.dart';



class MessageController extends GetxController implements GetxService{
  final MessageRepo messageRepo;
  MessageController({required this.messageRepo});

  List <XFile>? _pickedImageFiles =[];
  List <XFile>? get pickedImageFile => _pickedImageFiles;
  bool isLoading = false;

  FilePickerResult? _otherFile;
  FilePickerResult? get otherFile => _otherFile;

  File? _file;
  PlatformFile? objFile;
  File? get file=> _file;

  List<MultipartBody> _selectedImageList = [];
  List<MultipartBody> get selectedImageList => _selectedImageList;

  final List<dynamic> _conversationList=[];
  List<dynamic> get conversationList => _conversationList;

  final bool _paginationLoading = true;
  bool get paginationLoading => _paginationLoading;


  final String _name='';
  String get name => _name;
  final String _image='';
  String get image => _image;


  var conversationController = TextEditingController();
  final GlobalKey<FormState> conversationKey  = GlobalKey<FormState>();

  @override
  void onInit(){
    super.onInit();
    conversationController.text = '';
  }

  void pickMultipleImage(bool isRemove,{int? index}) async {
    if(isRemove) {
      if(index != null){
        _pickedImageFiles!.removeAt(index);
        _selectedImageList.removeAt(index);
      }
    }else {
      _pickedImageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      if (_pickedImageFiles != null) {
        for(int i =0; i< _pickedImageFiles!.length; i++){
          _selectedImageList.add(MultipartBody('files[$i]',_pickedImageFiles![i]));
        }
      }
    }
    update();
  }

  bool permissionGranted = false;

  Future getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      permissionGranted = true;

    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      await openAppSettings();
      Permission.storage.request();
    }
    update();
  }


  void pickOtherFile(bool isRemove) async {
    if(isRemove){
      _otherFile=null;
      _file = null;
    }else{
      _otherFile = (await FilePicker.platform.pickFiles())!;
      if (_otherFile != null) {
        objFile = _otherFile!.files.single;
      }
    }
    update();
  }

  void removeFile() async {
    _otherFile=null;
    update();
  }

  cleanOldData(){
    _pickedImageFiles = [];
    _selectedImageList = [];
    _otherFile = null;
    _file = null;
  }



  ChannelModel? channelModel;

  Future<void> getChannelList(int offset) async{
    Response response = await messageRepo.getChannelList(offset);
    if(response.statusCode == 200){
      if(offset == 1 ){
        channelModel = ChannelModel.fromJson(response.body);
      }else{
        channelModel!.totalSize =  ChannelModel.fromJson(response.body).totalSize;
        channelModel!.offset =  ChannelModel.fromJson(response.body).offset;
        channelModel!.data!.addAll(ChannelModel.fromJson(response.body).data!);
      }
      isLoading = false;
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> createChannel(String userId) async{
    isLoading = true;
    Response response = await messageRepo.createChannel(userId);
    if(response.statusCode == 200){
      isLoading = false;
      Map map = response.body;
      String channelId = map['data']['id'];
      Get.to(() =>  MessageScreen(channelId : channelId));
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }



  MessageModel? messageModel;
  Future<void> getConversation(String channelId, int offset) async{
    isLoading = true;
    Response response = await messageRepo.getConversation(channelId, offset);
    if(response.statusCode == 200){

      if(offset == 1 ){
        messageModel = MessageModel.fromJson(response.body);
      }else{
        messageModel!.totalSize =  MessageModel.fromJson(response.body).totalSize;
        messageModel!.offset =  MessageModel.fromJson(response.body).offset;
        messageModel!.data!.addAll(MessageModel.fromJson(response.body).data!);
      }
      isLoading = false;

    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  bool isSending = false;
  Future<void> sendMessage(String channelId) async{
    isSending = true;
    update();
    Response response = await messageRepo.sendMessage(conversationController.value.text,
        channelId ,_selectedImageList, objFile);
    if(response.statusCode == 200){
      isSending = false;
      getConversation(channelId, 1);
      conversationController.text='';
      _pickedImageFiles = [];
      _selectedImageList = [];
      _otherFile=null;
      objFile =null;
      _file=null;
    }
    else if(response.statusCode == 400){
      isSending = false;
      String message = response.body['errors'][0]['message'];
      if(message.contains("png  jpg  jpeg  csv  txt  xlx  xls  pdf")){
        message = "the_files_types_must_be";
      }
      if(message.contains("failed to upload")){
        message = "failed_to_upload";
      }
      _pickedImageFiles = [];
      _selectedImageList = [];
      _otherFile=null;
      objFile =null;
      _file=null;
      customSnackBar(message.tr);
    }
    else{
      isSending = false;
      _pickedImageFiles = [];
      _selectedImageList = [];
      _otherFile=null;
      objFile =null;
      _file=null;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
  }



}