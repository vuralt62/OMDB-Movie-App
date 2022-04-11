import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/components/error_state_widget.dart';
import 'package:movie_app/components/loading_state_widget.dart';
import 'package:movie_app/components/sliver_null_widget.dart';
import 'package:movie_app/constants/extentions_import.dart';
import 'package:movie_app/page/detail_page/cubit/detail_cubit.dart';
import 'package:movie_app/page/detail_page/cubit/detail_state.dart';
import 'package:movie_app/page/detail_page/modal.dart';
import 'package:movie_app/page/bookmark_page/bookmark_modal.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({Key? key, required this.imdbID}) : super(key: key);
  final String imdbID;
  final List<String> blockedTitles = [
    "poster",
    "imdbid",
    "response",
    "imdbrating",
    "metascore",
    "ratings",
    "imdbvotes",
    "rated",
    "year"
  ];
  final List<String> blockedContent = ["null", "n/a"];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailCubit, DetailState>(
      builder: (BuildContext context, DetailState? state) {
        if (state is DetailLoading) {
          return const Expanded(child: LoadingStateWidget());
        } else if (state is DetailDone) {
          if (imdbID != state.movieDetails.imdbID) {
            context.read<DetailCubit>().getMovieDetials(imdbID);
            return const LoadingStateWidget();
          } else {
            return _detailDoneWidget(context, state.movieDetails);
          }
        } else if (state is DetailError) {
          return SizedBox(height: context.dynamicHeight(1), child: const ErrorStateWidget());
        } else if (state is DetailInitial) {
          context.read<DetailCubit>().getMovieDetials(imdbID);
          return const SizedBox();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Scaffold _detailDoneWidget(BuildContext context, MovieDetails movieDetails) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _sliverAppBar(context, movieDetails),
            movieDetails.ratings!.isNotEmpty ? _sliverMenuTitle(context, "Ratings") : const SliverNullWidget(),
            movieDetails.ratings!.isNotEmpty ? _sliverRatings(context, movieDetails) : const SliverNullWidget(),
            _movieInfoList(movieDetails),
          ],
        ),
      ),
    );
  }

  SliverAppBar _sliverAppBar(BuildContext context, MovieDetails movieDetails) {
    return SliverAppBar(
      expandedHeight: context.dynamicHeight(0.5),
      //pinned: true,
      floating: true,
      snap: true,
      leading: _backButton(context),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: _title(context, movieDetails),
        background: _backGround(movieDetails),
      ),
      actions: [_bookMark(context, movieDetails)],
    );
  }

  IconButton _bookMark(BuildContext context, MovieDetails movieDetails) {
    return IconButton(
        onPressed: () {
          context.read<DetailCubit>().clickBookMark(BookMarkedMovie(
              id: movieDetails.imdbID,
              title: movieDetails.title,
              year: movieDetails.year,
              poster: movieDetails.poster));
        },
        icon: Icon(
          context.watch<DetailCubit>().isBookmarked != true ? Icons.bookmark_border_rounded : Icons.bookmark_rounded,
        ));
  }

  Stack _backGround(MovieDetails movieDetails) {
    return Stack(
      children: [
        Image.network(
          "${movieDetails.poster}",
          fit: BoxFit.fitWidth,
          width: double.infinity,
          errorBuilder: (context, object, stackTrace) => const SizedBox(
            width: 0,
            height: 0,
          ),
        ),
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black, Colors.black.withOpacity(0.5), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter)),
        ),
      ],
    );
  }

  Padding _title(BuildContext context, MovieDetails movieDetails) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.03)),
      child: Text(
        "${movieDetails.title} (${movieDetails.year})",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  IconButton _backButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
        ));
  }

  SliverToBoxAdapter _sliverMenuTitle(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: context.dynamicWidth(0.03), top: context.dynamicWidth(0.03)),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }

  SliverToBoxAdapter _sliverRatings(BuildContext context, MovieDetails movieDetails) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: context.dynamicHeight(0.15),
        child: ListView.separated(
          itemCount: movieDetails.ratings!.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            Ratings ratings = movieDetails.ratings![index];
            return Container(
              padding: context.paddingNormal,
              width: context.dynamicWidth(0.3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      ratings.value.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        ratings.source.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const VerticalDivider(
              color: Colors.grey,
            );
          },
        ),
      ),
    );
  }

  SliverList _movieInfoList(MovieDetails movieDetails) {
    return SliverList(
        delegate: SliverChildListDelegate(movieDetails.toJson().entries.map((e) {
      if (blockedTitles.contains(e.key.toLowerCase().trim()) ||
          blockedContent.contains(e.value.toString().trim().toLowerCase())) {
        return const SizedBox(
          width: 0,
          height: 0,
        );
      } else {
        return ListTile(
          title: Text(e.key.capitalize()),
          subtitle: Text(e.value.toString().capitalize()),
        );
      }
    }).toList()));
  }
}
