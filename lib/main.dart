import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:test_app/methods/show_d.dart';
import 'package:test_app/utils/shared_pre_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferenceHelper.initSharedPreference();
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
  String commentListKey = 'commentListKeys100';

  Future<void> downloadFile() async {
    Directory? downloadsDirectory = await getDownloadsDirectory();
    String path = '${downloadsDirectory?.path}/hht0t1000.pdf';
    file = File(path);

    if (!await file.exists()) {
      String assetName =
          'assets/Mohammed-Elsharkawy_FlutterDeveloper.pdf'; // Replace with your asset's path
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
            onPressed: () {},
          ),
        ],
      ),
      body: isloaded
          ? SfPdfViewer.file(
              file,
              onAnnotationAdded: (a) async {
                a.name = selectedText;

                List<int> s = await _pdfViewerController.saveDocument();
                file.writeAsBytes(s);
              },
              onTextSelectionChanged: (a) async {
                selectedText = a.selectedText!;
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

                    a.subject = comments.length > index ? comments[index] : '';
                    controller.text = a.subject ?? '';
                  }
                });

                await showComment(context,
                    title: a.name ?? '', controller: controller);
                a.subject = controller.text;
                editAnnotation(a.hashCode,
                    content: a.subject!.isEmpty ? '' : a.subject!,
                    index: index);
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
      // Get the first annotation from the PDF document.
      Annotation? firstAnnotation =
          annotations.firstWhere((element) => element.hashCode == hashCode);

      // Edit the first annotation in the PDF document.

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
