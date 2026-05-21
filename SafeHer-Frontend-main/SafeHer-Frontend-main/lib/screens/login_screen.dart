import 'dart:convert';
import 'package:safeher/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:safeher/main_shell.dart';
import 'package:safeher/screens/home_screen.dart';
import 'package:safeher/screens/signup_screen.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});
  Future<bool> loginUser(String email, String password) async {

  final url = Uri.parse("http://127.0.0.1:5000/api/auth/login");
  
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  }

  return false;
}

TextEditingController loginController = TextEditingController();

TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Gradient Header
            Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "SafeHer AI",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    "Your safety companion",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            
            // Login Card
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
                  ),
                  const SizedBox(height: 8),
                  const Text("Please sign in to continue", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),
                  
                  TextField(controller: loginController,),
                  const SizedBox(height: 20),
                  TextField(controller: passController,),
                  const SizedBox(height: 32),
                  
                  // Gradient Button
                  ElevatedButton(
  onPressed: () async {

    bool success = await loginUser(
      loginController.text,
      passController.text,
    );

    if (success) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainShell(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Failed"),
        ),
      );

    }

  },
  child: Text("Login"),
),
                  
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context){
                      return SignupScreen();
                    })),
                        child: const Text("Sign Up", style: TextStyle(color: Color(0xFF9C27B0), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for consistent text fields
  Widget _buildTextField(String label, IconData icon, String hint, {bool isPassword = false, bool hasForgot = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
            if (hasForgot)
              TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFF9C27B0), fontSize: 12)),
              ),
          ],
        ),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFF9C27B0)]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}