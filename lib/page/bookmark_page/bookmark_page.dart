import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/components/error_state_widget.dart';
import 'package:movie_app/components/grid_list_item.dart';
import 'package:movie_app/components/loading_state_widget.dart';
import 'package:movie_app/page/bookmark_page/bookmark_modal.dart';
import 'package:movie_app/page/bookmark_page/cubit/bookmark_cubit.dart';
import 'package:movie_app/page/detail_page/detail_page_view.dart';
import 'package:movie_app/constants/extentions_import.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (context, state) {
        if (state is BookmarkLoading) {
          return const LoadingStateWidget();
        } else if (state is BookmarkDone) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
            body: Column(
              children: state.bookmarkedList.isEmpty
                  ? [
                      const Expanded(
                          child: Center(
                        child: Text(
                          "Empty",
                        ),
                      ))
                    ]
                  : [
                      Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: context.paddingLow,
                            child: Text(
                              "Total Bookmarks: " + state.bookmarkedList.length.toString(),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          )),
                      Expanded(
                        child: GridView.count(
                          crossAxisSpacing: context.dynamicHeight(0.01),
                          childAspectRatio: 0.7,
                          mainAxisSpacing: context.dynamicHeight(0.01),
                          crossAxisCount: 2,
                          children: List.generate(state.bookmarkedList.length, (index) {
                            BookMarkedMovie movie = state.bookmarkedList[index];
                            return GridListItem(
                                poster: movie.poster ?? "",
                                padding:
                                    index % 2 == 0 ? const EdgeInsets.only(left: 8) : const EdgeInsets.only(right: 8),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => DetailsPage(
                                                imdbID: movie.id ?? "",
                                              )));
                                });
                          }),
                        ),
                      ),
                    ],
            ),
          );
        } else if (state is BookmarkError) {
          return const ErrorStateWidget();
        } else {
          //context.read<BookmarkCubit>().getAll();
          return const SizedBox();
        }
      },
    );
  }
}
