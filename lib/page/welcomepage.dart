import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.getStarted});
  final Function() getStarted;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/welcome.svg',
              width: 300,
              height: 300,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Welcome to Geo Silent",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Text(
                "We require access to your device's location and sound settings to continue",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: FilledButton(
                onPressed: getStarted,
                child: const Text('Get Started'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
