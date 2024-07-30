
import 'package:flutter/material.dart';

class Messagebubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String username;
  final String imageurl;
  const Messagebubble(this.message, this.username, this.imageurl , this.isMe, {required this.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey : Theme.of(context).secondaryHeaderColor,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: !isMe ? const Radius.circular(0) : const Radius.circular(12),
                bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(12)),
          ),
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 5, backgroundImage: NetworkImage(imageurl),),
                  const SizedBox(width: 5,),
                  Text(username, style: const TextStyle(fontWeight:  FontWeight.bold),),
                ],
              ),
              Text(message, textAlign: isMe? TextAlign.end : TextAlign.start,),
            ],
          ),
        ),
      ],
    );
  }
}
