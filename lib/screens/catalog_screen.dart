import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../services/catalog_service.dart';
import '../providers/api_provider.dart';
import 'best_seller_screen.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    final catalogService = getIt<CatalogService>();
    _categoriesFuture = catalogService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Catalog"),
      ),
      body: FutureBuilder<List<Category>>(
  future: _categoriesFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text("No categories found"));
    } else {
      final categories = snapshot.data!;
      return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BestSellerScreen(categoryId: category.id),
                ),
              );
            },
          );
        },
      );
    }
  },
      )
);
}
}