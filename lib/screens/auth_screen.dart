//اولین صفحه برای احرازهویت
import 'package:mammad_chat_app/main.dart';

//import 'package:mammad_chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signInFunction() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    //گرفتن اطلاعات یوزر
    DocumentSnapshot userExist =
        await firestore.collection('users').doc(userCredential.user!.uid).get();

    // جلو گیری از update یوزر یا ایجاد تکراری
    if (userExist.exists) {
      // یوزر قبلا ایجاد شده
      //نشان دادن در دیباگ
      //print("User Already Exists in Database");
      //-------------------------------------
      // نشان دادن در تست
      showToast(context, "ورود با موفقیت انجام شد");
    } else {
      //ست کردن یوزر جدید در فایر بیس
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'image': userCredential.user!.photoURL,
        'uid': userCredential.user!.uid,
        'date': DateTime.now(),
      });
      showToast(context, "ثبت نام با موفقیت انجام شد");
    }

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => const MyApp()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("assets/images/Mammad_Chat_App.png"))),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Mammad Chat App",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: ElevatedButton(
                // signInFunction صدا زدن فانکشن
                onPressed: () async {
                  await signInFunction();
                },
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image(
                      image: const AssetImage("assets/images/google1.png"),
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                    Text(
                      "Sign in With Google",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 25),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// نوتفیکیشن از پایین
void showToast(BuildContext context, String displayName) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(displayName),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ));
}
