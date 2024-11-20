import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalog_provider.dart';
import 'best_seller_screen.dart';

class CatalogScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogService = ref.read(catalogServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Catalog"),
      ),
      body: FutureBuilder(
        future: catalogService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text("No categories found"));
          } else {
            final categories = snapshot.data as List;
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
      ),
    );
  }
}
