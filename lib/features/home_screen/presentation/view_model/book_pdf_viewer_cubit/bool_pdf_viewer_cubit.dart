import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/home_screen/data/models/book_model.dart';

import '../../../../../cores/methods/download_file.dart';
import 'bool_pdf_viewer_states.dart';

class BookPdfViewerCubit extends Cubit<BookPdfViewerStates> {
  BookPdfViewerCubit() : super(BookPdfViewerInitialState());

  static BookPdfViewerCubit get(context) => BlocProvider.of(context);

  File? file;

  Future<void> downloadPdf({required BookModel bookModel}) async {
    emit(BookPdfViewerLoadingState());
    try {
      file = await downloadFile(
          url: bookModel.bookUrl ?? '', filename: bookModel.title ?? '');
      emit(BookPdfViewerSuccessState());
    } catch (e) {
      emit(BookPdfViewerFailureState(e.toString()));
    }
  }
}
