import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piton_books/providers/providers.dart';
import 'package:piton_books/screens/login_screen.dart';
import '../providers/catalog_search_provider.dart';
import 'best_seller_screen.dart';
import 'book_details_screen.dart';
import '../providers/navigation_provider.dart';
import 'package:easy_localization/easy_localization.dart';


class CatalogScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(categorySearchQueryProvider);
    final filteredCategories = ref.watch(filteredCategoriesProvider);
    final navigationNotifier = ref.read(navigationProvider.notifier);
    final authService = ref.read(authServiceProvider);  

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 40,
              height: 40,
            ),
            Text(
              "catalog".tr(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                // Language Change Button
                IconButton(
                  icon: Icon(Icons.language),
                  onPressed: () {
                    context.locale = context.locale == Locale('en') ? Locale('tr') : Locale('en');
                  },
                ),
                // Logout Button
                IconButton(
                  icon: Icon(Icons.exit_to_app),  
                  onPressed: () async {
                    await authService.logout(); 
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Logged out successfully"))
                    );
                    navigationNotifier.pushReplacement(context, LoginScreen()); 
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: filteredCategories.when(
              data: (categories) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          navigationNotifier.push(
                            context,
                            BestSellerScreen(categoryId: category.id),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              autofocus: false,
              decoration: InputDecoration(
                hintText: "search_categories".tr(),
                hintStyle: TextStyle(color: Color(0x66090937)),
                prefixIcon: Icon(Icons.search),
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
              onChanged: (value) {
                ref.read(categorySearchQueryProvider.notifier).state = value;
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

                    if (!category.name.toLowerCase().contains(searchQuery.toLowerCase())) {
                      return Container();
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                category.name,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  navigationNotifier.push(
                                    context,
                                    BestSellerScreen(categoryId: category.id),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFFEF6B4A),
                                ),
                                child: Text("view_all".tr()),
                              ),
                            ],
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              final products = ref.watch(filteredProductsProvider(category.id));
                              return products.when(
                                data: (products) {
                                  return SizedBox(
                                    height: 160,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: products.length,
                                      itemBuilder: (context, productIndex) {
                                        final product = products[productIndex];
                                        return GestureDetector(
                                          onTap: () {
                                            navigationNotifier.push(
                                              context,
                                              BookDetailsScreen(product: product),
                                            );
                                          },
                                          child: Container(
                                            width: 220,
                                            margin: EdgeInsets.only(right: 10),
                                            child: Card(
                                              elevation: 3,
                                              child: Row(
                                                children: [
                                                  // Image loaded using FutureBuilder
                                                  FutureBuilder<String?>( 
                                                    future: product.coverImage, 
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return SizedBox(
                                                          height: 150,
                                                          width: 100,
                                                          child: Center(child: CircularProgressIndicator()),
                                                        );
                                                      } else if (snapshot.hasError || snapshot.data == null) {
                                                        return SizedBox(
                                                          height: 150,
                                                          width: 100,
                                                          child: Icon(Icons.image_not_supported, size: 80),
                                                        );
                                                      } else {
                                                        return Image.network(
                                                          snapshot.data!,
                                                          height: 140,
                                                          width: 100,
                                                          fit: BoxFit.cover,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: 60,
                                                          child: Text(
                                                            product.name,
                                                            style: TextStyle(fontSize: 12),
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 5,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        SizedBox(
                                                          width: 60,
                                                          child: Text(
                                                            product.author ?? "Unknown",
                                                            style: TextStyle(fontSize: 8, color: Color(0xA6090937)),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        Align(
                                                          alignment: Alignment.bottomCenter,
                                                          child: Text(
                                                            "\$${product.price.toStringAsFixed(2)}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Color(0xFF6251DD),
                                                              fontWeight: FontWeight.bold,
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
