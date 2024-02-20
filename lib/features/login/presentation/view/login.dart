import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_app/cores/utils/fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, -.5),
      end: const Offset(0.0, 0),
    ).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipPath(
            clipper: CustomTopClipper(),
            child: Container(
              decoration: const BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.blue, Colors.indigo])),
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * .23,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .1,
          ),
          AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: _animationController.value,
                  child: SlideTransition(
                    position: _animation,
                    child: Text(
                      'Welcome',
                      style: AppFonts.textStyle30,
                    ),
                  ),
                );
              }),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .06,
            child: IntrinsicWidth(
              child: TextButton(
                  onPressed: () async {
                    // await googleSignOut();
                    // loginCubit.createOrSignInWithGoogle();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue.withOpacity(.4)),
                      // Set the desired background color here
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(horizontal: 5)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder?>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )))),
                  child: Row(
                    children: [
                      const Icon(FontAwesomeIcons.google),
                      const SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          'Sign in with google',
                          style: AppFonts.textStyle18,
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          const Spacer(),
          Transform.rotate(
            angle: 2 * 1.57079633,
            child: ClipPath(
              clipper: CustomTopClipper(),
              child: Container(
                decoration: const BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.blue, Colors.indigo])),
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * .23,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var firstControlPoint = Offset(55, size.height / 1.4);
    var firstEndPoint = Offset(size.width / 1.7, size.height / 1.3);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (35), size.height - 95);
    var secondEndPoint = Offset(size.width, size.height / 2.4);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class CustomBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    var firstControlPoint =
        Offset(size.width - 55, size.height - (size.height / 1.4));
    var firstEndPoint = Offset(
        size.width - (size.width / 1.7), size.height - (size.height / 1.3));
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(35, size.height - 95);
    var secondEndPoint = Offset(0.0, size.height / 2.4);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(0.0, size.height - 40);
    path.lineTo(0.0, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
