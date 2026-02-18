// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../widgets_komponen.dart'; // Pastikan path ini sesuai dengan file widget kamu
import 'home_screen.dart';
import 'services/user_service.dart';

// --- 1. LOGIN EMAIL ---
class LoginEmailScreen extends StatefulWidget {
  const LoginEmailScreen({super.key});
  @override
  State<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                CustomTextField(
                  hintText: "Email Address",
                  controller: _emailController,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Continue",
                  onPressed: () {
                    if (_emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Email wajib diisi!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPasswordScreen(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  ),
                  child: const Text(
                    "Belum punya akun? Buat akun",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
                
                SocialButton(
                  text: "Continue With Google",
                  imagePath: 'assets/images/Google.png',
                  onTap: () {},
                ),
                const SizedBox(height: 15),
                SocialButton(
                  text: "Continue With Facebook",
                  imagePath: 'assets/images/Facebook.png',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- 2. LOGIN PASSWORD ---
class LoginPasswordScreen extends StatelessWidget {
  const LoginPasswordScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const CustomTextField(hintText: "Password", isPassword: true),
              const SizedBox(height: 20),
              CustomButton(
                text: "Continue",
                onPressed: () {
                  // ✅ PERBAIKAN 1: Tambahkan username manual (karena belum ada database)
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(username: "User Melaju"), 
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 3. REGISTER SCREEN ---
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              CustomTextField(
                hintText: "Full Name",
                controller: _nameController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hintText: "Email Address",
                controller: _emailController,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hintText: "Password",
                isPassword: true,
                controller: _passController,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: "Create Account",
                onPressed: () async {
                  if (_nameController.text.isEmpty) {
                     if (mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Nama wajib diisi bro!")),
                        );
                     }
                     return;
                  } else if (_emailController.text.isEmpty) {
                     if (mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Email wajib diisi!")),
                        );
                     }
                     return;
                  } else if (_passController.text.isEmpty) {
                     if (mounted) {
                       ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password wajib diisi!")),
                        );
                     }
                     return;
                  }
                  
                  // ✅ SIMPAN DATA KE STORAGE SEBELUM NAVIGASI
                  bool success = await UserService.saveUser(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passController.text,
                  );

                  if (!mounted) return;

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Akun berhasil dibuat! ✅"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Tunggu 1 detik sebelum navigasi
                    await Future.delayed(const Duration(seconds: 1));

                    if (!mounted) return;
                    
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          username: _nameController.text,
                        ),
                      ),
                      (route) => false,
                    );
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Gagal menyimpan data!"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}