import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoPermissionPage extends StatelessWidget {
  const NoPermissionPage({super.key, required this.getPermission});
  final Function() getPermission;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/permission_denied.svg',
              width: 300,
              height: 300,
            ),
            const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "We require access to your device's location and sound settings to continue",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                )),
            TextButton(
              onPressed: getPermission,
              child: const Text('Continue'),
            )
          ],
        ),
      ),
    );
  }
}
