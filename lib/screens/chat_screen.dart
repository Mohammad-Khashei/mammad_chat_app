import 'package:flutter/material.dart';
import 'package:mammad_chat_app/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatScreen extends StatelessWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  ChatScreen({
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.network(friendImage,height: 35,)
            ),
            SizedBox(width: 5,),
            Text(friendName,style: TextStyle(fontSize: 20),)
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              )
            ),
            child: Container(),
          ))
        ],
      ),
    );
  }
}