import 'package:flutter/material.dart';
import 'login.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BACKGROUND CREAM
      backgroundColor: const Color(0xFFFFF8ED),

      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B1F2A),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF8ED),
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Account",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B1F2A),
              ),
            ),

            const SizedBox(height: 15),

            // ACCOUNT
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: const Color(0xFFFFFDF8),

                borderRadius: BorderRadius.circular(18),

                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF6B1F2A,
                    ).withOpacity(0.08),

                    blurRadius: 10,

                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,

                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5D3),

                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Color(0xFF6B1F2A),
                    ),
                  ),

                  const SizedBox(width: 15),

                  const Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        "Hanaya Chika R",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E302C),
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "Pelajar",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B6258),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // LOGOUT
            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,

                    MaterialPageRoute(
                      builder: (context) =>
                          const LoginPage(),
                    ),

                    (route) => false,
                  );
                },

                icon: const Icon(Icons.logout),

                label: const Text(
                  "Logout",

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  // BUTTON MAROON
                  backgroundColor: const Color(0xFF6B1F2A),

                  foregroundColor: const Color(0xFFFFF8ED),

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}