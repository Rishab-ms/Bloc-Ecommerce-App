import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../search/view/product_search_delegate.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/product_list_item.dart';
import '../widgets/category_bottom_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create the Bloc and immediately trigger the "Started" event to fetch data.
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(HomeStarted()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Pagination Logic: Listen to scroll events
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      // Trigger LoadMore when we reach the bottom
      context.read<HomeBloc>().add(HomeLoadMore());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger when we are at 90% of the scroll to make it feel seamless
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Shopeasy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. Search Bar & Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search for products...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  readOnly: true,
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: ProductSearchDelegate(),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Filter Button with Active State indication
                BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current) =>
                      previous.selectedCategory != current.selectedCategory ||
                      previous.categories != current.categories,
                  builder: (context, state) {
                    final isFiltered = state.selectedCategory != null;
                    return Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Show the Bottom Sheet defined in Step 4
                          final currentState = context.read<HomeBloc>().state;

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled:
                                true, // <--- IMPORTANT: Allows the sheet to be taller
                            backgroundColor: Colors
                                .transparent, // Let the widget handle the radius
                            builder: (_) => CategoryBottomSheet(
                              categories: currentState.categories,
                              selectedCategory: currentState
                                  .selectedCategory, // Pass current selection
                              onCategorySelected: (category) {
                                context.read<HomeBloc>().add(
                                  HomeCategoryChanged(category),
                                );
                              },
                            ),
                          );
                        },
                        icon: Icon(
                          isFiltered
                              ? Icons.filter_alt
                              : Icons.filter_alt_outlined,
                          color: isFiltered ? Colors.blue : Colors.black,
                        ),
                        label: Text(
                          state.selectedCategory ?? "Category",
                          style: TextStyle(
                            color: isFiltered ? Colors.blue : Colors.black,
                            fontWeight: isFiltered
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isFiltered
                                ? Colors.blue
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // 2. Product List
          Expanded(
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state.status == HomeStatus.failure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                }
              },
              builder: (context, state) {
                if (state.status == HomeStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.products.isEmpty &&
                    state.status == HomeStatus.success) {
                  return const Center(child: Text("No products found"));
                }

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.hasReachedMax
                      ? state.products.length
                      : state.products.length + 1, // +1 for the bottom spinner
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index >= state.products.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final product = state.products[index];
                    return ProductListItem(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
