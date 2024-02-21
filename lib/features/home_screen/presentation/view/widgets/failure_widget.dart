import 'package:flutter/material.dart';
import 'package:test_app/cores/utils/color_degree.dart';

import '../../../../../cores/utils/fonts.dart';

class FailureWidget extends StatelessWidget {
  final void Function()? action;

  const FailureWidget({super.key, this.action});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.sizeOf(context).height * .15,
        width: MediaQuery.sizeOf(context).width * .9,
        decoration: BoxDecoration(
            color: Colors.white.withLightness(.95),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'There is something wrong, try Again',
                style: AppFonts.aBeeZeeTextStyle20,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: action,
              child: Text(
                'Try Again',
                style: AppFonts.abelTextStyle18.copyWith(color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    ));
  }
}
