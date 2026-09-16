import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final String baseUrl = "http://localhost:3000";
  // final String baseUrl = "http://10.0.2.2:3000";

  // =========================================================
  // CONTROLLER
  // =========================================================

  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final textController = TextEditingController();
  final imageController = TextEditingController();

  bool isCreating = false;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();
  }

  // =========================================================
  // CREATE POST
  // =========================================================

  Future<void> createPost() async {
    if (titleController.text.trim().isEmpty) {
      showMessage("Judul wajib diisi");
      return;
    }

    if (categoryController.text.trim().isEmpty) {
      showMessage("Category wajib diisi");
      return;
    }

    if (textController.text.trim().isEmpty) {
      showMessage("Isi artikel wajib diisi");
      return;
    }

    setState(() {
      isCreating = true;
    });

    try {
      final String namaCategory = categoryController.text.trim();

      int? categoryId;

      // =====================================================
      // 1. CARI CATEGORY YANG SUDAH ADA
      // =====================================================

      final categoryResponse = await http.get(
        Uri.parse("$baseUrl/api/category"),
      );

      if (categoryResponse.statusCode == 200) {
        final result = jsonDecode(categoryResponse.body);

        final List<dynamic> data = result["data"] ?? [];

        for (final category in data) {
          final String nama = category["nama_category"]
              .toString()
              .trim()
              .toLowerCase();

          if (nama == namaCategory.toLowerCase()) {
            categoryId = int.parse(
              category["id_category"].toString(),
            );

            break;
          }
        }
      }

      // =====================================================
      // 2. KALAU CATEGORY BELUM ADA → BUAT CATEGORY BARU
      // =====================================================

      if (categoryId == null) {
        final createCategoryResponse = await http.post(
          Uri.parse("$baseUrl/api/category"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "nama_category": namaCategory,
          }),
        );

        print(
          "CATEGORY POST STATUS: "
          "${createCategoryResponse.statusCode}",
        );

        print(
          "CATEGORY POST RESPONSE: "
          "${createCategoryResponse.body}",
        );

        if (createCategoryResponse.statusCode != 201) {
          showMessage("Gagal membuat category");
          return;
        }

        // ===================================================
        // 3. AMBIL ULANG DATA CATEGORY
        // ===================================================

        final getCategoryResponse = await http.get(
          Uri.parse("$baseUrl/api/category"),
        );

        print(
          "GET CATEGORY ULANG STATUS: "
          "${getCategoryResponse.statusCode}",
        );

        print(
          "GET CATEGORY ULANG RESPONSE: "
          "${getCategoryResponse.body}",
        );

        if (getCategoryResponse.statusCode == 200) {
          final result = jsonDecode(
            getCategoryResponse.body,
          );

          final List<dynamic> data = result["data"] ?? [];

          for (final category in data) {
            final String nama = category["nama_category"]
                .toString()
                .trim()
                .toLowerCase();

            if (nama == namaCategory.toLowerCase()) {
              categoryId = int.parse(
                category["id_category"].toString(),
              );

              break;
            }
          }
        }
      }

      // =====================================================
      // 4. CEK ID CATEGORY
      // =====================================================

      if (categoryId == null) {
        showMessage("ID category tidak ditemukan");
        return;
      }

      print("ID CATEGORY YANG DIPAKAI: $categoryId");

      // =====================================================
      // 5. DATA POST / ARTIKEL
      // =====================================================

      final Map<String, dynamic> body = {
        "id_category": categoryId,
        "title": titleController.text.trim(),
        "name_category": namaCategory,
        "post_text": textController.text.trim(),
      };

      if (imageController.text.trim().isNotEmpty) {
        body["image"] = imageController.text.trim();
      }

      print("================================");
      print("DATA YANG DIKIRIM:");
      print(body);
      print("================================");

      // =====================================================
      // 6. POST ARTIKEL
      // =====================================================

      final response = await http.post(
        Uri.parse("$baseUrl/api/post"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("POST STATUS: ${response.statusCode}");
      print("POST RESPONSE: ${response.body}");

      // =====================================================
      // 7. BERHASIL
      // =====================================================

      if (response.statusCode == 201) {
        showMessage(
          "Artikel berhasil disimpan!",
          success: true,
        );

        titleController.clear();
        categoryController.clear();
        textController.clear();
        imageController.clear();
      } else {
        String message = "Gagal menyimpan artikel";

        try {
          final result = jsonDecode(response.body);

          message = result["message"]?.toString() ?? message;
        } catch (_) {}

        showMessage(message);
      }
    } catch (error) {
      print("ERROR CREATE POST: $error");

      showMessage("Tidak dapat terhubung ke server");
    } finally {
      if (mounted) {
        setState(() {
          isCreating = false;
        });
      }
    }
  }

  // =========================================================
  // SNACKBAR
  // =========================================================

  void showMessage(
    String message, {
    bool success = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success
            ? const Color(0xFF6B1F2A)
            : const Color(0xFF8B3A47),
      ),
    );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    textController.dispose();
    imageController.dispose();

    super.dispose();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BACKGROUND CREAM
      backgroundColor: const Color(0xFFFFF8ED),

      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8ED),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF6B1F2A),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          "Tulis Artikel",
          style: TextStyle(
            color: Color(0xFF6B1F2A),
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =================================================
            // HEADER
            // =================================================

            const Text(
              "Bagikan ceritamu",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B1F2A),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "Tulis artikel dan bagikan kepada pembaca.",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B6258),
              ),
            ),

            const SizedBox(height: 25),

            // =================================================
            // JUDUL
            // =================================================

            const Text(
              "Judul Artikel",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E302C),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleController,

              decoration: InputDecoration(
                hintText: "Masukkan judul artikel",

                filled: true,
                fillColor: const Color(0xFFFFFDF8),

                prefixIcon: const Icon(
                  Icons.title,
                  color: Color(0xFF6B1F2A),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B1F2A),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // CATEGORY
            // =================================================

            const Text(
              "Category",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E302C),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: categoryController,

              decoration: InputDecoration(
                hintText: "Masukkan category",

                filled: true,
                fillColor: const Color(0xFFFFFDF8),

                prefixIcon: const Icon(
                  Icons.category_outlined,
                  color: Color(0xFF6B1F2A),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B1F2A),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // ISI ARTIKEL
            // =================================================

            const Text(
              "Isi Artikel",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E302C),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: textController,

              maxLines: 8,

              decoration: InputDecoration(
                hintText: "Tulis artikelmu di sini...",

                filled: true,
                fillColor: const Color(0xFFFFFDF8),

                alignLabelWithHint: true,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B1F2A),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // URL GAMBAR
            // =================================================

            const Text(
              "URL Gambar",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E302C),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: imageController,

              keyboardType: TextInputType.url,

              decoration: InputDecoration(
                hintText: "Masukkan URL gambar (opsional)",

                filled: true,
                fillColor: const Color(0xFFFFFDF8),

                prefixIcon: const Icon(
                  Icons.image_outlined,
                  color: Color(0xFF6B1F2A),
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B1F2A),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =================================================
            // BUTTON
            // =================================================

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: isCreating ? null : createPost,

                style: ElevatedButton.styleFrom(
                  // BUTTON MAROON
                  backgroundColor: const Color(0xFF6B1F2A),

                  foregroundColor: const Color(0xFFFFF8ED),

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                child: isCreating
                    ? const SizedBox(
                        width: 23,
                        height: 23,

                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFFFF8ED),
                        ),
                      )
                    : const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [
                          Icon(Icons.send),

                          SizedBox(width: 8),

                          Text(
                            "Simpan Artikel",

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}