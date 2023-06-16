import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazygoauth/map_auth.dart';
import 'package:eazygoauth/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html';
import 'package:url_launcher/url_launcher.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool isHidden = true;
  Icon i = Icon(Icons.visibility_outlined);
  void visible() {
    setState(() {
      isHidden = !isHidden;
    });
    if (isHidden) {
      i = Icon(Icons.visibility_outlined);
    } else {
      i = Icon(Icons.visibility_off_outlined);
    }
  }

  Color color1 = Color.fromRGBO(217, 233, 230, 1);
  Color color2 = Color(0xff1c6758);
  void sendEmail() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Registration',
              style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.bold, color: color2),
            ),
            content: Container(
              width: double.minPositive,
              child: Text(
                'To register yourself as an authority, please send an email with area of provision (location) and document of proof attached. We will review your document and approve your registration as soon as possible.\n\nWith regards,\neazyGo Team',
                style: GoogleFonts.urbanist(),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        final Uri emailUri = Uri(
                          scheme: 'https',
                          path: 'aswin_asokan@outlook.com',
                          queryParameters: {
                            'subject': 'Authority Registration - [Your Name]',
                            'body':
                                'Dear eazyGo Team,\n\tI hope this email finds you well. I am writing to express my interest in registering as an authority on your website. I believe that my expertise and credentials make me a suitable candidate for this role.\n\nPlease find attached the necessary documents and area of provision location to support my registration as an authority, including:\n\n1.[Proof Document 1]\n2.[Proof Document 2]\n3.[location(latitude and longitude if possible)]\n\n\tI kindly request you to review my application and consider granting me the authority status. I am confident that I can contribute valuable insights and assistance to the users of your website.\n\tIf you require any additional information or have any questions, please do not hesitate to contact me. I am readily available at [Your Contact Information].\n\nThank you for considering my application. I look forward to the opportunity to serve as an authority on your website.\n\nBest regards,\n\n[Your Name]\n[Your Title/Position]\n[Your Contact Information]',
                          },
                        );

                        final gmailUrl = Uri(
                          scheme: 'https',
                          host: 'mail.google.com',
                          path: '/mail/u/0/',
                          queryParameters: {
                            'view': 'cm',
                            'to': emailUri.path,
                            'su': emailUri.queryParameters['subject'],
                            'body': emailUri.queryParameters['body'],
                          },
                        );

                        window.open(gmailUrl.toString(), '_blank');
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mail_outline_outlined,
                            color: color2,
                          ),
                          Text(
                            '  Send Mail',
                            style: GoogleFonts.urbanist(color: color2),
                          )
                        ],
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          Text(
                            '  Cancel',
                            style: GoogleFonts.urbanist(color: Colors.red),
                          )
                        ],
                      )),
                ],
              ),
            ],
          );
        });
  }

  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  bool a = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final font, h, w, l, h1, h2;

    if (width < 570 && height < 360) {
      h2 = height * 0.08;
      l = width * 0.53;
      font = width * 0.03;
      h = height;
      w = width;
    } else if (width < 570 && height > 0) {
      h2 = height * 0.08;
      l = width * 0.53;
      font = width * 0.03;
      h = height;
      w = width;
    } else if (width > 650 && height < 355 && height > 370) {
      h2 = height * 0.07;
      l = width * 0.2;
      h = height * 0.7;
      w = width * 0.4;
      font = height * 0.05;
    } else if (width > 570 && height > 315 && width < 750) {
      h2 = height * 0.07;
      l = width * 0.2;
      h = height * 0.7;
      w = width * 0.4;
      font = width * 0.014;
    } else if (width > 0 && height < 370) {
      h2 = height * 0.07;
      l = width * 0.2;
      h = height;
      w = width;
      font = width * 0.01;
    } else if (width > 750 && height > 560) {
      h2 = height * 0.07;
      l = width * 0.2;
      h = height * 0.7;
      w = width * 0.25;
      font = width * 0.01;
    } else {
      h2 = height * 0.06;
      l = width * 0.2;
      h = height * 0.7;
      w = width * 0.25;
      font = width * 0.01;
    }
    if (height < 400) {
      h1 = height * 0.01;
    } else if (height < 520) {
      h1 = height * 0.05;
    } else {
      h1 = height * 0.05;
    }

    return Scaffold(
      backgroundColor: color1,
      body: Align(
        alignment: Alignment.center,
        child: Container(
          height: h,
          width: w,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: height * 0.13,
                      child: Image.asset('images/logo.png')),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Authority\nLogin',
                      style: GoogleFonts.urbanist(
                          color: Color(0xff1c6758),
                          fontSize: font,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  width: l,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Smaller TextField
                      SizedBox(
                        width: 30,
                        child: TextField(
                          style:
                              GoogleFonts.urbanist(fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.alternate_email_rounded,
                              size: font,
                            ),
                            enabled: false,
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff1c6758))),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _email,
                          cursorColor: Color.fromRGBO(28, 103, 88, 1),
                          style:
                              GoogleFonts.urbanist(fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff1c6758))),
                            hintStyle: GoogleFonts.urbanist(fontSize: font),
                            hintText: 'Email ID',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  width: l,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Smaller TextField
                      SizedBox(
                        width: 30,
                        child: TextField(
                          style:
                              GoogleFonts.urbanist(fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              size: font,
                            ),
                            enabled: false,
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff1c6758))),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _pass,
                          obscureText: isHidden,
                          cursorColor: Color.fromRGBO(28, 103, 88, 1),
                          style:
                              GoogleFonts.urbanist(fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: visible,
                              icon: i,
                              iconSize: font,
                              color: Color.fromRGBO(155, 155, 155, 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff1c6758))),
                            hintStyle: GoogleFonts.urbanist(fontSize: font),
                            hintText: 'Password',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              if (a)
                TextButton(
                  onPressed: () async {
                    try {
                      String email = _email.text;
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Recovery Email Successfully Sent'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xff1c6758),
                      ));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Something went wrong'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xff1c6758),
                      ));
                    }
                  },
                  child: Text(
                    "Forgot Password?",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.urbanist(
                        fontSize: font, color: Color.fromRGBO(28, 103, 88, 1)),
                  ),
                ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                height: h2,
                width: l,
                child: ElevatedButton(
                    onPressed: () async {
                      String email = _email.text;
                      String password = _pass.text;
                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance
                          .collection('authority')
                          .where('provider', isEqualTo: email)
                          .get();
                      if (querySnapshot.docs.isNotEmpty) {
                        for (var doc in querySnapshot.docs) {
                          provider = doc['provider'];
                          name = doc['name'];
                          location = doc['location'];
                          position = doc['latlng'];
                        }
                      }
                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Enter all Fields'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Color(0xff1c6758),
                        ));
                      } else if (email == provider) {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email, password: password)
                            .then((value) async {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const map_auth())));
                        }).onError((error, stackTrace) {
                          setState(() {
                            a = true;
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Email or Password Error'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Color(0xff1c6758),
                          ));
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Register Yourself to Login'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Color(0xff1c6758),
                        ));
                      }
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                        backgroundColor:
                            const MaterialStatePropertyAll(Color(0xff1c6758))),
                    child: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontSize: font,
                          fontWeight: FontWeight.w600),
                    )),
              ),
              SizedBox(
                height: h1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an Account?',
                    style: GoogleFonts.urbanist(
                      fontSize: font,
                    ),
                  ),
                  TextButton(
                    onPressed: sendEmail,
                    child: Text(
                      "Register Here",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.urbanist(
                          fontSize: font,
                          color: Color.fromRGBO(28, 103, 88, 1)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
