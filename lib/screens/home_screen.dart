import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mammad_chat_app/models/user_model.dart';
import 'package:mammad_chat_app/screens/auth_screen.dart';
import 'package:mammad_chat_app/screens/search_screen.dart';


class HomeScreen extends StatefulWidget {
  UserModel user;
  HomeScreen(this.user, {super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(onPressed: () async {
            //انتخاب اکانت دیگر ... v2
            await GoogleSignIn().signOut();
            //------------------------
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AuthScreen()), (route) => false);
            showToast(context, "خروج با موفقیت انجام شد");
          }, icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(widget.user)));
        },
      ),
    );
  }
}
