import 'package:flutter/material.dart';
import 'package:test_app/cores/utils/fonts.dart';
import 'package:test_app/features/home_screen/data/models/book_model.dart';
import 'package:test_app/features/home_screen/presentation/view/widgets/books_listView_item.dart';

import '../../../../cores/widgets/custom_textfield_rounded_border.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Books List',
                    style: AppFonts.aBeeZeeTextStyle25.copyWith(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * .05,
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: CustomTextFieldRoundedBorder(
                    hint: 'What Book Do You Want?',
                    topRight: 20,
                    topLeft: 20,
                    bottomLeft: 20,
                    bottomRight: 20,
                    padding: EdgeInsets.all(15),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              SliverList.separated(
                itemBuilder: (context, index) => BooksListViewItem(
                  model: BookModel(),
                ),
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  width: MediaQuery.sizeOf(context).width,
                  color: Colors.grey,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                ),
                itemCount: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
