import 'package:flutter/material.dart';
import 'package:movie_app/components/circular_textfield.dart';
import 'package:movie_app/components/error_state_widget.dart';
import 'package:movie_app/components/grid_list_item.dart';
import 'package:movie_app/components/loading_state_widget.dart';
import 'package:movie_app/components/sliver_null_widget.dart';
import 'package:movie_app/constants/extentions_import.dart';
import 'package:movie_app/page/bookmark_page/bookmark_page.dart';
import 'package:movie_app/page/detail_page/detail_page_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/page/search_page/cubit/search_cubit.dart';
import 'package:movie_app/page/search_page/cubit/search_state.dart';
import 'modal.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> movieType = ["movie", "series", "episode"];
  String lastMovie = "";
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (BuildContext context, SearchState state) {
        return Scaffold(
          //appBar: _appBar(context, state),
          //body: _body(state, context),
          body: CustomScrollView(
            physics: state is SearchDone ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
            slivers: <Widget>[
              _sliverAppBar(state, context),
              _resultListView(context, state),
              _pagination(context, state),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _sliverAppBar(SearchState state, BuildContext context) {
    return SliverAppBar(
        //backgroundColor: Colors.black,
        expandedHeight: state is SearchDone || context.watch<SearchCubit>().firstSearch
            ? context.dynamicHeight(0.22)
            : context.dynamicHeight(1),
        flexibleSpace: FlexibleSpaceBar(
          background: _appBar(context, state),
        ));
  }

  Column _appBar(BuildContext context, SearchState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: context.dynamicHeight(0.02),
        ),
        _titleBar(context),
        SizedBox(
          width: context.dynamicWidth(1),
          child: Row(
            children: [
              SizedBox(
                  width: state is SearchDone || context.watch<SearchCubit>().firstSearch
                      ? context.dynamicWidth(0.85)
                      : context.dynamicWidth(1),
                  child: _searchBar(context)),
              state is SearchDone || context.watch<SearchCubit>().firstSearch
                  ? _bookmark(context, state)
                  : const SizedBox(),
            ],
          ),
        ),
        state is! SearchDone && !context.watch<SearchCubit>().firstSearch
            ? _bookmark(context, state)
            : const SizedBox(),
        state is SearchDone
            ? SizedBox(
                height: context.dynamicHeight(0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_filterButton(context), _totalResults(context, state.searchMovie)],
                ),
              )
            : SizedBox(width: 0, height: context.dynamicHeight(0.06)),
      ],
    );
  }

  Padding _titleBar(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: Text(
        "OMDB",
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }

  Padding _searchBar(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: CircularTextField(
        prefixIcon: Icons.search_rounded,
        hintText: "Search",
        onSubmitted: (String value) {
          page = 1;
          if (lastMovie != value && value.trim().isNotEmpty) {
            context.read<SearchCubit>().getMovies(value.trim());
            lastMovie = value.trim();
          } else if (lastMovie == value) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Same Movie")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong!")));
          }
        },
      ),
    );
  }

  InkWell _bookmark(BuildContext context, SearchState state) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookmarkPage()));
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.bookmarks,
              ),
              state is SearchDone || context.watch<SearchCubit>().firstSearch
                  ? const SizedBox()
                  : const SizedBox(
                      width: 8,
                    ),
              state is SearchDone || context.watch<SearchCubit>().firstSearch
                  ? const SizedBox()
                  : const Text(
                      "Bookmarks",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Row _filterButton(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          icon: const Icon(Icons.filter_list),
          label: const Text("Filter"),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (ctxt, setState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                                value: context.watch<SearchCubit>().checkboxFirst,
                                onChanged: (bool? value) {
                                  context.read<SearchCubit>().changeFirstCb(value!);
                                  setState(() {});
                                }),
                            const Text("Year: "),
                            DropdownButton<int>(
                                value: context.watch<SearchCubit>().year,
                                items: List.generate(
                                  100,
                                  (index) => DropdownMenuItem(
                                      value: DateTime.now().year - index,
                                      child: Text((DateTime.now().year - index).toString())),
                                ),
                                onTap: () {},
                                onChanged: (int? value) {
                                  context.read<SearchCubit>().changeYear(value!);
                                  setState(() {});
                                })
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                                value: context.watch<SearchCubit>().checkboxSecond,
                                onChanged: (bool? value) {
                                  context.read<SearchCubit>().changeSecondCb(value!);
                                  setState(() {});
                                }),
                            const Text("Type: "),
                            DropdownButton<String>(
                                value: context.watch<SearchCubit>().type,
                                items: movieType
                                    .map((e) => DropdownMenuItem(value: e, child: Text(e.capitalize())))
                                    .toList(),
                                onChanged: (String? value) {
                                  context.read<SearchCubit>().changeType(value!);
                                  setState(() {});
                                })
                          ],
                        ),
                        TextButton(
                            onPressed: (context.read<SearchCubit>().checkboxFirst ||
                                    context.read<SearchCubit>().checkboxSecond)
                                ? () {
                                    context.read<SearchCubit>().getMoviesWithFilter(lastMovie);
                                  }
                                : null,
                            child: const Text("Filter"))
                      ],
                    );
                  });
                });
          },
        ),
        context.watch<SearchCubit>().isFilter ? Text(context.read<SearchCubit>().getFilterInfo()) : const SizedBox(),
        context.watch<SearchCubit>().isFilter
            ? IconButton(
                onPressed: () {
                  context.read<SearchCubit>().getMovies(lastMovie);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close))
            : const SizedBox()
      ],
    );
  }

  Align _totalResults(BuildContext context, SearchMovie searchMovie) {
    return Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: context.paddingLow,
          child: Text(
            "Total Results: " + searchMovie.totalResults.toString(),
            style: Theme.of(context).textTheme.caption,
          ),
        ));
  }

  Widget _resultListView(BuildContext context, SearchState state) {
    if (state is SearchLoading) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: context.dynamicHeight(0.72),
          child: const LoadingStateWidget(),
        ),
      );
    } else if (state is SearchError) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: context.dynamicHeight(0.72),
          child: const ErrorStateWidget(),
        ),
      );
    } else if (state is SearchDone) {
      return _searchDoneWidget(context, state.searchMovie);
    } else {
      return const SliverNullWidget();
    }
  }

  Widget _searchDoneWidget(BuildContext context, SearchMovie searchMovie) {
    return SliverGrid.count(
      //shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      //padding: context.paddingLow,
      crossAxisSpacing: context.dynamicHeight(0.01),
      childAspectRatio: 0.7,
      mainAxisSpacing: context.dynamicHeight(0.01),
      crossAxisCount: 2,
      children: searchMovie.search!.isEmpty
          ? [const SizedBox.expand()]
          : List.generate(searchMovie.search!.length, (index) {
              final Search movie = searchMovie.search![index];
              return GridListItem(
                poster: movie.poster,
                padding: index % 2 == 0 ? const EdgeInsets.only(left: 8) : const EdgeInsets.only(right: 8),
                onTap: () {
                  if (movieType.contains(movie.type.toLowerCase().trim())) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => DetailsPage(
                                  imdbID: movie.imdbID,
                                )));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("It's ${movie.type}. I'm sorry :(")));
                  }
                },
              );
            }),
    );
  }

  Widget _pagination(BuildContext context, SearchState state) {
    if (state is SearchDone) {
      if (int.parse(state.searchMovie.totalResults!) > 10) {
        return SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    if (page > 1) {
                      page--;
                      context.read<SearchCubit>().nextPage(lastMovie, page);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: page > 1 ? Colors.white60 : Colors.white24,
                    size: page > 1 ? 30 : 24,
                  )),
              Text(
                page.toString(),
                style: const TextStyle(fontSize: 24),
              ),
              IconButton(
                  onPressed: () {
                    if (int.parse(state.searchMovie.totalResults!) - (page * 10) > 0) {
                      page++;
                      context.read<SearchCubit>().nextPage(lastMovie, page);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color:
                        int.parse(state.searchMovie.totalResults!) - (page * 10) > 0 ? Colors.white60 : Colors.white24,
                    size: int.parse(state.searchMovie.totalResults!) - (page * 10) > 0 ? 30 : 24,
                  )),
            ],
          ),
        );
      } else {
        return const SliverNullWidget();
      }
    } else {
      return const SliverNullWidget();
    }
  }
}
