import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryBottomSheet extends StatefulWidget {
  final List<String>? categories;
  final String? selectedCategory;
  final Function(String?) onCategorySelected;

  const CategoryBottomSheet({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  String _searchQuery = '';
  late List<String> _filteredCategories;

  @override
  void initState() {
    super.initState();
    _filteredCategories = widget.categories ?? [];
  }

  void _filterCategories(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCategories = widget.categories ?? [];
      } else {
        _filteredCategories = widget.categories!
            .where((category) =>
                category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Helper to make "smart-phones" look like "Smart Phones"
  String _formatCategoryName(String raw) {
    return raw
        .split('-')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen height percentage for the sheet
    final double sheetHeight = MediaQuery.of(context).size.height * 0.75;

    return Container(
      height: sheetHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 1. Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Title
          Text(
            "Select Category",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          // 3. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: _filterCategories,
              decoration: InputDecoration(
                hintText: "Search categories...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          const Divider(height: 1),

          // 4. List Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // "All Categories" Option (Always at top)
                if (_searchQuery.isEmpty) ...[
                  _buildListTile(
                    title: "All Categories",
                    isSelected: widget.selectedCategory == null,
                    onTap: () {
                      widget.onCategorySelected(null);
                      Navigator.pop(context);
                    },
                  ),
                  const Divider(),
                ],

                // Filtered List
                if (_filteredCategories.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(child: Text("No categories found", style: GoogleFonts.poppins(color: Colors.grey))),
                  )
                else
                  ..._filteredCategories.map((category) {
                    final isSelected = widget.selectedCategory == category;
                    return _buildListTile(
                      title: _formatCategoryName(category),
                      isSelected: isSelected,
                      onTap: () {
                        widget.onCategorySelected(category);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: isSelected ? Colors.black.withOpacity(0.05) : Colors.transparent,
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? Colors.black : Colors.grey[800],
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.black, size: 20)
          : null,
    );
  }
}