import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:untitled4/login.dart';
import 'package:untitled4/wel.dart';
import 'package:firebase_core/firebase_core.dart';

class teck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAnimationScreen(),
    );
  }
}

class MyAnimationScreen extends StatefulWidget {
  @override
  _MyAnimationScreenState createState() => _MyAnimationScreenState();
}

class _MyAnimationScreenState extends State<MyAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  double _imageOffsetY = 0.0;
  double _textOpacity = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4), // Adjust the duration as needed
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _startAnimation();
  }

  void _startAnimation() {
    _controller.forward();

    _controller.addListener(() {
      setState(() {
        _imageOffsetY = -50.0 * _controller.value;
        _textOpacity = _controller.value;
      });

      if (_controller.value == 1.0) {
        // Wait for 5 seconds before navigating to the second page
        Future.delayed(Duration(seconds: 5), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Opacity(
            opacity: _opacity.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(0.0, 0.0),
                  child: Image.asset(
                    "images/TLp.png",
                    width: 80.0,
                    height: 80.0,
                   // color: Colors.black,
                  ),
                ),
                //SizedBox(height: 10.0),
                AnimatedOpacity(
                  opacity: _textOpacity,
                  duration: Duration(seconds: 1),
                  child: Text(
                    'TrainLink',
                    style: GoogleFonts.salsa(
                      textStyle: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff003262),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}