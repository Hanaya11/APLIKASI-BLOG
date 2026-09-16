import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SavePage extends StatefulWidget {
  const SavePage({super.key});

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  // final String baseUrl = "http://10.0.2.2:3000";
  final String baseUrl = "http://localhost:3000";

  List<dynamic> posts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  // =========================
  // GET SEMUA POST
  // =========================

  Future<void> getPosts() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/post"));

      print("SAVE STATUS : ${response.statusCode}");
      print("SAVE RESPONSE : ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        setState(() {
          posts = result["data"] ?? [];
          isLoading = false;
        });

        print("TOTAL SAVED POST : ${posts.length}");
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print("ERROR SAVE : $error");

      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================
  // DELETE POST
  // =========================

  Future<void> deletePost(int idPost) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/api/post/$idPost"),
      );

      print("DELETE STATUS : ${response.statusCode}");
      print("DELETE RESPONSE : ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          posts.removeWhere(
            (post) => int.tryParse(post["id_post"].toString()) == idPost,
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Artikel berhasil dihapus"),
            backgroundColor: Color(0xFF6B1F2A),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menghapus artikel"),
            backgroundColor: Color(0xFF8B3A47),
          ),
        );
      }
    } catch (error) {
      print("ERROR DELETE : $error");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak dapat terhubung ke server"),
          backgroundColor: Color(0xFF8B3A47),
        ),
      );
    }
  }

  // =========================
  // KONFIRMASI HAPUS
  // =========================

  void confirmDelete(int idPost, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFDF8),

          title: const Text(
            "Hapus artikel?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B1F2A),
            ),
          ),

          content: Text(
            'Apakah kamu yakin ingin menghapus "$title"?',
            style: const TextStyle(color: Color(0xFF3E302C)),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                "Batal",
                style: TextStyle(color: Color(0xFF6B6258)),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deletePost(idPost);
              },

              child: const Text(
                "Hapus",
                style: TextStyle(
                  color: Color(0xFF8B3A47),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // =========================
  // GAMBAR
  // =========================

  Widget buildImage(String imageUrl) {
    if (imageUrl.trim().isEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        color: const Color(0xFFF3E5D3),
        child: const Center(
          child: Icon(
            Icons.image_not_supported,
            size: 45,
            color: Color(0xFF8B3A47),
          ),
        ),
      );
    }

    // Proxy gambar
    final String proxyUrl =
        "https://wsrv.nl/?url=${Uri.encodeComponent(imageUrl.trim())}";

    return Image.network(
      proxyUrl,

      width: double.infinity,
      height: 200,

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
          height: 200,
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
          height: 200,
          color: const Color(0xFFF3E5D3),
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 45,
              color: Color(0xFF8B3A47),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =========================
      // BACKGROUND
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
          "Tersimpan",
          style: TextStyle(
            fontSize: 21,
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
          : posts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 60,
                    color: Color(0xFF8B3A47),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Belum ada artikel tersimpan",
                    style: TextStyle(fontSize: 16, color: Color(0xFF6B6258)),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFF6B1F2A),

              onRefresh: getPosts,

              child: ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: posts.length,

                itemBuilder: (context, index) {
                  final post = posts[index];

                  final int? idPost = int.tryParse(post["id_post"].toString());

                  final String title = post["title"]?.toString() ?? "";

                  final String image = post["image"]?.toString().trim() ?? "";

                  return Card(
                    margin: const EdgeInsets.only(bottom: 18),

                    color: const Color(0xFFFFFDF8),

                    elevation: 2,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),

                    clipBehavior: Clip.antiAlias,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // =====================
                        // GAMBAR
                        // =====================
                        if (image.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(18),
                            ),

                            child: buildImage(image),
                          )
                        else
                          Container(
                            width: double.infinity,
                            height: 200,
                            color: const Color(0xFFF3E5D3),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 45,
                                color: Color(0xFF8B3A47),
                              ),
                            ),
                          ),

                        // =====================
                        // INFORMASI ARTIKEL
                        // =====================
                        Padding(
                          padding: const EdgeInsets.all(16),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // =====================
                              // CATEGORY
                              // =====================
                              Text(
                                post["name_category"]?.toString() ?? "",

                                style: const TextStyle(
                                  color: Color(0xFF8B3A47),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 7),

                              // =====================
                              // TITLE
                              // =====================
                              Text(
                                title,

                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6B1F2A),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // =====================
                              // TEXT + TOMBOL HAPUS
                              // =====================
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Expanded(
                                    child: Text(
                                      post["post_text"]?.toString() ?? "",

                                      maxLines: 3,

                                      overflow: TextOverflow.ellipsis,

                                      style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.5,
                                        color: Color(0xFF3E302C),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // TOMBOL HAPUS
                                  if (idPost != null)
                                    IconButton(
                                      onPressed: () {
                                        confirmDelete(idPost, title);
                                      },

                                      icon: const Icon(Icons.delete_outline),

                                      color: const Color(0xFF8B3A47),

                                      tooltip: "Hapus artikel",

                                      padding: EdgeInsets.zero,

                                      constraints: const BoxConstraints(),

                                      visualDensity: VisualDensity.compact,
                                    ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // =====================
                              // TANGGAL
                              // =====================
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
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
