import 'package:flutter/material.dart';

class CategoryBottomSheet extends StatelessWidget {
  final List<String> categories;
  final Function(String?) onCategorySelected;

  const CategoryBottomSheet({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: 400,
      child: Column(
        children: [
          const Text(
            "Select Category",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length + 1, // +1 for "All"
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    title: const Text("All Categories"),
                    onTap: () {
                      onCategorySelected(null); // Null = All
                      Navigator.pop(context);
                    },
                  );
                }
                final category = categories[index - 1];
                return ListTile(
                  title: Text(category.toUpperCase()), // Capitalize for UI
                  onTap: () {
                    onCategorySelected(category);
                    Navigator.pop(context);
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