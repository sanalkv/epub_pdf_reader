import 'dart:io';

import 'package:epub_reader/core/model/book_details_model.dart';
import 'package:epub_reader/ui/shared/styles.dart';
import 'package:epub_reader/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';

class BookCoverWidget extends StatelessWidget {
  final BookDetails bookDetails;

  const BookCoverWidget({Key? key, required this.bookDetails}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (bookDetails.coverImage != null) {
      return Image.file(
        File(bookDetails.coverImage!),
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
        gaplessPlayback: true,
        frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: child,
          );
        },
      );
    } else {
      return Container(
        color: Colors.orange[300],
        padding: defaultPadding8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              bookDetails.author!,
              style: body2Style,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            Spacer(),
            verticalSpacing4,
            Text(
              bookDetails.title!,
              style: heading3Style,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            verticalSpacing4,
            Spacer(),
            FittedBox(
              child: Text(
                "(cover image not available)",
                style: body4Style,
              ),
            )
          ],
        ),
      );
    }
  }
}
