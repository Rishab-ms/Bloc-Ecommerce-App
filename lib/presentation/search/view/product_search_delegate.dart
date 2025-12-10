import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../data/models/product_model.dart';
import '../../home/widgets/product_list_item.dart';
import '../cubit/search_cubit.dart';

class ProductSearchDelegate extends SearchDelegate {
  
  // Design Decision:
  // We use the BlocProvider HERE inside the delegate.
  // This creates a fresh Cubit every time we open search.
  final SearchCubit searchCubit = sl<SearchCubit>();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          // Reset search state
          searchCubit.search(''); 
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  // This is shown when the user hits "Enter"
  @override
  Widget buildResults(BuildContext context) {
    // Trigger the search
    searchCubit.search(query);

    return BlocProvider.value(
      value: searchCubit,
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchSuccess) {
            if (state.products.isEmpty) {
              return const Center(child: Text("No products found"));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                 // Reuse our nice list item widget!
                return ProductListItem(product: state.products[index]);
              },
            );
          } else if (state is SearchError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }

  // This is shown while typing (Auto-suggest)
  // For this showcase, we will behave same as buildResults, 
  // but you could debouce this to save API calls.
  @override
  Widget buildSuggestions(BuildContext context) {
    // Optional: Only search if query length > 2
    if (query.length > 2) {
        searchCubit.search(query);
    }

    return BlocProvider.value(
      value: searchCubit,
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
            // Same UI as above, or a simplified list of titles
             if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchSuccess) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                    title: Text(product.title),
                    onTap: () {
                        query = product.title;
                        showResults(context);
                    },
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}