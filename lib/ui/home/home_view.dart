import 'package:epub_reader/core/enum/busy_objects.dart';
import 'package:epub_reader/core/model/book_details_model.dart';
import 'package:epub_reader/ui/shared/styles.dart';
import 'package:epub_reader/ui/shared/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';
import 'widget/book_widget.dart';
import 'widget/delete_dialog_widget.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<AnimatedListState> animatedListkey;
  ScrollController scrollController;

  @override
  void initState() {
    animatedListkey = GlobalKey<AnimatedListState>();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (viewModel) => viewModel.init(),
      builder: (_, viewModel, __) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Text(
                  "EPUB & PDF Reader",
                  style: heading1Style,
                ),
                horizontalSpacing16,
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 100),
                  child: (viewModel.busy(BusyObjects.addBook) || viewModel.busy(BusyObjects.openBook))
                      ? SpinKitWave(
                          color: Colors.deepPurple,
                          size: 15,
                        )
                      : emptySpacing,
                ),
              ],
            ),
            actions: <Widget>[
              Center(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () async {
                    final isBookAdded = await viewModel.pickAndSaveBook();
                    if (isBookAdded) {
                      animatedListkey.currentState.insertItem(viewModel.newlyAddedBookIndex);
                      await Future.delayed(Duration(milliseconds: 300));
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent + 156,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.deepPurple),
                    ),
                    padding: defaultPadding4,
                    child: Icon(
                      Icons.add,
                      color: Colors.deepPurple,
                      size: 20,
                    ),
                  ),
                ),
              ),
              horizontalSpacing16,
              Center(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => viewModel.openEmail(),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.deepPurple),
                    ),
                    alignment: Alignment.center,
                    child: FittedBox(
                      child: Text('?', style: button1Style),
                    ),
                  ),
                ),
              ),
              horizontalSpacing16
            ],
          ),
          body: !viewModel.isBusy
              ? Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width > 600 ? 600 : MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        AnimationLimiter(
                          child: AnimatedList(
                            controller: scrollController,
                            key: animatedListkey,
                            initialItemCount: viewModel.allBooks.length,
                            itemBuilder: (context, index, animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 400),
                                  child: SlideAnimation(
                                    delay: Duration(milliseconds: 100),
                                    child: FadeInAnimation(
                                      delay: Duration(milliseconds: 100),
                                      child: BookWidget(
                                        bookDetails: viewModel.allBooks[index],
                                        onTap: () => viewModel.openBook(viewModel.allBooks[index]),
                                        onDelete: () => deleteBookDialog(context, viewModel, index),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned.fill(
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 100),
                            child: viewModel.allBooks.isEmpty
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Lottie.asset(
                                        'assets/json/searching_book_anim.json',
                                        height: 120,
                                      ),
                                      Text(
                                        'No Books :(',
                                        style: heading2Style,
                                        textAlign: TextAlign.center,
                                      ),
                                      verticalSpacing4,
                                      Text(
                                        'Start adding your favourite books\nby clicking on the + sign. ',
                                        style: body1Style,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )
                                : emptySpacing,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : emptySpacing,
        );
      },
    );
  }

  void deleteBookDialog(BuildContext context, HomeViewModel viewModel, int index) {
    final BookDetails bookDetails = viewModel.allBooks[index];
    showDialog(
      context: context,
      builder: (_) {
        return DeleteDialogWidget(
          bookTitle: bookDetails.title,
          onDeletePressed: () async {
            Navigator.of(context).pop();
            await Future.delayed(Duration(milliseconds: 100));
            await viewModel.deleteBook(bookDetails);
            animatedListkey.currentState.removeItem(
              index,
              (context, animation) => SizeTransition(
                sizeFactor: animation,
                child: AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    delay: Duration(milliseconds: 100),
                    child: FadeInAnimation(
                      delay: Duration(milliseconds: 100),
                      child: BookWidget(
                        bookDetails: bookDetails,
                        onTap: () => viewModel.openBook(bookDetails),
                        onDelete: () => deleteBookDialog(context, viewModel, index),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
