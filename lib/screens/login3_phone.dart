import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp/screens/home.dart';

class Login3 extends StatefulWidget {
  const Login3({ Key? key }) : super(key: key);

  @override
  State<Login3> createState() => _Login3State();
}

class _Login3State extends State<Login3> {
  TextEditingController phoneController = TextEditingController(text: "+880");
  TextEditingController otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

bool otpVisibility = false;
String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:AppBar(
       title: Text("login3"),
     ),
     body: Column(
       children: [
         TextField(
           controller: phoneController,
           decoration: InputDecoration(
             labelText: "Phone Number"
           ),
           keyboardType: TextInputType.phone,
         ),
         Visibility(
           child: TextField(
             controller: otpController,
             decoration: InputDecoration(),
             keyboardType: TextInputType.number,
           ),visible:otpVisibility ,
         ),
         ElevatedButton(
           onPressed: (){
            if (otpVisibility) {
              verifyOTP();
            } else {
              loginWithPhone();
            }
           }, 
           child: Text(otpVisibility? "verify":"login")
          )
       ],
     ),
    );
  }
   void loginWithPhone()async{
     auth.verifyPhoneNumber(
       phoneNumber: phoneController.text, 
       verificationCompleted: (PhoneAuthCredential credential)async{
         await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
         });
       }, 
       verificationFailed: (FirebaseAuthException e){
         print(e.message);
       }, 
       codeSent: (String verificationId, int? resendToken){
         otpVisibility=true;
         verificationID=verificationId;
         setState(() {
           
         });
       }, 
       codeAutoRetrievalTimeout: (String verificationId){}
       );
   }
   void verifyOTP()async{
     PhoneAuthCredential credential=PhoneAuthProvider.credential(
       verificationId: verificationID, 
       smsCode: otpController.text
       );
       await auth.signInWithCredential(credential).then((value) {
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