import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/catalog_service.dart';
import '../providers/api_provider.dart';
import 'book_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Product>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    final catalogService = getIt<CatalogService>();
    _favoritesFuture = catalogService.getFavorites();
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
                  leading: FutureBuilder<String?>(
                    future: product.coverImage,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError || snapshot.data == null) {
                        return Icon(Icons.image_not_supported);
                      } else {
                        return Image.network(snapshot.data!, height: 50, width: 50, fit: BoxFit.cover);
                      }
                    },
                  ),
                  title: Text(product.name),
                  subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final catalogService = getIt<CatalogService>();
                      await catalogService.removeFromFavorites(1, product.id);
                      setState(() {
                        favorites.removeAt(index);
                      });
                    },
                  ),
                  onTap: () {
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
