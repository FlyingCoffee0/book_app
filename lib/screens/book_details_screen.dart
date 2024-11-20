import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/catalog_service.dart';
import '../providers/api_provider.dart';

class BookDetailsScreen extends ConsumerStatefulWidget {
  final Product product;

  BookDetailsScreen({required this.product});

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final catalogService = getIt<CatalogService>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Book Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.product.coverImage,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "\$${widget.product.price.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 20),
            Text(
              "Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "This is a placeholder summary for the book '${widget.product.name}'. Replace this with the actual summary when available.",
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () async {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    try {
                      if (isFavorite) {
                        await catalogService.addToFavorites(1, widget.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added to favorites!")),
                        );
                      } else {
                        await catalogService.removeFromFavorites(1, widget.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Removed from favorites!")),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Purchase functionality coming soon!")),
                    );
                  },
                  child: Text("Buy Now"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
