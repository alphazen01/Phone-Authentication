import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp/screens/home.dart';

class LogIn2 extends StatefulWidget {
  const LogIn2({Key? key}) : super(key: key);

  @override
  State<LogIn2> createState() => _LogIn2State();
}

class _LogIn2State extends State<LogIn2> {
  TextEditingController phoneController = TextEditingController(text: "+880");
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login with phone"),
      ),
      body: Column(
        children: [
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: "Phone Number",
            ),
            keyboardType: TextInputType.phone,
          ),
          Visibility(
            child: TextField(
              controller: otpController,
              decoration: InputDecoration(),
              keyboardType: TextInputType.number,
            ),
            visible: otpVisibility,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              if (otpVisibility) {
                verifyOTP();
              } else {
                loginWithPhone();
              }
            },
            child: Text(otpVisibility ? "Verify" : "Login"),
          )
        ],
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationID, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationID;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {

    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otpController.text);

    await auth.signInWithCredential(credential).then((value){
      print("You are logged in successfully");
      Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
    });
  }
}
