import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryPostPage extends StatefulWidget {
  final int idCategory;
  final String namaCategory;

  const CategoryPostPage({
    super.key,
    required this.idCategory,
    required this.namaCategory,
  });

  @override
  State<CategoryPostPage> createState() => _CategoryPostPageState();
}

class _CategoryPostPageState extends State<CategoryPostPage> {
  // final String baseUrl = "http://10.0.2.2:3000";
  final String baseUrl = "http://localhost:3000";

  List<dynamic> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPostsByCategory();
  }

  // =========================
  // GET POST BERDASARKAN CATEGORY
  // =========================
  Future<void> getPostsByCategory() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/post"));

      print("POST STATUS : ${response.statusCode}");
      print("POST BODY : ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        final List<dynamic> allPosts = result["data"] ?? [];

        // Filter berdasarkan id_category
        final filteredPosts = allPosts.where((post) {
          return post["id_category"].toString() == widget.idCategory.toString();
        }).toList();

        if (!mounted) return;

        setState(() {
          posts = filteredPosts;
          isLoading = false;
        });
      } else {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("ERROR POST : $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================
  // BUILD IMAGE
  // =========================
  Widget buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: double.infinity,
        height: 180,
        color: const Color(0xFFF3E5D3),
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 50,
            color: Color(0xFF8B3A47),
          ),
        ),
      );
    }

    // Proxy gambar
    final String proxyUrl =
        "https://wsrv.nl/?url=${Uri.encodeComponent(imageUrl)}";

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      child: Image.network(
        proxyUrl,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,

        // =========================
        // LOADING
        // =========================
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return Container(
            width: double.infinity,
            height: 180,
            color: const Color(0xFFF3E5D3),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF6B1F2A)),
            ),
          );
        },

        // =========================
        // ERROR
        // =========================
        errorBuilder: (context, error, stackTrace) {
          print("GAGAL LOAD IMAGE");
          print("IMAGE ASLI : $imageUrl");
          print("IMAGE PROXY : $proxyUrl");
          print("ERROR : $error");

          return Container(
            width: double.infinity,
            height: 180,
            color: const Color(0xFFF3E5D3),
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                size: 50,
                color: Color(0xFF8B3A47),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8ED),

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8ED),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF6B1F2A)),

        title: Text(
          widget.namaCategory,
          style: const TextStyle(
            color: Color(0xFF6B1F2A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // BODY
      // =========================
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6B1F2A)),
            )
          : posts.isEmpty
          ? const Center(
              child: Text(
                "Belum ada artikel di kategori ini",
                style: TextStyle(fontSize: 16, color: Color(0xFF6B6258)),
              ),
            )
          : RefreshIndicator(
              onRefresh: getPostsByCategory,
              color: const Color(0xFF6B1F2A),

              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: posts.length,

                itemBuilder: (context, index) {
                  final post = posts[index];

                  final String title = post["title"]?.toString() ?? "";

                  final String text = post["post_text"]?.toString() ?? "";

                  final String category =
                      post["name_category"]?.toString() ?? widget.namaCategory;

                  final String? image = post["image"]?.toString();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),

                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF8),
                      borderRadius: BorderRadius.circular(18),

                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6B1F2A).withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // =========================
                        // GAMBAR
                        // =========================
                        buildImage(image),

                        // =========================
                        // CONTENT
                        // =========================
                        Padding(
                          padding: const EdgeInsets.all(16),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // CATEGORY
                              Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8B3A47),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // JUDUL
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6B1F2A),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // ISI
                              Text(
                                text,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Color(0xFF3E302C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
