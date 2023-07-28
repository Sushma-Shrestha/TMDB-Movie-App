import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/core/core.dart';
import 'package:movie_app/features/auth/auth.dart';
import 'package:movie_app/features/movies/movies.dart';
import 'package:movie_app/features/movies/presentation/widgets/movies_searc_result.dart';

class LatestMoviesPage extends ConsumerStatefulWidget {
  const LatestMoviesPage({super.key});
  @override
  ConsumerState<LatestMoviesPage> createState() => _LatestMoviesPageState();
}

class _LatestMoviesPageState extends ConsumerState<LatestMoviesPage> {
  late final TextEditingController _searchController;
  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    var searchon = false;
    final scrollControllerProvider = ref.watch(moviesScrollControllerProvider);
    final isDarkTheme = ref.watch(themeProvider).isDarkTheme;
    final user = ref.watch(authStatusProvider).user;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        // ignore: avoid_bool_literals_in_conditional_expressions
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            children: [
              if (searchon == true || _searchController.text.isNotEmpty)
                IconButton(
                  onPressed: () {
                    setState(() {
                      searchon = false;
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                    });
                    ref.read(latestMoviesController.notifier).fetchSearchMovies(
                          forceRefresh: true,
                          page: 1,
                          query: '',
                        );

                    ref
                        .watch(latestMoviesController.notifier)
                        .fetchLatestMovies(
                          forceRefresh: true,
                          page: 1,
                        );
                  },
                  icon: const Icon(Icons.arrow_back),
                )
              else
                Container(),
              GestureDetector(
                onTap: () => scrollControllerProvider.animateTo(
                  scrollControllerProvider.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
                child: Image.asset(
                  AppAssets.appLogo,
                  height: 100,
                  width: 100,
                ),
              ),
            ],
          ),
        ),
        leadingWidth: 180,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://ui-avatars.com/api/?name=${user?.email}&size=256',
                  ),
                ),
                onPressed: () => displayEndDrawer(context),
              );
            },
          ),
        ],
        bottom: AppBar(
          // search bar
          automaticallyImplyLeading: false,
          title: CustomTextField(
            controller: _searchController,
            hintText: 'Search Movies',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(latestMoviesController.notifier).fetchSearchMovies(
                      forceRefresh: true,
                      page: 1,
                      query: _searchController.text,
                    );

                setState(() {
                  searchon = true;
                  FocusScope.of(context).unfocus();
                });
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: user != null
            ? ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://ui-avatars.com/api/?name=${user.email}&size=256',
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite),
                    title: const Text('Favorites'),
                    onTap: () {
                      context.pushNamed(RoutePaths.favRoute.routeName);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      final confirm =
                          await LogoutAlertDialogue.showAlert(context) ?? false;
                      if (confirm) {
                        await ref
                            .read(loginControllerProvider.notifier)
                            .logout();
                      }
                    },
                    // context.go(RoutePaths.loginRoute.path);
                  ),
                  const Divider(),
                  const ListTile(
                    title: Text('Switch Mode'),
                  ),
                  Switch.adaptive(
                    value: isDarkTheme,
                    onChanged: (isDarkModeEnabled) {
                      ref.read(themeProvider.notifier).updateCurrentThemeMode(
                            isDarkModeEnabled
                                ? ThemeMode.dark
                                : ThemeMode.light,
                          );
                    },
                  ),
                ],
              )
            : Center(
                child: IconButton(
                  onPressed: () => context.go(RoutePaths.loginRoute.path),
                  icon: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.login),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Login'),
                    ],
                  ),
                ),
              ),
      ),
      body: _searchController.text.isNotEmpty || _searchController.text != ''
          ? SearchMoviesGridView(query: _searchController.text)
          : const LatestMoviesGridView(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
