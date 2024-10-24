import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:untitled4/changePWD/VerificationCode.dart';

class ForgotPassworD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePageForgotPassworD(),
    );
  }
}

class MyHomePageForgotPassworD extends StatelessWidget {
  final String emailRecipient = "s11924798@stu.najah.edu";
  final String emailSubject = "TrainLink Forget Password";

  int generateRandomNumber() {
    Random random = Random();
    int result = 0;

    for (int i = 0; i < 6; i++) {
      int digit = random.nextInt(9); // Random digit between 0 and 9
      result = result * 10 + digit;
    }

    print(result);
    return result;
  }

  String generateRandomNumberWithSixDigits() {
    int randomSixDigitNumber = generateRandomNumber();
    return randomSixDigitNumber.toString().padLeft(6, '0');
  }

  Future<String> sendEmail() async {
    String username = 'dalia2hameddwaikat@gmail.com';
    String password = 'lvgsveohxmgtxyai';

    final smtpServer = gmail(username, password);
    String code = generateRandomNumberWithSixDigits();

    final message = Message()
      ..from = Address(username, 'TrainLinkApp')
      ..recipients.add(emailRecipient)
      ..subject = emailSubject
      ..text =
          'Hello From TrainLink Application, this is your verification code ${code}';

    try {
      await send(message, smtpServer);
      print('Email sent!');
    } catch (error) {
      print('Error sending email: $error');
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 60),
            child: Image(
              image: AssetImage("images/forgotpass.PNG"),
            ),
          ),
          Container(
            child: Text(
              "Forgot Password?",
              style: GoogleFonts.salsa(
                  textStyle: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff003262))),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "New Password ",
              style: GoogleFonts.salsa(
                  textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff003262))),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30, top: 30, bottom: 40),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10, left: 30),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xff003262),
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Icon(
                    Icons.email,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      // color: Color.fromARGB(255, 99, 155, 196),
                      border: Border.all(color: Color(0xff003262), width: 2)),
                  child: Text(
                    "s11924798@stu.najah.edu",
                    style: TextStyle(
                        fontSize: 19,
                        color: Color(0xff003262),
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            //   padding: EdgeInsets.all(5),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  var code = sendEmail();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VerificationCode(code: code)));
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.only(top: 13, bottom: 13, left: 20, right: 20),
                  primary: Color(
                      0xff003262), // Change this to the desired background color
                  onPrimary:
                      Colors.white, // Change this to the desired text color
                  // Add any other styles you want to customize
                ),
                child: Text('Send',
                    style: GoogleFonts.salsa(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                    //color: Color.fromARGB(255, 99, 155, 196))),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}