import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalog_search_provider.dart';
import 'best_seller_screen.dart';
import 'book_details_screen.dart';

class CatalogScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery =
        ref.watch(categorySearchQueryProvider); // Kategori ismi üzerinden arama
    final filteredCategories = ref.watch(filteredCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Catalog",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.shopping_cart, color: Colors.white),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Chips
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: filteredCategories.when(
              data: (categories) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BestSellerScreen(categoryId: category.id),
                            ),
                          );
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFF4F4FF)),
                            borderRadius: BorderRadius.vertical(),
                            color: Color(0xFFF4F4FF),
                          ),
                          child: Text(
                            category.name,
                            style: TextStyle(color: Color(0x66090937)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text("Error: $error")),
            ),
          ),
          // Search Field for category ID's
          Container(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search categories ...",
                hintStyle:
                    TextStyle(color: Color(0x66090937)), 
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Color(0xFFF4F4FF), 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none, 
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                      color: Color(0x66090937),
                      width: 1.5), 
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                      color: Colors.transparent), 
                ),
              ),
              onChanged: (value) {
                ref.read(categorySearchQueryProvider.notifier).state =
                    value; // Search query for categories
              },
            ),
          ),

          // Books Display
          Expanded(
            child: filteredCategories.when(
              data: (categories) {
                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    // If category name doesn't match search query, don't display it
                    if (!category.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase())) {
                      return Container(); // Skip category if it doesn't match search
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category Header with "View All"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BestSellerScreen(
                                          categoryId: category.id),
                                    ),
                                  );
                                },
                                child: Text("View All"),
                              ),
                            ],
                          ),
                          // Books in the Category
                          Consumer(
                            builder: (context, ref, child) {
                              final products = ref
                                  .watch(filteredProductsProvider(category.id));
                              return products.when(
                                data: (products) {
                                  return SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: products.length,
                                      itemBuilder: (context, productIndex) {
                                        final product = products[productIndex];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BookDetailsScreen(
                                                        product: product),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 150, // Consistent card width
                                            margin: EdgeInsets.only(right: 10),
                                            child: Card(
                                              elevation: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FutureBuilder<String?>(
                                                    future: product.coverImage,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return SizedBox(
                                                          height: 100,
                                                          child: Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                        );
                                                      } else if (snapshot
                                                              .hasError ||
                                                          snapshot.data ==
                                                              null) {
                                                        return SizedBox(
                                                          height: 100,
                                                          child: Icon(
                                                              Icons
                                                                  .image_not_supported,
                                                              size: 80),
                                                        );
                                                      } else {
                                                        return Image.network(
                                                          snapshot.data!,
                                                          height: 100,
                                                          width:
                                                              double.infinity,
                                                          fit: BoxFit.cover,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          product.name,
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          "\$${product.price.toStringAsFixed(2)}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey,
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
                                loading: () =>
                                    Center(child: CircularProgressIndicator()),
                                error: (error, stack) =>
                                    Center(child: Text("Error: $error")),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
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
