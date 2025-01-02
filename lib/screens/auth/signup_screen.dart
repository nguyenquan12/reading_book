import 'package:book_sale_apps/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Giả lập xử lý đăng ký
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Hiển thị thông báo đăng ký thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đăng ký thành công!")),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Colors.purple,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // title
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    color: Colors.lightBlue[30],
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // avatar
                            Center(
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.blueAccent,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            // user name
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'User Name',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter username';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            // email
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                                    .hasMatch(value)) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            // password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            // Confirm Password
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),
                            // sign up
                            ElevatedButton(
                              onPressed: _isLoading ? null : _signUp,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      'Sign up',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            SizedBox(height: 16),
                            // Already have an account?
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Already have an account?",
                                      style: TextStyle(),
                                    ),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Log in',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
