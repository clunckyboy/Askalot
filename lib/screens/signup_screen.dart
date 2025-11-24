import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    setState(() {
      _errorMessage = null;

      if(_usernameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {

        _errorMessage = "Isi semua data";
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _errorMessage = "password tidak sama";
      } else {
        GoRouter.of(context).push('/interests', extra: {
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        });
      }
    });
  }

  // Fungsi pembangun widget untuk input field (membuat kode lebih rapi)
  Widget _buildInputSection({
    required String title,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'TT Norms Pro',
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            // filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFF7A6BFF), width: 2), // Fokus border warna ungu
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(

          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),

              // tombol back
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),

              const SizedBox(height: 20),

              // GAMBAR LOGO
              Center(
                child: Image.asset(
                  'assets/images/askalot.png',
                  width: 120,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 30),

              // Judul
              const Text(
                'Create your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontFamily: 'TT Norms Pro',
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 40),

              // Formulir Input
              _buildInputSection(
                title: 'Username',
                controller: _usernameController
              ),
              const SizedBox(height: 18),
              _buildInputSection(
                  title: 'Email',
                  controller: _emailController
              ),
              const SizedBox(height: 18),
              _buildInputSection(
                title: 'Password',
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 18),
              _buildInputSection(
                title: 'Confirm Password',
                controller: _confirmPasswordController,
                isPassword: true,
              ),

              const SizedBox(height: 30),

              // Error message
              if (_errorMessage != null)
                Container(
                  child: Center(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TT Norms Pro',
                      ),
                    ),
                  ),
                ),

              // Tombol Sign Up
              ElevatedButton(
                onPressed: _handleSignup,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 49),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: 'TT Norms Pro',
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

}