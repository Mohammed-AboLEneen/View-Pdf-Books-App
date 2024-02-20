import 'package:flutter/material.dart';
import 'package:test_app/features/home_screen/data/models/book_model.dart';

import '../../../../../cores/utils/fonts.dart';

class BooksListViewItem extends StatelessWidget {
  final BookModel model;

  const BooksListViewItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: MediaQuery.sizeOf(context).height * .15,
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            Image.network(model.imageUrl ??
                'https://img1.od-cdn.com/ImageType-400/6852-1/06C/4AD/1E/%7B06C4AD1E-9D1C-42B5-986D-BD6806FEEE5A%7DImg400.jpg'),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title ?? ' - - - - -',
                    style: AppFonts.aBeeZeeTextStyle20,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    model.author ?? ' - - - - -',
                    style: AppFonts.abelTextStyle18,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
