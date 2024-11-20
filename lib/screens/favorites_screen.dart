import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/catalog_service.dart';
import '../providers/api_provider.dart';
import 'book_details_screen.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  late Future<List<Product>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    final catalogService = getIt<CatalogService>();
    _favoritesFuture = catalogService.getFavorites(); // Favorileri API'den alıyoruz
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: FutureBuilder<List<Product>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No favorites found"));
          } else {
            final favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];
                return ListTile(
                  leading: Image.network(
                    product.coverImage,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Favorilerden kaldırma işlemi
                      try {
                        final catalogService = getIt<CatalogService>();
                        await catalogService.removeFromFavorites(1, product.id); // Backend'e istek
                        setState(() {
                          favorites.removeAt(index); // Listeyi güncelle
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${product.name} removed from favorites")),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $error")),
                        );
                      }
                    },
                  ),
                  onTap: () {
                    // Ürün detayına git
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(product: product),
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
