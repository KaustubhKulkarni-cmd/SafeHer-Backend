import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
   TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
     TextEditingController passwordController = TextEditingController();
     TextEditingController confirmpassController = TextEditingController();


  bool _agreeToTerms = false;
  Future<bool> signupUser(String email, String password, String name, String phone) async {

  try {

    final url = Uri.parse("http://127.0.0.1:5000/api/auth/signup");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
        "name": name,
        "phone": phone
      }),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return data["success"] ?? false;
    }

    return false;

  } catch (e) {

    print("Signup error: $e");
    return false;

  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "SafeHer ", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                  TextSpan(text: "AI", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF9C27B0))),
                ],
              ),
            ),
            const Text("Your safety companion", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            const Text("Create Account", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const Text("Join our community and stay protected wherever you go.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            
            _buildLabelField("Full Name", "Sarah Jenkins",nameController),
            const SizedBox(height: 15),
            _buildLabelField("Email Address", "sarah@example.com",emailController),
            const SizedBox(height: 15),
            _buildLabelField("Phone Number", "+91 98765 43210",phoneController), // Added Phone Number
            const SizedBox(height: 15),
            _buildLabelField("Password", "********", passwordController,isPassword: true),
            const SizedBox(height: 15),
            _buildLabelField("Confirm Password", "********",confirmpassController, isPassword: true),
            
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (val) => setState(() => _agreeToTerms = val!),
                  activeColor: const Color(0xFF9C27B0),
                ),
                const Expanded(
                  child: Text("I agree to the Terms of Service and Privacy Policy.", style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildGradientButton("Create Account"),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Already have an account? "),
                      TextSpan(text: "Login", style: TextStyle(color: Color(0xFF9C27B0), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelField(String label, String hint,TextEditingController controller1, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          controller: controller1,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8F9FE),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton(String text) {
  return Container(
    width: double.infinity,
    height: 55,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
      ),
      borderRadius: BorderRadius.circular(15),
    ),
    child: ElevatedButton(
      onPressed: () async {

        String name = nameController.text.trim();
        String email = emailController.text.trim();
        String phone = phoneController.text.trim();
        String password = passwordController.text.trim();
        String confirm = confirmpassController.text.trim();

        // 1️⃣ Empty field check
        if (name.isEmpty ||
            email.isEmpty ||
            phone.isEmpty ||
            password.isEmpty ||
            confirm.isEmpty) {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all fields")),
          );
          return;
        }

        // 2️⃣ Password match check
        if (password != confirm) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match")),
          );
          return;
        }

        // 3️⃣ Terms checkbox
        if (!_agreeToTerms) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please accept Terms & Conditions")),
          );
          return;
        }

        // 4️⃣ Call API
        bool success = await signupUser(email, password, name, phone);

        if (success) {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Signup Successful")),
          );

          Navigator.pop(context); // Go to login page

        } else {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Signup Failed")),
          );

        }

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}}