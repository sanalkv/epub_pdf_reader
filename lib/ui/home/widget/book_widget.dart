import 'package:epub_reader/ui/shared/styles.dart';
import 'package:epub_reader/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import '../../../../core/model/book_details_model.dart';
import 'book_cover_widget.dart';

class BookWidget extends StatelessWidget {
  final BookDetails bookDetails;
  final Function() onTap;
  final Function onDelete;

  const BookWidget({
    @required this.bookDetails,
    @required this.onTap,
    @required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.grey[300],
            offset: Offset(3, 0),
          )
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Ink(
            height: 140,
            padding: defaultPadding16,
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 140,
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.grey[300],
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: BookCoverWidget(
                    bookDetails: bookDetails,
                  ),
                ),
                horizontalSpacing16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookDetails.title,
                        style: heading4Style,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      verticalSpacing4,
                      Text(
                        bookDetails.author,
                        style: body3Style,
                      ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: bookDetails.lastReadPosition == null
                                ? Icon(
                                    Icons.fiber_new_outlined,
                                    color: Colors.deepPurple,
                                  )
                                : emptySpacing
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.deepPurple),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: onDelete,
                              child: Padding(
                                padding:defaultPadding4,
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.deepPurple,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
