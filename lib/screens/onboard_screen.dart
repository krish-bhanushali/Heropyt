import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:heroypt/screens/home_screen.dart';
import 'package:lottie/lottie.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black12,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Lottie.asset(
                'assets/5720-trustless.json',
              ),
            ),
            SizedBox(
              height: height * 0.2,
            ),
            Text('Crypto',
                textAlign: TextAlign.left,
                style: GoogleFonts.spaceMono(
                  color: Colors.white,
                  fontSize: 32,
                )),
            Text('Currency',
                style: GoogleFonts.spaceMono(
                  color: Colors.white,
                  fontSize: 32,
                )),
            SizedBox(
              height: 10.0,
            ),
            Text(
                'A digital asset designed to work as a medium of exchangeand to secure transaction records',
                style:
                    GoogleFonts.spaceMono(color: Colors.white, fontSize: 12)),
            SizedBox(
              height: 40.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 50.0,
                      child: Center(
                        child: Text('Sign In',
                            style: GoogleFonts.spaceMono(
                                color: Colors.white, fontSize: 12)),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                    )),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HomeScreen()));
                  },
                  child: Container(
                    height: 50.0,
                    child: Center(
                      child: Text('Skip',
                          style: GoogleFonts.spaceMono(
                              color: Colors.white, fontSize: 12)),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
