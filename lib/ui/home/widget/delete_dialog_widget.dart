import 'package:epub_reader/ui/shared/styles.dart';
import 'package:epub_reader/ui/shared/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DeleteDialogWidget extends StatelessWidget {
  final Function() onDeletePressed;
  final String bookTitle;
  const DeleteDialogWidget({
    Key key,
    this.onDeletePressed,
    this.bookTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding:horizontalPadding16,
        child: SizedBox(
          width: MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalSpacing8,
              Lottie.asset(
                'assets/json/trash_can_anim.json',
                height: 60,
              ),
              verticalSpacing16,
              Text(
                'Are you sure you want to delete \'$bookTitle\' ?',
                style: heading5Style,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              verticalSpacing16,
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(primary: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: button2Style,
                      ),
                    ),
                  ),
                  horizontalSpacing16,
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: onDeletePressed,
                      child: Text('Delete'),
                    ),
                  ),
                ],
              ),
              verticalSpacing8
            ],
          ),
        ),
      ),
    );
  }
}
