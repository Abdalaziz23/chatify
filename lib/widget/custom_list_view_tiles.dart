import 'package:chatify/models/chat_message.dart';
import 'package:chatify/models/chat_user.dart';
import 'package:chatify/widget/message_bubble.dart';
import 'package:chatify/widget/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomListViewTile extends StatelessWidget {
  final double height;
  final String title;
  final String subTitle;
  final String imagePath;
  final bool isActive;
  final bool isSelected;
  final Function onTap;
  const CustomListViewTile({
    Key? key,
    required this.height,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.isActive,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(

      trailing: isSelected
          ? Icon(
              Icons.check,
              color: Colors.white,
            )
          : null,
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      leading: RoundedImageNetworkWithStatusIndicator(
        key: UniqueKey(),
        imagePath: imagePath,
        size: height / 2,
        isActive: isActive,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle:Text(
        subTitle,
        style: TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ) ,
    );
  }
}

class CustomListViewTileWithActivity extends StatelessWidget {
  final double height;
  final String title;
  final String subTitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity;
  final Function onTap;

  const CustomListViewTileWithActivity({
    Key? key,
    required this.height,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.isActive,
    required this.isActivity,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      leading: RoundedImageNetworkWithStatusIndicator(
        key: UniqueKey(),
        imagePath: imagePath,
        size: height / 2,
        isActive: isActive,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: isActivity
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitThreeBounce(
                  color: Colors.white54,
                  size: height * 0.10,
                ),
              ],
            )
          : Text(
              subTitle,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
    );
  }
}

class CustomChatListViewTile extends StatelessWidget {
  final double width;
  final double deviceHeight;
  final bool isOwnMessage;
  final ChatMessage message;
  final ChatUser sender;

  const CustomChatListViewTile({
    Key? key,
    required this.width,
    required this.deviceHeight,
    required this.isOwnMessage,
    required this.message,
    required this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: 10,
      ),
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isOwnMessage
              ? RoundedImageNetwork(
                  key: UniqueKey(),
                  imagePath: sender.imageURL!,
                  size: width * 0.08,
                )
              : Container(),
          SizedBox(
            width: width * 0.05,
          ),
          message.type == MessageType.text
              ? TextMessageBubble(
                  width: width,
                  height: deviceHeight * 0.06,
                  isOwnMessage: isOwnMessage,
                  message: message,
                )
              : ImageMessageBubble(
                  isOwnMessage: isOwnMessage,
                  message: message,
                  width: width * 0.55,
                  height: deviceHeight * 0.30,
                ),
        ],
      ),
    );
  }
}
