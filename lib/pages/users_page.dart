import 'package:chatify/models/chat_user.dart';
import 'package:chatify/providers/authentication_provider.dart';
import 'package:chatify/providers/users_page_provider.dart';
import 'package:chatify/widget/custom_input_fields.dart';
import 'package:chatify/widget/custom_list_view_tiles.dart';
import 'package:chatify/widget/rounded_button.dart';
import 'package:chatify/widget/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late UsersPageProvider pageProvider;

  final TextEditingController searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) =>UsersPageProvider(auth),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context)
      {
        pageProvider = context.watch<UsersPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.03,
            vertical: deviceHeight * 0.02,
          ),
          height: deviceHeight * 0.98,
          width: deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Users',
                fontSize: 25,
                primaryAction: IconButton(
                  onPressed: ()
                  {
                    auth.logout();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
              ),
              CustomTextField(
                onEditingComplete: (value)
                {
                  pageProvider.getUsers(name: value,);
                  FocusScope.of(context).unfocus();
                },
                hintText: 'Search',
                obscureText: false,
                controller: searchFieldTextEditingController,
                icon: Icons.search,
              ),
              usersList(),
              createChatButton(),
            ],
          ),
        ) ;
      },
    );
  }

  Widget usersList() {
    List<ChatUser>? users = pageProvider.users;
    return Expanded(
      child: () {
        if(users != null){
          if(users.length != 0){
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return CustomListViewTile(
                  height: deviceHeight * 0.10,
                  title: users[index].name!,
                  subTitle: 'Last Active ${users[index].lastActive}',
                  imagePath: users[index].imageURL!,
                  isActive: users[index].wasRecentlyActive(),
                  isSelected: pageProvider.selectedUsers.contains(users[index]),
                  onTap: (){
                    pageProvider.updateSelectedUsers(users[index]);
                  },
                );
              },
            );
          }else {
            return Center(
              child: Text(
                'No users found',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

      }(),
    );
  }

  Widget createChatButton(){
    return Visibility(
      visible: pageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
          name: pageProvider.selectedUsers.length == 1 ? 'Chat with ${pageProvider.selectedUsers.first.name}' : 'Create Group Chat' ,
          height: deviceHeight * 0.08,
          width: deviceWidth * 0.80,
          onPressed: (){
            pageProvider.createChat();
          },
      ),
    );
  }
}
