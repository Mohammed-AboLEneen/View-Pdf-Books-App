import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:test_app/cores/methods/toast.dart';
import 'package:test_app/cores/utils/fonts.dart';
import 'package:test_app/features/home_screen/data/models/book_model.dart';
import 'package:test_app/features/home_screen/presentation/view/widgets/failure_widget.dart';
import 'package:test_app/features/home_screen/presentation/view_model/book_pdf_viewer_cubit/bool_pdf_viewer_cubit.dart';
import 'package:test_app/features/home_screen/presentation/view_model/book_pdf_viewer_cubit/bool_pdf_viewer_states.dart';

import '../../../../cores/methods/show_d.dart';
import 'book_markers_view.dart';

/// Represents Homepage for Navigation
class BookPdfViewer extends StatefulWidget {
  final BookModel bookModel;
  const BookPdfViewer({Key? key, required, required this.bookModel})
      : super(key: key);
  @override
  _BookPdfViewer createState() => _BookPdfViewer();
}

class _BookPdfViewer extends State<BookPdfViewer> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final TextEditingController controller = TextEditingController();
  String selectedText = '';
  List<PdfTextLine>? textLines;
  List<PdfBookmark> markers = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            BookPdfViewerCubit()..downloadPdf(bookModel: widget.bookModel),
        child: BlocConsumer<BookPdfViewerCubit, BookPdfViewerStates>(
            listener: (context, state) {},
            builder: (context, state) {
              BookPdfViewerCubit bookPdfViewerCubit =
                  BookPdfViewerCubit.get(context);
              if (state is BookPdfViewerSuccessState) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      widget.bookModel.title ?? '',
                      style: AppFonts.abelTextStyle18
                          .copyWith(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: const Icon(
                          Icons.bookmark,
                          color: Colors.black,
                          semanticLabel: 'Bookmark',
                        ),
                        onPressed: () {
                          if (markers.isNotEmpty) {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      BookMarkersListView(
                                    bookmarks: markers,
                                    pdfViewerController: _pdfViewerController,
                                  ),
                                ));
                          } else {
                            showToast(
                                msg: 'Wait Until the book is loaded',
                                toastMessageType:
                                    ToastMessageType.waitingMessage);
                          }
                        },
                      ),
                    ],
                  ),
                  body: SfPdfViewer.file(
                    bookPdfViewerCubit.file!,
                    key: _pdfViewerKey,
                    pageLayoutMode: PdfPageLayoutMode.single,
                    onAnnotationAdded: (a) async {
                      a.name = selectedText;
                      List<int> s = await _pdfViewerController.saveDocument();
                      bookPdfViewerCubit.file!.writeAsBytes(s);
                      print('saved');
                    },
                    enableTextSelection: true,
// Enable text selection

                    onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                      for (int i = 0;
                          i < details.document.bookmarks.count;
                          i++) {
                        markers.add(details.document.bookmarks[i]);
                      }
                    },
                    onTextSelectionChanged: (a) async {
                      selectedText = a.selectedText!;
                      textLines =
                          _pdfViewerKey.currentState?.getSelectedTextLines();
                    },
                    controller: _pdfViewerController,
                    onAnnotationSelected: (a) async {
                      controller.text = a.subject ?? '';

                      await showComment(context,
                          title: a.name ?? '', controller: controller);

                      if (a.subject == controller.text ||
                          (a.subject == null && controller.text.isEmpty)) {
                        return;
                      }

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
                      List<int> s = await _pdfViewerController.saveDocument();
                      bookPdfViewerCubit.file!.writeAsBytes(s);
                    },
                  ),
                );
              } else if (state is BookPdfViewerFailureState) {
                return FailureWidget(
                  action: () {
                    bookPdfViewerCubit.downloadPdf(bookModel: widget.bookModel);
                  },
                );
              } else {
                return Scaffold(
                    body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Wait to download the book...',
                        style: AppFonts.abelTextStyle18,
                      )
                    ],
                  ),
                ));
              }
            }));
  }
}
