
import 'package:chat_bot_app/data/remote/api_helper.dart';
import 'package:chat_bot_app/data/url_helper.dart';
import 'package:chat_bot_app/models/ai_generated_models.dart';
import 'package:chat_bot_app/models/message_model.dart';
import 'package:flutter/cupertino.dart';



class ChatProvider extends ChangeNotifier {
  List<MessageModel> listMsg = [];

  void sendMyPrompt({required String prompt}) async {
    //user asking
    listMsg.insert(
        0,
        MessageModel(
            msg: prompt,
            senderId: 0,
            sentAt: DateTime.now().millisecondsSinceEpoch));

    notifyListeners();

    //aiBot answering
    try {
      var mData = await ApiHelper()
          .generateAIMsg(url: Urls.CHAT_COMPLETION_API, prompt: prompt);
      AIGeneratedModel aiModel = AIGeneratedModel.fromJson(mData);

      listMsg.insert(
          0,
          MessageModel(
              msg: aiModel.choices![0].message!.content!,
              senderId: 1,
              sentAt: DateTime.now().millisecondsSinceEpoch));

      notifyListeners();
    } catch (e) {
      listMsg.insert(
          0,
          MessageModel(
              msg: e.toString(),
              senderId: 1,
              sentAt: DateTime.now().millisecondsSinceEpoch));

      notifyListeners();
    }
  }

  List<MessageModel> getAllMessages() {
    return listMsg;
  }
}
