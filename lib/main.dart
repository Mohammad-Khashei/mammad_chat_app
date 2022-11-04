import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //چک کردن وضعیت Authentication
  Future<Widget> userSignedIn()async{
    User? user = FirebaseAuth.instance.currentUser;
    // اگر یوزر ثبت شده باشد
    if(user != null){
      //get کردن دیتا از کالکشن یوزر
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      //ریختن دیتا در مدل خودمون
      UserModel userModel = UserModel.fromJson(userData);
      //ارسال
      return HomeScreen(userModel);
    }else{ //اگر یوزر در فایر بیس ساخته نشده بود
      return const AuthScreen();
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mammad Chat App',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        brightness: Brightness.light,
        backgroundColor: const Color(0xFFE5E5E5),
        dividerColor: Colors.white54,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: FutureBuilder(
        future: userSignedIn(),
        builder: (context,AsyncSnapshot<Widget> snapshot){
          if(snapshot.hasData){
            return snapshot.data!;
          }
          // اگر نال بود loading رو نشون بده
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      )
    );
  }
}
