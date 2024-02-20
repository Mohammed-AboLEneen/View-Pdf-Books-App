import 'package:flutter/material.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../../cores/methods/download_file.dart';
import '../../../../../cores/methods/show_d.dart';
import '../../../../../cores/utils/book_markers_view.dart';

/// Represents Homepage for Navigation
class BookPdfViewer extends StatefulWidget {
  final String url;
  final String bookName;
  const BookPdfViewer(
      {Key? key, required, required this.url, required this.bookName})
      : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<BookPdfViewer> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  late File file;
  bool isloaded = false;
  final TextEditingController controller = TextEditingController();
  String selectedText = '';
  late List<String> comments;
  String commentListKey = 'commentListKeys1cd0sx00d00xc1gdgvkpk2xccvcvdccccc4';
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  List<PdfTextLine>? textLines;
  List<PdfBookmark> markers = [];

  Future<void> downloadAndLoadPdf() async {
    try {
      file = (await downloadFile(
        url: widget.url,
        filename: widget.bookName,
      ))!;
      isloaded = true;
    } catch (e) {
      isloaded = false;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    downloadAndLoadPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        BookMarkersListView(
                      bookmarks: markers,
                      pdfViewerController: _pdfViewerController,
                    ),
                  ));
            },
          ),
        ],
      ),
      body: isloaded
          ? SfPdfViewer.file(
              file,
              key: _pdfViewerKey,
              pageLayoutMode: PdfPageLayoutMode.single,
              onAnnotationAdded: (a) async {
                a.name = selectedText;
                await _pdfViewerController.saveDocument();
              },
              enableTextSelection: true,
// Enable text selection

              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                for (int i = 0; i < details.document.bookmarks.count; i++) {
                  markers.add(details.document.bookmarks[i]);
                }
              },
              onTextSelectionChanged: (a) async {
                selectedText = a.selectedText!;
                textLines = _pdfViewerKey.currentState?.getSelectedTextLines();
              },
              controller: _pdfViewerController,
              onAnnotationSelected: (a) async {
                controller.text = a.subject ?? '';

                await showComment(context,
                    title: a.name ?? '', controller: controller);

                if (a.subject == controller.text ||
                    (a.subject == null && controller.text.isEmpty)) return;

                if (textLines != null && textLines!.isNotEmpty) {
// Create the highlight annotation.
                  final HighlightAnnotation highlightAnnotation =
                      HighlightAnnotation(
                    textBoundsCollection: textLines!,
                  );
                  highlightAnnotation.name = a.name;
                  highlightAnnotation.subject = controller.text;
                  _pdfViewerController.removeAnnotation(a);
// Add the annotation to the PDF document.
                  _pdfViewerController.addAnnotation(highlightAnnotation);
                }
// we save the document after editing the annotation
                await _pdfViewerController.saveDocument();
              },
            )
          : Container(),
    );
  }
}
