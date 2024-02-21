import 'package:flutter/material.dart';

import '../../../../../cores/utils/fonts.dart';
import '../../../../../cores/widgets/custom_textfield_rounded_border.dart';
import '../../../data/models/book_model.dart';
import '../book_viewer.dart';
import 'books_listView_item.dart';

class HomeScreenWidget extends StatelessWidget {
  final List<BookModel> booksList;

  const HomeScreenWidget({super.key, required this.booksList});

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
                  height: MediaQuery.sizeOf(context).height * .03,
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
                itemBuilder: (context, index) =>
                    BooksListViewItem(model: booksList[index]),
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  width: MediaQuery.sizeOf(context).width,
                  color: Colors.grey,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                ),
                itemCount: booksList.length,
              )
            ],
          ),
        ),
      ),
    );
  }
}
