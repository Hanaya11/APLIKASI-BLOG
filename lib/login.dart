import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8ED),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B1F2A)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.article_outlined,
                      size: 62,
                      color: Color(0xFF6B1F2A),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Sign In,',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B1F2A),
                    height: 1.2,
                  ),
                ),

                const Text(
                  'Sign in to your account.',
                  style: TextStyle(
                    color: Color(0xFF6B6258),
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 28),

                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Color(0xFF6B6258),
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Color(0xFF6B1F2A),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF6B1F2A),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Color(0xFF6B6258),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Color(0xFF6B1F2A),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF6B1F2A),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot you password?',
                      style: TextStyle(
                        color: Color(0xFF8B3A47),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B1F2A),
                      foregroundColor: const Color(0xFFFFF8ED),
                    ),
                    onPressed: () {
                      String inputNama =
                          _userController.text.trim();

                      if (inputNama.isEmpty) {
                        inputNama = 'Hanaya';
                      }

                      Navigator.pushReplacementNamed(
                        context,
                        '/home',
                        arguments: {
                          'nama': inputNama,
                          'password': _passController.text,
                        },
                      );
                    },
                    child: const Text('Sign In'),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Dont have an account yet?',
                      style: TextStyle(
                        color: Color(0xFF6B6258),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/register',
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF6B1F2A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
