import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> categories = [];
  List<dynamic> posts = [];

  bool isLoading = true;

  final String baseUrl = "http://localhost:3000";
  // final String baseUrl = "http://10.0.2.2:3000";

  @override
  void initState() {
    super.initState();
    getData();
  }

  // =========================
  // GET CATEGORY
  // =========================
  Future<void> getCategory() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/category"));

      print("CATEGORY STATUS : ${response.statusCode}");
      print("CATEGORY BODY   : ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        setState(() {
          categories = result["data"] ?? [];
        });

        print("TOTAL CATEGORY : ${categories.length}");
      } else {
        print("GAGAL GET CATEGORY");
      }
    } catch (e) {
      print("ERROR CATEGORY : $e");
    }
  }

  // =========================
  // GET POST
  // =========================
  Future<void> getPost() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/post"));

      print("POST STATUS : ${response.statusCode}");
      print("POST BODY   : ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        setState(() {
          posts = result["data"] ?? [];
        });

        print("TOTAL POST : ${posts.length}");
      } else {
        print("GAGAL GET POST");
      }
    } catch (e) {
      print("ERROR POST : $e");
    }
  }

  // =========================
  // AMBIL SEMUA DATA
  // =========================
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    await getCategory();
    await getPost();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =========================
      // BACKGROUND CREAM
      // =========================
      backgroundColor: const Color(0xFFFFF8ED),

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8ED),
        elevation: 0,
        centerTitle: true,

        title: const Text(
          "Blogverse",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B1F2A),
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
          : RefreshIndicator(
              onRefresh: getData,

              child: ListView(
                padding: const EdgeInsets.all(18),

                children: [
                  // =========================
                  // CATEGORY
                  // =========================
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B1F2A),
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (categories.isEmpty)
                    const Text(
                      "Category tidak ditemukan",
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    SizedBox(
                      height: 50,

                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,

                        itemBuilder: (context, index) {
                          final category = categories[index];

                          return Container(
                            margin: const EdgeInsets.only(right: 10),

                            child: Chip(
                              backgroundColor: const Color(0xFFFFF1DC),

                              side: const BorderSide(color: Color(0xFF6B1F2A)),

                              label: Text(
                                category["nama_category"]?.toString() ?? "",

                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B1F2A),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 30),

                  // =========================
                  // ALL POSTS
                  // =========================
                  const Text(
                    "All Posts",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B1F2A),
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (posts.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),

                        child: Text(
                          "Belum ada postingan",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...posts.map((post) {
                      // =========================
                      // URL IMAGE
                      // =========================
                      final String imageUrl = post["image"]?.toString() ?? "";

                      // Proxy untuk membantu gambar
                      // dari website luar seperti Pinterest
                      final String imageProxyUrl = imageUrl.isNotEmpty
                          ? "https://wsrv.nl/?url=${Uri.encodeComponent(imageUrl)}"
                          : "";

                      return Card(
                        color: const Color(0xFFFFFDF8),
                        elevation: 1,

                        margin: const EdgeInsets.only(bottom: 16),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(16),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // =========================
                              // IMAGE DARI API
                              // =========================
                              if (imageUrl.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),

                                  child: Image.network(
                                    imageProxyUrl,

                                    width: double.infinity,
                                    height: 200,

                                    fit: BoxFit.cover,

                                    // =========================
                                    // LOADING IMAGE
                                    // =========================
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }

                                          return Container(
                                            width: double.infinity,
                                            height: 200,

                                            color: const Color(0xFFF3E7D3),

                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: Color(0xFF6B1F2A),
                                              ),
                                            ),
                                          );
                                        },

                                    // =========================
                                    // ERROR IMAGE
                                    // =========================
                                    errorBuilder: (context, error, stackTrace) {
                                      print("GAGAL LOAD IMAGE");
                                      print("IMAGE ASLI : $imageUrl");
                                      print("IMAGE PROXY : $imageProxyUrl");
                                      print("ERROR : $error");

                                      return Container(
                                        width: double.infinity,
                                        height: 200,

                                        color: const Color(0xFFF3E7D3),

                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Color(0xFF6B1F2A),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              const SizedBox(height: 12),

                              // =========================
                              // TITLE
                              // =========================
                              Text(
                                post["title"]?.toString() ?? "",

                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6B1F2A),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // =========================
                              // CATEGORY POST
                              // =========================
                              Text(
                                post["name_category"]?.toString() ?? "",

                                style: const TextStyle(
                                  color: Color(0xFF8B3A47),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // =========================
                              // ISI POST
                              // =========================
                              Text(
                                post["post_text"]?.toString() ?? "",

                                maxLines: 4,

                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Color(0xFF3E302C),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // =========================
                              // TANGGAL
                              // =========================
                              if (post["created_at"] != null)
                                Text(
                                  post["created_at"].toString().substring(
                                    0,
                                    10,
                                  ),

                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9A8580),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
