import 'package:chatify/models/chat.dart';
import 'package:chatify/models/chat_message.dart';
import 'package:chatify/models/chat_user.dart';
import 'package:chatify/pages/chat_page.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/providers/chats_page_provider.dart';
import 'package:chatify/services/navigation_services.dart';
import 'package:chatify/widget/custom_list_view_tiles.dart';
import 'package:chatify/widget/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late NavigationServices navigation;
  late ChatsPageProvider pageProvider;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    navigation = GetIt.instance.get<NavigationServices>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(create: (_) => ChatsPageProvider(auth),),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI()
  {
    return Builder(
      builder: (context)
      {
        pageProvider = context.watch<ChatsPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.03 ,
            vertical: deviceHeight * 0.02,
          ),
          height: deviceHeight * 0.98,
          width: deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
            [
              TopBar(
                'Chats',
                primaryAction: IconButton(
                  onPressed: ()
                  {
                    auth.logout();
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
              ),
              chatList(),
            ],
          ),
        );
      },
    );
  }

  Widget chatList()
  {
    List<Chat>? chats = pageProvider.chats;
    return Expanded(
      child: ((){
       if(chats != null ){
         if(chats.length != 0){
           return ListView.builder(
               itemCount: chats.length,
               itemBuilder: (context,index)
               {
                 return chatTile(chats[index]);
               },
           );
         }else{
           return Center(
             child: Text(
              'No Chats Found',
             style: TextStyle(
               color: Colors.white,
             ),
           ),);
         }
       }else{
         return Center(child: CircularProgressIndicator(
           color: Colors.white,
         ),);
       }
      })(),
    );
  }

  Widget chatTile(Chat chat)
  {
    List<ChatUser> recipients = chat.recipients();
    bool isActive = recipients.any((d) => d.wasRecentlyActive());
    String subTitleText = '';
    if(chat.messages.isNotEmpty){
      subTitleText = chat.messages.first.type != MessageType.text ? 'Media Attachment' : chat.messages.first.content ;
    }
    return CustomListViewTileWithActivity(
      height: deviceHeight * 0.10,
      title: chat.title()!,
      subTitle:subTitleText,
      imagePath: chat.imageURL()!,
      isActive: isActive,
      isActivity: chat.activity,
      onTap: (){
        navigation.navigateToPage(ChatPage(chat: chat,));
      },
    );
  }
}
