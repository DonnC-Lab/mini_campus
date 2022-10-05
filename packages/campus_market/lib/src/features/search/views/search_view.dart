import 'package:campus_market/src/models/ad_service.dart';
import 'package:campus_market/src/services/market_rtdb_service.dart';
import 'package:campus_market/src/widgets/custom_home_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final FloatingSearchBarController searchBarController =
      FloatingSearchBarController();

  List<AdService> _ads = [];

  List<AdService> _filtered = [];

  bool isLoading = false;

  Future<void> fetchAllAds() async {
    setState(() {
      isLoading = true;
    });

    final res = await ref.read(marketDbProvider).getAllAdService();

    setState(() {
      _ads = res;
      isLoading = false;
    });
  }

  void searchAds(String query) {
    final matches = <AdService>[];

    matches.addAll(_ads);

    matches
        .retainWhere((s) => s.name.toLowerCase().contains(query.toLowerCase()));

    setState(() {
      _filtered = matches;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllAds();
  }

  @override
  Widget build(BuildContext context) {
    final _style = Theme.of(context).textTheme.subtitle2?.copyWith(
          fontSize: 12,
          color: AppColors.kGreyShadeColor,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        );

    return Scaffold(
      body: isLoading
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.15,
                  horizontal: 20,
                ),
                child: Column(
                  children: const [
                    CircularProgressIndicator.adaptive(),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('setting things up..'),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: FloatingSearchAppBar(
                alwaysOpened: true,
                controller: searchBarController,
                automaticallyImplyBackButton: false,
                automaticallyImplyDrawerHamburger: false,
                hint: 'search ads..',
                transitionCurve: Curves.easeInOutCubic,
                actions: [
                  FloatingSearchBarAction.icon(
                    icon: const Icon(
                      Ionicons.close_outline,
                      color: AppColors.kGreyShadeColor,
                    ),
                    showIfOpened: true,
                    onTap: () {
                      searchBarController.clear();
                      searchBarController.close();
                    },
                  ),
                  // FloatingSearchBarAction.icon(
                  //   icon: const Icon(Ionicons.funnel_outline,
                  //       color: AppColors.appGreyShadeColor),
                  //   showIfOpened: true,
                  //   onTap: () {},
                  // ),
                ],
                onQueryChanged: searchAds,
                onSubmitted: searchAds,
                body: _filtered.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.15,
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3),
                                child: Text(
                                  'no results found',
                                  style: _style,
                                ),
                              ),
                              TextButton(
                                onPressed: fetchAllAds,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        mainAxisSpacing: 35,
                        crossAxisSpacing: 20,
                        padding: const EdgeInsets.all(16),
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          final ad = _filtered[index];

                          return CustomHomeCard(ad: ad, isEven: index.isEven);
                        },
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.count(1, index.isEven ? 1.4 : 1.5),
                      ),
              ),
            ),
    );
  }
}
