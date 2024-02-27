import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:test_app/features/home_screen/data/models/book_model.dart';

import '../../../../../cores/methods/download_file.dart';
import '../../../data/models/heighlight_model.dart';
import 'bool_pdf_viewer_states.dart';

class BookPdfViewerCubit extends Cubit<BookPdfViewerStates> {
  BookPdfViewerCubit() : super(BookPdfViewerInitialState());

  static BookPdfViewerCubit get(context) => BlocProvider.of(context);

  File? file;
  late PdfDocument document;
  String fileName = '';

  Future<void> downloadPdf({required BookModel bookModel}) async {
    emit(BookPdfViewerLoadingState());

    try {
      file = await downloadFile(
          url: bookModel.bookUrl ?? '', filename: bookModel.title ?? '');
      final Directory directory = await getApplicationDocumentsDirectory();

      fileName = '${directory.path}/${bookModel.title}';
      document = PdfDocument(inputBytes: file!.readAsBytesSync());

      emit(BookPdfViewerSuccessState());
    } catch (e) {
      emit(BookPdfViewerFailureState(e.toString()));
    }
  }

  void addHeightLightAnnotations(PdfViewerController pdfViewerController,
      List<HeightLightModel> heightLightModels) {
    for (int i = 0;
        i <
            document
                .pages[pdfViewerController.pageNumber - 1].annotations.count;
        i++) {
      if (document.pages[pdfViewerController.pageNumber - 1].annotations[i]
          .author.isNotEmpty) {
        heightLightModels.add(HeightLightModel(
            name: document
                .pages[pdfViewerController.pageNumber - 1].annotations[i].text,
            bounds: document.pages[pdfViewerController.pageNumber - 1]
                .annotations[i].bounds,
            subject: document.pages[pdfViewerController.pageNumber - 1]
                .annotations[i].subject,
            author: document.pages[pdfViewerController.pageNumber - 1]
                .annotations[i].author));
      }
    }
  }

  List<HeightLightModel> getOrderedHeightLightAnnotations(
      PdfViewerController pdfViewerController) {
    List<HeightLightModel> heightLightModels = [];
    addHeightLightAnnotations(pdfViewerController, heightLightModels);
    heightLightModels.sort((a, b) =>
        int.parse(a.author ?? '').compareTo(int.parse(b.author ?? '')));

    return heightLightModels;
  }
}
