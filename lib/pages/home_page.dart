import 'package:chatify/pages/chats_page.dart';
import 'package:chatify/pages/users_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final List<Widget> pages =
  [
     ChatsPage(),
     UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return buildUI();
  }

  Widget buildUI()
  {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index)
        {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Chat',
            icon: Icon(
              Icons.chat_bubble_sharp,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Users',
            icon: Icon(
              Icons.supervised_user_circle_sharp,
            ),
          ),
        ],
      ),
    );
  }
}
