import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_app/cores/methods/toast.dart';
import 'package:test_app/cores/utils/color_degree.dart';
import 'package:test_app/cores/utils/fonts.dart';
import 'package:test_app/features/login/presentation/view_model/login_cubit/login_cubit.dart';

import '../../../../cores/methods/google_sign_out.dart';
import '../view_model/login_cubit/login_state.dart';

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
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(listener: (context, state) {
        if (state is SuccessLoginState) {
          showToast(
              msg: 'Login Success',
              toastMessageType: ToastMessageType.successMessage);
        } else if (state is FailureLoginState) {
          showToast(
              msg: state.message,
              toastMessageType: ToastMessageType.failureMessage);
        }
      }, builder: (context, state) {
        var cubit = LoginCubit.get(context);
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * .3,
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: CustomTopClipper(),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.blue, Colors.indigo])),
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height * .25,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                        'assets/images/through_the_desert.svg',
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * .05,
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
                        await googleSignOut();
                        cubit.signInWithGoogle();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.withOpacity(.4)),
                          // Set the desired background color here
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(horizontal: 5)),
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder?>(
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
              if (state is LoadingLoginState)
                Container(
                  width: MediaQuery.sizeOf(context).width * .7,
                  margin: const EdgeInsets.only(top: 10),
                  child: const LinearProgressIndicator(
                    color: Colors.indigo,
                  ),
                ),
              const Spacer(),
              Transform.rotate(
                angle: 2 * 1.57079633,
                child: ClipPath(
                  clipper: CustomTopClipper(),
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.blue, Colors.indigo])),
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * .25,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Transform.rotate(
                          angle: 2 * 1.57079633,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.googleDrive,
                                color: Colors.white,
                                size: 50,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'ReadMe Books',
                                style: AppFonts.textStyle18.copyWith(
                                  color: Colors.white.withLightness(.95),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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
