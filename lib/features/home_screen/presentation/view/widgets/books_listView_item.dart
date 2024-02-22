import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_app/cores/utils/color_degree.dart';
import 'package:test_app/features/home_screen/data/models/book_model.dart';

import '../../../../../cores/utils/fonts.dart';
import '../book_viewer.dart';

class BooksListViewItem extends StatefulWidget {
  final BookModel model;

  const BooksListViewItem({super.key, required this.model});

  @override
  State<BooksListViewItem> createState() => _BooksListViewItemState();
}

class _BooksListViewItemState extends State<BooksListViewItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 15),
      vsync: this,
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        }
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    BookPdfViewer(
                      bookModel: widget.model,
                    )));
      },
      child: Container(
        height: MediaQuery.sizeOf(context).height * .16,
        width: MediaQuery.sizeOf(context).width,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 100 / 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.model.imageUrl ??
                      'https://img1.od-cdn.com/ImageType-400/6852-1/06C/4AD/1E/%7B06C4AD1E-9D1C-42B5-986D-BD6806FEEE5A%7DImg400.jpg',
                  fit: BoxFit.fill,
                  placeholder: (context, url) => TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return AnimatedOpacity(
                            opacity: _animationController.value,
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              color: Colors.grey.withLightness(.7),
                            ));
                      }),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.title ?? ' - - - - -',
                    style: AppFonts.aBeeZeeTextStyle20,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.model.author ?? ' - - - - -',
                    style: AppFonts.abelTextStyle18,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    'Click Here To Read',
                    style:
                        AppFonts.abelTextStyle18.copyWith(color: Colors.blue),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
