import 'package:chatify/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
class TextMessageBubble extends StatelessWidget {
  final double width;
  final double height;
  final bool isOwnMessage;
  final ChatMessage message;
  const TextMessageBubble({
    Key? key,
    required this.width,
    required this.height,
    required this.isOwnMessage,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colorScheme = isOwnMessage
        ? [
            Color.fromRGBO(0, 136, 249, 1.0),
            Color.fromRGBO(0, 82, 218, 1.0),
          ]
        : [
            Color.fromRGBO(51, 49, 68, 1.0),
            Color.fromRGBO(51, 49, 68, 1.0),
          ];
    return Container(
      height:  height + (message.content.length /20 * 6.0),
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: colorScheme ,
          stops: [0.30,0.70],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: TextStyle(
              color:Colors.white ,
            ),
          ),
          Text(
            timeago.format(message.sendTime),
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
class ImageMessageBubble extends StatelessWidget {
  final bool isOwnMessage;
  final ChatMessage message;
  final double width;
  final double height;
  const ImageMessageBubble({
    Key? key,
    required this.isOwnMessage,
    required this.message,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color> colorScheme = isOwnMessage
        ? [
      Color.fromRGBO(0, 136, 249, 1.0),
      Color.fromRGBO(0, 82, 218, 1.0),
    ]
        : [
      Color.fromRGBO(51, 49, 68, 1.0),
      Color.fromRGBO(51, 49, 68, 1.0),
    ];
    DecorationImage image = DecorationImage(
      image: NetworkImage(message.content),
      fit: BoxFit.cover,
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.02,vertical: height * 0.03,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: colorScheme ,
          stops: [0.30,0.70],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: image,
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Text(
            timeago.format(message.sendTime),
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
