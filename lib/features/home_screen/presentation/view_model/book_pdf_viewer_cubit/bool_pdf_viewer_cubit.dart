import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:test_app/features/home_screen/data/models/book_model.dart';

import '../../../../../cores/methods/download_file.dart';
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
}
