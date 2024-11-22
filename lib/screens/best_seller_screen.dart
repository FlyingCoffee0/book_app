import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalog_search_provider.dart';
import 'book_details_screen.dart';
import '../providers/navigation_provider.dart';
import 'package:easy_localization/easy_localization.dart'; 

class BestSellerScreen extends ConsumerWidget {
  final int categoryId;

  BestSellerScreen({required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final filteredProducts = ref.watch(filteredProductsProvider(categoryId));

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "best_seller".tr(),  
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Search Filter outside of AppBar
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: "search_products".tr(),  
                hintStyle: TextStyle(color: Color(0x66090937)),
                prefixIcon: Icon(Icons.search, color: Color(0x66090937)),
                filled: true,
                fillColor: Color(0xFFF4F4FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Color(0x66090937), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          // Displaying filtered products
          Expanded(
            child: filteredProducts.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(child: Text("no_products_found".tr()));  
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.70,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {                   
                          ref.read(navigationProvider.notifier).push(
                            context,
                            BookDetailsScreen(product: product),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Product image
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  child: FutureBuilder<String?>(
                                    future: product.coverImage,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError || snapshot.data == null) {
                                        return Center(child: Icon(Icons.image_not_supported, size: 100));
                                      } else {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                          child: Image.network(
                                            snapshot.data!,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                // Product Name, Author, and Price
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          product.name,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      // Author 
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          product.author ?? "Unknown", 
                                          style: TextStyle(
                                            fontSize: 8,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left, 
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "\$${product.price.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6251DD),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text("Error: $error")),
            ),
          ),
        ],
      ),
    );
  }
}
