import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/utils/color_degree.dart';

Future<void> showComment(context,
    {required String title, required TextEditingController controller}) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: AlertDialog(
          backgroundColor: Colors.white.withLightness(.9),
          title: Text(
            title,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.aBeeZee(),
          ),
          content: TextField(
            controller: controller,
            style: GoogleFonts.abel(),
            decoration: InputDecoration(
                hintText: 'Enter a comment',
                hintStyle: GoogleFonts.abel()
                    .copyWith(color: Colors.black.withOpacity(.7)),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                )),
            maxLines: 3,
            minLines: 1,
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
              ),
              onPressed: () {
                // Perform some action
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'OK',
                style: GoogleFonts.aBeeZee().copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    },
  );
}
