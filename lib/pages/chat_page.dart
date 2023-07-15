import 'package:chatify/models/chat.dart';
import 'package:chatify/models/chat_message.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/providers/chat_page_provider.dart';
import 'package:chatify/widget/custom_input_fields.dart';
import 'package:chatify/widget/custom_list_view_tiles.dart';
import 'package:chatify/widget/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;
  const ChatPage({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late ChatPageProvider pageProvider;
  late GlobalKey<FormState> messageFormState;
  late ScrollController messageListViewController;

  @override
  void initState() {
    super.initState();
    messageFormState = GlobalKey<FormState>();
    messageListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(widget.chat.uid, auth, messageListViewController,),
        ),
      ],
        child: buildUI(),
    );
  }

  Widget buildUI()
  {
    return Builder(
      builder: (context)
      {
        pageProvider = context.watch<ChatPageProvider>();
        return   Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.03,
                vertical: deviceHeight * 0.02,
              ),
              height: deviceHeight,
              width: deviceWidth * 0.97,
              child: Column(
                mainAxisSize:  MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    fontSize: 16,
                    widget.chat.title(
                    )!,
                    primaryAction: IconButton(
                      onPressed: () {
                        pageProvider.deleteChat();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                    ),
                    secondaryAction: IconButton(
                      onPressed: ()
                      {
                        pageProvider.goBack();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromRGBO(0, 82, 218, 1.0),
                      ),
                    ),
                  ),
                  messagesListView(),
                  sendMessageForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget messagesListView(){
    if(pageProvider.messages != null){
      //pageProvider.messages!.length != 0
      if(pageProvider.messages!.isNotEmpty){
        return Container(
          height: deviceHeight * 0.74,
          child: ListView.builder(
            controller: messageListViewController,
            itemCount: pageProvider.messages!.length,
              itemBuilder: (context , index)
              {
                ChatMessage message = pageProvider.messages![index];
                bool isOwnMessage = message.senderID == auth.chatUser.uid;
                return Container(
                  child: CustomChatListViewTile(
                      width: deviceWidth * 0.80,
                      deviceHeight: deviceHeight,
                      isOwnMessage: isOwnMessage,
                      message: message,
                      sender: widget.chat.members.where((m) => m.uid == message.senderID).first,
                  ),
                );
              },
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            'Be the first to say Hi!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget sendMessageForm(){
    return Container(
      height: deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: deviceWidth * 0.04,
        vertical: deviceHeight * 0.03,
      ),
      child: Form(
        key:messageFormState ,
        child:Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            messageTextField(),
            sendMessageButtons(),
            imageMessageButton(),
          ],
        ) ,
      ),
    );
  }

  Widget messageTextField()
  {
    return SizedBox(
      width: deviceWidth * 0.65,
      child: CustomTextFormField(
          onSaved: (value){
            pageProvider.message = value;
          },
          regEx: r"^(?!\s*$).+",
          hintText: 'Type a message',
          obscureText: false,
      ),
    );
  }
  Widget sendMessageButton(){
    double size = deviceHeight * 0.04;
    return Container(
      //color: Colors.red,
      height: size,
      width: size,
      child: IconButton(
        onPressed: () {  },
        icon:Icon(
          Icons.send,
          color: Colors.white,
        ) ,
      ),
    );
  }

  Widget sendMessageButtons(){
    double size = deviceHeight * 0.04;
    return Container(
      //color: Colors.red,
      height: size,
      width: size,
      child: FloatingActionButton(
        backgroundColor: Colors.black12,
        onPressed: ()
        {
          if(messageFormState.currentState!.validate())
          {
            messageFormState.currentState?.save();
            pageProvider.sendTextMessage();
            messageFormState.currentState?.reset();
          }
        },
        child: Icon(
          Icons.send,
          color: Colors.white,
          size: 20,
        ) ,
      ),
    );
  }


  Widget imageMessageButton(){
    double size = deviceHeight * 0.04;
    return Container(
      //color: Colors.red,
      height: size,
      width: size,
      child: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: () {
          pageProvider.sendImageMessage();
        },
        child: Icon(
          Icons.camera_enhance,
          //color: Colors.white,
        ) ,
      ),
    );
  }
}
