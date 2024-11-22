import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../providers/catalog_provider.dart';
import 'package:easy_localization/easy_localization.dart';

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
    final catalogService = ref.read(catalogServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text("book_details".tr()),  
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundColor: Color(0xFFF4F4FF),
                radius: 25,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Color(0xFF6251DD),
                    size: 30,
                  ),
                  onPressed: () async {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                    try {
                      if (isFavorite) {
                        await catalogService.addToFavorites(
                            1, widget.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("added_to_favorites".tr())),  
                        );
                      } else {
                        await catalogService.removeFromFavorites(
                            1, widget.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("removed_from_favorites".tr())),  
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("error: $e".tr())),  
                      );
                    }
                  },
                ),
              ),
            ),
            // Kapak görselini dinamik olarak yükleme
            Center(
              child: FutureBuilder<String?>(
                future: widget.product.coverImage, 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return Icon(Icons.image_not_supported, size: 200);
                  } else {
                    return Image.network(
                      snapshot.data!,
                      height: 250,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            // Ürün ismi
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.product.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            // Yazar bilgisi
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.product.author ?? "Unknown", 
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xA6090937),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            // Özet Başlığı
            Text(
              "summary".tr(),  
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Ürün açıklaması
            FutureBuilder<String?>(
              future: Future.value(widget.product.description), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return Text(
                    "summary_not_available".tr(),  
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xA6090937),
                    ),
                  );
                } else {
                  return Text(
                    snapshot.data!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xA6090937),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 30),
            // Satın alma butonu
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Color(0xFFFF7A59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("purchase_functionality_coming_soon".tr())),  
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "\$${widget.product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      "buy_now".tr(),  
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
