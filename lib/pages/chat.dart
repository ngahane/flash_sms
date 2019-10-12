import 'package:flash_sms/platform_services.dart';
import 'package:flash_sms/utils.dart';
import 'package:flash_sms/widgets/message_ui.dart';
import 'package:flash_sms/widgets/swipable_item.dart';
import 'package:flutter/material.dart';

import '../settings.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<dynamic> chatMessageDataList = [];

  final TextEditingController editSmsCtrl = TextEditingController();
  String inputText = "";
  String friendName, friendNumber, friendAvatar;

  @override
  void initState() {
    PlatformServices.nativeChatMessageReceiver.listen((data) {
      if (data["phone"] != friendNumber) return;
      Map<String, dynamic> value = {};
      final d = DateTime.now();
      value["name"] = friendName;
      value["phone"] = friendNumber;
      value["msg"] = data["msg"];
      value["time"] = "${d.day}/${d.month} ${d.hour}:${d.minute}";
      value["timestamp"] = "${d.millisecondsSinceEpoch}";
      value["type"] = "1";
      setState(() {
        chatMessageDataList.insert(0, value);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    PlatformServices.nativeChatMessagesCallCancel();
    PlatformServices.cancelNativeChatMessageReceiver();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> arg = ModalRoute.of(context).settings.arguments;
    assert(arg != null);
    assert(arg.length == 3);
    friendName = arg[0];
    friendNumber = arg[1];
    friendAvatar = arg[2];
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              friendName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            friendNumber != friendName
                ? Text(
                    friendNumber,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                  )
                : SizedBox(),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<dynamic>(
                  stream: PlatformServices.nativeChatMessagesCall,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final lst = snapshot.requireData as List;
                      if (chatMessageDataList == null || chatMessageDataList.length < lst.length) {
                        chatMessageDataList = lst;
                      }
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: chatMessageDataList.length,
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) {
                        final dt = MessageData.fromMap(chatMessageDataList[index]);
                          return SwipableItem(
                              direction: dt.type == "2" ? SwipableDirection.endToStart : SwipableDirection.startToEnd,
                              seuil: {SwipableDirection.endToStart: 0.2, SwipableDirection.startToEnd: 0.2},
                              maxLimit: {SwipableDirection.endToStart: 0.2, SwipableDirection.startToEnd: 0.5},
                              maxLimitNotify: (){
                              },
//                              seuilNotify: (){},
                              onSuccess: (){

                              },
                              background: Container(),child: MessageUi(data: dt));}
                    );
                  }),
            ),
            Container(
              height: 55.0,
              decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Pref.of(context).darkBlue.withAlpha(15))),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Enter Messages...",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none),
                      controller: editSmsCtrl,
                      keyboardType: TextInputType.text,
                      onSubmitted: (String str) {
                        print(str);
                        inputText = str;
                        sendMessage();
                      },
                      onChanged: (String str) {
                        inputText = str;
                      },
                    ),
                  )),
                  GestureDetector(onTap: sendMessage, child: sendIcon(context))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding sendIcon(BuildContext context, [int alpha = 255]) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        Icons.send,
        size: 35.0,
        color: Pref.of(context).darkBlue.withAlpha(alpha),
      ),
    );
  }

  void sendMessage() async {
    print(["sms_to_send", inputText]);
    if (inputText.trim().length > 0) {
      await PlatformServices.sendMessage(inputText.trim(), friendNumber);
      final Map<String, String> value = {};
      final d = DateTime.now();
      value["name"] = friendName;
      value["phone"] = friendNumber;
      value["msg"] = inputText.trim();
      value["time"] = "${d.day}/${d.month} ${d.hour}:${d.minute}";
//      value["thread_id"] =
      value["timestamp"] = DateTime.now().millisecondsSinceEpoch.toString();
//    this._id = value["_id"];
      value["type"] = "2";
      setState(() {
        chatMessageDataList.insert(0, value);
        editSmsCtrl.clear();
      });
    }
  }
}
