import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secapps/ProductDetailsPage.dart';

class SearchResultPage extends StatefulWidget {
  final String query;

  const SearchResultPage({required this.query, super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List<QueryDocumentSnapshot> filteredResults = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchProducts();
  }

  void _searchProducts() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('products')
              .where('status', isEqualTo: 'تمت الموافقة')
              .get();

      final queryLower = widget.query.toLowerCase();

      final results =
          snapshot.docs.where((doc) {
            final data = doc.data();
            final mainCategory =
                (data['mainCategory'] ?? '').toString().toLowerCase();
            final description =
                (data['description'] ?? '').toString().toLowerCase();

            return mainCategory.contains(queryLower) ||
                description.contains(queryLower);
          }).toList();

      setState(() {
        filteredResults = results;
        isLoading = false;
      });
    } catch (e) {
      print('خطأ في البحث: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("نتائج البحث: ${widget.query}")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredResults.isEmpty
              ? const Center(child: Text("لا توجد نتائج مطابقة"))
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredResults.length,
                  itemBuilder: (context, index) {
                    final productSnapshot = filteredResults[index];
                    final product =
                        productSnapshot.data() as Map<String, dynamic>;

                    final imageUrl =
                        (product['images'] != null &&
                                product['images'].isNotEmpty)
                            ? product['images'][0]
                            : 'https://via.placeholder.com/150';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ProductDetailsPage(
                                  product: productSnapshot,
                                ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'] ?? 'بدون اسم',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "السعر: ${product['price'] ?? 'غير محدد'} JD",
                                  ),
                                  Text(
                                    "اللون: ${product['color'] ?? 'غير محدد'}",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
