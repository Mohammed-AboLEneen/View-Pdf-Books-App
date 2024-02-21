import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/cores/methods/toast.dart';
import 'package:test_app/features/home_screen/presentation/view/widgets/failure_widget.dart';
import 'package:test_app/features/home_screen/presentation/view/widgets/home_screen_widget.dart';
import 'package:test_app/features/home_screen/presentation/view_model/home_screen_cubit/home_screen_cubit.dart';

import '../view_model/home_screen_cubit/home_screen_states.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeScreenCubit()..getBooksData(),
      child: BlocConsumer<HomeScreenCubit, HomeScreenStates>(
          listener: (context, state) {
        if (state is SuccessGetHomeScreenBooks) {
          showToast(
              msg: 'Enjoy', toastMessageType: ToastMessageType.successMessage);
        } else if (state is FailureGetHomeScreenBooks) {
          showToast(
              msg: 'Something went wrong',
              toastMessageType: ToastMessageType.failureMessage);
        } else {
          showToast(
              msg: 'Waiting Please',
              toastMessageType: ToastMessageType.waitingMessage);
        }
      }, builder: (context, state) {
        HomeScreenCubit homeScreenCubit = HomeScreenCubit.get(context);
        if (state is SuccessGetHomeScreenBooks) {
          return HomeScreenWidget(
            booksList: homeScreenCubit.booksList,
          );
        } else if (state is LoadingGetHomeScreenBooks) {
          return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
            color: Colors.blue,
          )));
        } else {
          return FailureWidget(
            action: () {
              homeScreenCubit.getBooksData();
            },
          );
        }
      }),
    );
  }
}
