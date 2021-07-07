import 'package:flutter/cupertino.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            color: Color.fromARGB(255, 241, 241, 241),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                    child: const Text(
                  'Welcome to Pet Clinic!',
                  textScaleFactor: 1.5,
                )),
                Image(
                  image: AssetImage('assets/images/pets.png'),
                ),
                Image(
                    height: 50, image: AssetImage('assets/images/flutter.png'))
              ],
            )));
  }
}
