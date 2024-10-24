import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled4/login.dart';

class PassWordNew extends StatefulWidget {
  const PassWordNew({Key? key}) : super(key: key);

  @override
  _PassWordNewState createState() => _PassWordNewState();
}

class _PassWordNewState extends State<PassWordNew> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 90),
              child: Image(
                image: AssetImage("images/addnewpass.jpeg"),
              ),
            ),
            /*Container(
              child: Text(
                "Add New Password",
                style: GoogleFonts.salsa(
                  textStyle: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff003262),
                  ),
                ),
              ),
            ),*/
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: TextFormField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: GoogleFonts.salsa(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
              child: TextFormField(
                controller: confirmPasswordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: GoogleFonts.salsa(
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(17),
              margin: EdgeInsets.only(top: 10),
              child: Text(
                textAlign: TextAlign.center,
                "Password must have at least one uppercase letter, one lowercase letter, one digit, and one special character.",
                style: GoogleFonts.salsa(
                  textStyle: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Handle the button press, e.g., validate and save passwords
                  String password = passwordController.text;
                  String confirmPassword = confirmPasswordController.text;

                  if (password == confirmPassword &&
                      isPasswordValid(password)) {
                    // Passwords match and meet requirements, you can proceed
                    print("Password: $password");
                    setState(() {
                      showPassword = false;
                    });
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Login()));
                  } else {
                    // Passwords don't match, don't meet requirements, or are too short, show an error message
                    setState(() {
                      showPassword = false;
                    });

                    String errorMessage;
                    if (password.length < 8) {
                      errorMessage =
                          "Password must be at least 8 characters long.";
                    } else {
                      errorMessage =
                          "Passwords don't match or don't meet requirements.";
                    }

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
                            errorMessage,
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
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff003262),
                  onPrimary: Colors.white,
                  padding:
                      EdgeInsets.only(top: 13, bottom: 13, left: 14, right: 14),
                ),
                child: Text('Save Password',
                    style: GoogleFonts.salsa(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ),
            ),

            /*          Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Handle the button press, e.g., validate and save passwords
                  String password = passwordController.text;
                  String confirmPassword = confirmPasswordController.text;

                  if (password == confirmPassword &&
                      isPasswordValid(password)) {
                    // Passwords match and meet requirements, you can proceed
                    print("Password: $password");
                    setState(() {
                      showPassword = false;
                    });
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Login()));
                  } else {
                    // Passwords don't match or don't meet requirements, show an error message
                    setState(() {
                      showPassword = false;
                    });
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Notice!"),
                          content: Text(
                              "Passwords don't match or don't meet requirements."),
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
                },
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff003262),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.only(
                        top: 13, bottom: 13, left: 10, right: 10)),
                child: Text('Save Password and Go LogIn',
                    style: GoogleFonts.salsa(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))),
              ),
            ),
  */
          ],
        ),
      ),
    );
  }

  bool isPasswordValid(String password) {
    // Password must have at least one uppercase letter, one lowercase letter, one digit, and one special character
    String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }
}


/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PassWordNew extends StatefulWidget {
  const PassWordNew({Key? key}) : super(key: key);

  @override
  _PassWordNewState createState() => _PassWordNewState();
}

class _PassWordNewState extends State<PassWordNew> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 90),
            child: Image(
              image: AssetImage("images/addnewpass.jpeg"),
            ),
          ),
          Container(
            child: Text(
              "Add New Password",
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
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: TextFormField(
              controller: passwordController,
              obscureText: true, // Hide the entered text for passwords
              decoration: InputDecoration(
                labelText: 'Enter Password',
                labelStyle: GoogleFonts.salsa(
                  textStyle:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: TextFormField(
              controller: confirmPasswordController,
              obscureText: true, // Hide the entered text for passwords
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: GoogleFonts.salsa(
                  textStyle:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: () {
                // Handle the button press, e.g., validate and save passwords
                String password = passwordController.text;
                String confirmPassword = confirmPasswordController.text;

                if (password == confirmPassword) {
                  // Passwords match, you can proceed
                  print("Password: $password");
                } else {
                  // Passwords don't match, show an error message
                  print("Passwords don't match");
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff003262),
                onPrimary: Colors.white,
              ),
              child: Text('Save Password'),
            ),
          ),
        ],
      ),
    );
  }
}

*/