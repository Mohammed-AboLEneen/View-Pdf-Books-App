import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookMarkersListView extends StatelessWidget {
  final List<PdfBookmark> bookmarks;
  final PdfViewerController pdfViewerController;

  const BookMarkersListView(
      {super.key, required this.bookmarks, required this.pdfViewerController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book marks',
          style: GoogleFonts.aBeeZee(),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              final destination = bookmarks[index].destination;
              if (destination != null) {
                print('bookmarks ${destination.page.size}');
                print('bookmarks ${destination.page}');

                print('bookmarks ${destination.page}');

                pdfViewerController.jumpToBookmark(bookmarks[index]);
              } else {
                print('This book mark is empty');
              }
              print('bookmarks ${bookmarks[9].title}');
              print('bookmarks ${bookmarks[9].count}');

              Navigator.pop(context);
            },
            child: BookMarker(
              title: bookmarks[index].title,
            )),
        separatorBuilder: (context, index) => Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * .05, vertical: 10),
          child: const Divider(
            height: 1,
            color: Colors.grey,
          ),
        ),
        itemCount: bookmarks.length,
      ),
    );
  }
}

class BookMarker extends StatelessWidget {
  final String title;

  const BookMarker({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.abel(),
      ),
      trailing: const Icon(
        Icons.arrow_back_ios_new_outlined,
      ),
    );
  }
}
