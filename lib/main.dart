import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:test_app/methods/show_d.dart';
import 'package:test_app/utils/book_markers_view.dart';
import 'package:test_app/utils/shared_pre_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferenceHelper.initSharedPreference();
  await Hive.initFlutter();
  runApp(MaterialApp(
    title: 'Syncfusion PDF Viewer Demo',
    theme: ThemeData(
      useMaterial3: false,
    ),
    home: HomePage(),
  ));
}

/// Represents Homepage for Navigation
class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
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

  Future<void> downloadFile() async {
    Directory? downloadsDirectory = await getDownloadsDirectory();
    String path =
        '${downloadsDirectory?.path}/koko0vgdr0.0vvd0cs..sxsvpkpkcssxfd.pdf';
    file = File(path);

    if (!await file.exists()) {
      String assetName =
          'assets/head_first_kotlin.pdf'; // Replace with your asset's path
      List<int> assetBytes =
          (await rootBundle.load(assetName)).buffer.asUint8List();
      await file.writeAsBytes(assetBytes);
    }

    isloaded = true;

    comments = SharedPreferenceHelper.getStringList(
          key: commentListKey,
        ) ??
        [];

    print(comments);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    downloadFile();
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
                List<int> s = await _pdfViewerController.saveDocument();
                file.writeAsBytes(s);
              },
              enableTextSelection: true,
              // Enable text selection

              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                for (int i = 0; i < details.document.bookmarks.count; i++) {
                  markers.add(details.document.bookmarks[i]);
                }
              },
              onTap: (a) {
                // print(markers[4].title);
                // _pdfViewerController.jumpToBookmark(markers[4]);
              },
              onTextSelectionChanged: (a) async {
                selectedText = a.selectedText!;
                textLines = _pdfViewerKey.currentState?.getSelectedTextLines();

                print('textLines :${textLines?.toList()}');
              },
              controller: _pdfViewerController,
              onAnnotationSelected: (a) async {
                int index = -1;

                _pdfViewerController
                    .getAnnotations()
                    .asMap()
                    .entries
                    .forEach((element) {
                  if (element.value.hashCode == a.hashCode) {
                    index = element.key;
                    controller.text = a.subject ?? '';
                  }
                });

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
                await _pdfViewerController.saveDocument();
              },

              onAnnotationEdited: (a) {
                print('edit');
              },
            )
          : Container(),
    );
  }

  void editAnnotation(int hashCode,
      {required String content, required int index}) async {
    // Get the list of annotations in the PDF document.
    List<Annotation> annotations = _pdfViewerController.getAnnotations();

    if (annotations.isNotEmpty) {
      if (comments.length > index) {
        comments[index] = content;
      } else {
        comments.add(content);
      }

      await SharedPreferenceHelper.setStringList(
          key: commentListKey, value: comments);
    }
  }
}
