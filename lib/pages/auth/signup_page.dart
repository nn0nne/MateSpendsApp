import 'package:matespendsapp/pages/auth/signin_page.dart';
import 'package:matespendsapp/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _signUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        await authService.signUp(_emailController.text.trim(),
            _passwordController.text.trim(), context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF31AA68),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Welcome Text
                Text(
                  "Welcome!",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Subheading
                Text(
                  "Register and start track and manage your expenses!",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10), // Spacing before the form container

                // Form Container
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width - 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: const Color(0xFF49B47A),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Email Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 20,
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFFFFFF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Enter your email",
                                hintStyle:
                                    const TextStyle(color: Color(0xFF282828)),
                              ),
                              style: const TextStyle(color: Color(0xFF282828)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email cannot be empty";
                                } else if (!RegExp(r'\S+@\S+\.\S+')
                                    .hasMatch(value)) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password Field
                            const Text(
                              "Password",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 20,
                              ),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFFFFFFF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Enter your password",
                                hintStyle:
                                    const TextStyle(color: Color(0xFF282828)),
                              ),
                              style: const TextStyle(color: Color(0xFF282828)),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Password cannot be empty";
                                } else if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Sign-Up Button
                        Center(
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _signUp(context),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    backgroundColor: const Color(0xFF60BD8A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Navigate to SignIn
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignIn(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFFFFFFFF)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
