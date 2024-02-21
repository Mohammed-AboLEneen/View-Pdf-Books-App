import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/home_screen/presentation/view_model/home_screen_cubit/home_screen_states.dart';

import '../../../data/models/book_model.dart';

class HomeScreenCubit extends Cubit<HomeScreenStates> {
  HomeScreenCubit() : super(InitHomeScreenState());

  static HomeScreenCubit get(context) => BlocProvider.of(context);

  List<BookModel> booksList = [];

  Future<void> getBooksData() async {
    emit(LoadingGetHomeScreenBooks());

    try {
      final db = FirebaseFirestore.instance;
      final collectionRef = db.collection('books');
      QuerySnapshot<Map<String, dynamic>> data = await collectionRef.get();

      for (var element in data.docs) {
        booksList.add(BookModel.fromJson(element.data()));
      }

      if (booksList.isNotEmpty) {
        emit(SuccessGetHomeScreenBooks());
      } else {
        emit(FailureGetHomeScreenBooks('No Data Found'));
      }
    } catch (e) {
      emit(FailureGetHomeScreenBooks('There is something wrong, try Again'));
    }
  }
}
