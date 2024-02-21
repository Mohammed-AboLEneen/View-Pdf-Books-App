abstract class BookPdfViewerStates {}

class BookPdfViewerInitialState extends BookPdfViewerStates {}

class BookPdfViewerLoadingState extends BookPdfViewerStates {}

class BookPdfViewerSuccessState extends BookPdfViewerStates {}

class BookPdfViewerFailureState extends BookPdfViewerStates {
  final String error;

  BookPdfViewerFailureState(this.error);
}
