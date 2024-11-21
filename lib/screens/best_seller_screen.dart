import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalog_search_provider.dart';
import 'book_details_screen.dart';

class BestSellerScreen extends ConsumerWidget {
  final int categoryId;

  BestSellerScreen({required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final filteredProducts = ref.watch(filteredProductsProvider(categoryId));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: "Search products...",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
        ),
      ),
      body: filteredProducts.when(
        data: (products) {
          if (products.isEmpty) {
            return Center(child: Text("No products found"));
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailsScreen(product: product),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      FutureBuilder<String?>(
                        future: product.coverImage,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError || snapshot.data == null) {
                            return Icon(Icons.image_not_supported, size: 100);
                          } else {
                            return Image.network(snapshot.data!, height: 100, fit: BoxFit.cover);
                          }
                        },
                      ),
                      Text(product.name),
                      Text("\$${product.price.toStringAsFixed(2)}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("Error: $error")),
      ),
    );
  }
}
