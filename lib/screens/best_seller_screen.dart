import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../providers/providers.dart';
import 'book_details_screen.dart';

class BestSellerScreen extends ConsumerWidget {
  final int categoryId;

  BestSellerScreen({required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogService = ref.read(catalogServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Best Seller"),
      ),
      body: FutureBuilder<List<Product>>(
        future: catalogService.getProductsByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No products found"));
          } else {
            final products = snapshot.data!;
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
          }
        },
      ),
    );
  }
}
