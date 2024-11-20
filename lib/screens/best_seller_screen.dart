import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/catalog_service.dart';
import '../providers/api_provider.dart';
import 'book_details_screen.dart';

class BestSellerScreen extends ConsumerStatefulWidget {
  final int categoryId;

  BestSellerScreen({required this.categoryId});

  @override
  _BestSellerScreenState createState() => _BestSellerScreenState();
}

class _BestSellerScreenState extends ConsumerState<BestSellerScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    final catalogService = getIt<CatalogService>();
    _productsFuture = catalogService.getProductsByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Best Seller"),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
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
                        Image.network(product.coverImage, height: 100),
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
