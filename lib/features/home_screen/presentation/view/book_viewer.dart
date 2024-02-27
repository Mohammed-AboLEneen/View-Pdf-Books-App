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
import '../../data/models/heighlight_model.dart';
import 'book_markers_view.dart';

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
  List<PdfBookmark> markers = [];
  //get the index of selected annotation if i add new one with same index(edit i mean).
  int changableAnnotationIndex = 0;
  //get the current height Lights count to give index for new annotations.
  int heightLightscount = 0;
  // if true i will edit the annotation (the index will be changableAnnotationIndex) else i will add new one (the index will be heightLightscount).
  bool isEdit = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pdfViewerController.dispose();
  }

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
                      selectedText =
                          selectedText.isNotEmpty && a.selectedText == null
                              ? selectedText
                              : a.selectedText ?? '';
                    },
                    onPageChanged: (a) {
                      getHeightLightAnnotationsCount(
                          bookPdfViewerCubit.document);
                    },
                    controller: _pdfViewerController,
                    onAnnotationAdded: (a) async {
                      bookPdfViewerCubit.document = PdfDocument(
                        inputBytes: bookPdfViewerCubit.file!.readAsBytesSync(),
                      );


                      if (selectedText.isNotEmpty && isEdit == false) {
                        a.name = selectedText;
                      }

                      a.author = isEdit
                          ? changableAnnotationIndex.toString()
                          : '$heightLightscount';
                      heightLightscount++;

                      List<int> bytes =
                          await _pdfViewerController.saveDocument();

                      await bookPdfViewerCubit.file!.writeAsBytes(bytes);
                      bookPdfViewerCubit.document = PdfDocument(
                        inputBytes: bookPdfViewerCubit.file!.readAsBytesSync(),
                      );
                    },

                    onAnnotationSelected: (a) async {
                      // read the new annotations.
                      List<HeightLightModel> heightLightModels;
                      // get the height light annotations from document and sort them based on author(index)
                      heightLightModels =
                          bookPdfViewerCubit.getOrderedHeightLightAnnotations(
                              _pdfViewerController);

                      heightLightModels.sort((a, b) => int.parse(a.author ?? '')
                          .compareTo(int.parse(b.author ?? '')));
                      controller.text = a.subject ?? '';

                      await showComment(context,
                          title: a.name ?? '', controller: controller);

                      if (a.subject == controller.text ||
                          (a.subject == null && controller.text.isEmpty)) {
                        return;
                      }

                      addNewAnnotation(heightLightModels, a);

                      List<int> bytes =
                          await _pdfViewerController.saveDocument();
//Saves the bytes to the file system

                      await bookPdfViewerCubit.file!.writeAsBytes(bytes);
                      bookPdfViewerCubit.document = PdfDocument(
                        inputBytes: bookPdfViewerCubit.file!.readAsBytesSync(),
                      );
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
                        height: 10,
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

  void addNewAnnotation(
      List<HeightLightModel> heightLightModels, Annotation a) {
    HighlightAnnotation annotation = HighlightAnnotation(textBoundsCollection: [
      PdfTextLine(heightLightModels[int.parse(a.author ?? '')].bounds,
          a.name ?? '000', _pdfViewerController.pageNumber)
    ]);
    annotation.subject = controller.text;
    annotation.author = a.author;
    annotation.name = heightLightModels[int.parse(a.author ?? '')].name;
    changableAnnotationIndex = int.parse(a.author ?? '10');

    isEdit = true;
    _pdfViewerController.removeAnnotation(a);
    heightLightscount--;
    _pdfViewerController.addAnnotation(annotation);
    isEdit = false;
  }

  void getHeightLightAnnotationsCount(PdfDocument document) {
    heightLightscount = 0;
    for (int i = 0;
        i <
            document
                .pages[_pdfViewerController.pageNumber - 1].annotations.count;
        i++) {
      if (document.pages[_pdfViewerController.pageNumber - 1].annotations[i]
          .author.isNotEmpty) {
        heightLightscount++;
      }
    }
  }
}
