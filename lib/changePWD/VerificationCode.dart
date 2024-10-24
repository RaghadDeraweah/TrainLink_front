/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled4/PassWordNew.dart';

class VerificationCode extends StatefulWidget {
  final Future<String> code;

  const VerificationCode({Key? key, required this.code}) : super(key: key);

  @override
  _VerificationCodeState createState() => _VerificationCodeState(code);
}

class _VerificationCodeState extends State<VerificationCode> {
  late List<TextEditingController> controllers;
  late Future<String> code = this.code; // Declare code in the state class

  _VerificationCodeState(this.code); // Constructor to receive code

  @override
  void initState() {
    super.initState();
    controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Expanded(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Image(
                image: AssetImage("images/codeverific.jpeg"),
              ),
            ),
            Container(
              child: Text(
                "Verification Code",
                style: GoogleFonts.salsa(
                  textStyle: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff003262),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  textAlign: TextAlign.center,
                  "Please insert the code that trainlink sent to your email!",
                  style: GoogleFonts.salsa(
                    textStyle: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff003262),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controllers.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: 40,
                  child: TextFormField(
                    controller: controllers[index],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      // Handle the value change for each text field
                      // You may want to focus on the next field or perform other actions
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: ElevatedButton(
                onPressed: () async {
                  // Handle the button press, e.g., verify the code
                  String enteredCode =
                      controllers.map((controller) => controller.text).join();

                  try {
                    String actualCode =
                        await code; // Wait for the result of the Future
                    print(actualCode);

                    if (enteredCode == actualCode) {
                      // Verification successful, navigate to PassWordNew screen
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PassWordNew()),
                      );
                    } else {
                      // Verification failed, show an error message
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text("Invalid verification code."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } catch (e) {
                    // Handle any error that might occur while getting the code
                    print("Error getting verification code: $e");
                  }
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
                child: Text('Verify Code',
                    style: GoogleFonts.salsa(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled4/changePWD/PassWordNew.dart';

class VerificationCode extends StatefulWidget {
  final Future<String> code;

  const VerificationCode({Key? key, required this.code}) : super(key: key);

  @override
  _VerificationCodeState createState() => _VerificationCodeState(code);
}

class _VerificationCodeState extends State<VerificationCode> {
  late List<TextEditingController> controllers;
  late Future<String> code = this.code; // Declare code in the state class

  _VerificationCodeState(this.code); // Constructor to receive code

  @override
  void initState() {
    super.initState();
    controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Image(
              image: AssetImage("images/codeverific.jpeg"),
            ),
          ),
          Container(
            child: Text(
              "Verification Code",
              style: GoogleFonts.salsa(
                textStyle: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff003262),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                "Please insert the code that trainlink sent to your email!",
                style: GoogleFonts.salsa(
                  textStyle: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff003262),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controllers.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: 40,
                child: TextFormField(
                  controller: controllers[index],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Handle the value change for each text field
                    // You may want to focus on the next field or perform other actions
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: ElevatedButton(
              onPressed: () async {
                // Handle the button press, e.g., verify the code

                String enteredCode =
                    controllers.map((controller) => controller.text).join();

                try {
                  String actualCode =
                      await code; // Wait for the result of the Future
                  print(actualCode);

                  if (enteredCode == actualCode) {
                    // Verification successful, navigate to PassWordNew screen
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PassWordNew()),
                    );
                  } else {
                    // Verification failed, show an error message
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Notice!",
                            style: GoogleFonts.salsa(
                              textStyle: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff003262),
                              ),
                            ),
                          ),
                          content: Text(
                            "Invalid verification code.",
                            style: GoogleFonts.salsa(
                              textStyle: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff003262),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "OK",
                                style: GoogleFonts.salsa(
                                  textStyle: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff003262),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                } catch (e) {
                  // Handle any error that might occur while getting the code
                  print("Error getting verification code: $e");
                }
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
              child: Text('Verify Code',
                  style: GoogleFonts.salsa(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }
}