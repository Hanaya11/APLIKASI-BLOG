import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detailcategory.dart';

class JelajahPage extends StatefulWidget {
  const JelajahPage({super.key});

  @override
  State<JelajahPage> createState() => _JelajahPageState();
}

class _JelajahPageState extends State<JelajahPage> {
  final String baseUrl = "http://localhost:3000";
  // final String baseUrl = "http://10.0.2.2:3000";

  List<dynamic> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  Future<void> getCategory() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/category"),
      );

      print("CATEGORY STATUS : ${response.statusCode}");
      print("CATEGORY BODY : ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        setState(() {
          categories = result["data"] ?? [];
          isLoading = false;
        });

        print("TOTAL CATEGORY : ${categories.length}");
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR CATEGORY : $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "kuliner":
        return Icons.restaurant;
      case "travel":
        return Icons.travel_explore;
      case "hiburan":
        return Icons.movie;
      case "style":
        return Icons.checkroom;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8ED),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8ED),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Jelajah",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B1F2A),
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6B1F2A),
              ),
            )
          : categories.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada kategori",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: getCategory,
                  color: const Color(0xFF6B1F2A),

                  child: ListView(
                    padding: const EdgeInsets.all(20),

                    children: [
                      const Text(
                        "Jelajahi berdasarkan kategori",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B1F2A),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Temukan berbagai cerita dan informasi menarik sesuai kategori yang kamu suka.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B6258),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 25),

                      GridView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.2,
                        ),

                        itemCount: categories.length,

                        itemBuilder: (context, index) {
                          final category = categories[index];

                          final String namaCategory =
                              category["nama_category"]
                                      ?.toString() ??
                                  "";

                          // Ambil ID kategori
                          final int? idCategory =
                              int.tryParse(
                            category["id_category"].toString(),
                          );

                          return GestureDetector(
                            onTap: () {
                              // Cek ID kategori
                              if (idCategory == null) {
                                return;
                              }

                              // Pindah ke DetailCategory
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryPostPage(
                                    idCategory: idCategory,
                                    namaCategory: namaCategory,
                                  ),
                                ),
                              );
                            },

                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFFFFDF8),
                                borderRadius:
                                    BorderRadius.circular(20),

                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFF6B1F2A)
                                            .withOpacity(0.08),
                                    blurRadius: 10,
                                    offset:
                                        const Offset(0, 4),
                                  ),
                                ],
                              ),

                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,

                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          const Color(
                                              0xFFF3E5D3),
                                      borderRadius:
                                          BorderRadius.circular(
                                              18),
                                    ),

                                    child: Icon(
                                      getCategoryIcon(
                                          namaCategory),
                                      size: 32,
                                      color:
                                          const Color(
                                              0xFF6B1F2A),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    namaCategory,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.bold,
                                      color:
                                          Color(0xFF6B1F2A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
