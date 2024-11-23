import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import '../providers/navigation_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final navigationNotifier = ref.read(navigationProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/MidLogo.png',
                          height: 100,
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              tr('welcome'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0x99090937),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              tr('register_title'),
                              style: TextStyle(
                                fontSize: 24,
                                color: Color(0xFF090937),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Name part
                  SizedBox(height: 40),
                  Text(
                    tr('name'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF090937),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "John Doe",
                      hintStyle: TextStyle(color: Color(0x66090937)),
                      filled: true,
                      fillColor: Color(0xFFF3F1FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr('please_enter_name');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  //E Mail Part
                  Text(
                    tr('email'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF090937),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "john@mail.com",
                      hintStyle: TextStyle(color: Color(0x66090937)),
                      filled: true,
                      fillColor: Color(0xFFF3F1FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr('please_enter_email');
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return tr('please_enter_valid_email');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  //Password Part
                  Text(
                    tr('password'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF090937),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "●●●●●●●●",
                      hintStyle: TextStyle(color: Color(0x66090937)),
                      filled: true,
                      fillColor: Color(0xFFF3F1FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr('please_enter_password');
                      } else if (value.length < 6 || value.length > 20) {
                        return tr('password_length');
                      } else if (!RegExp(r'^[a-zA-Z0-9]{6,20}$')
                          .hasMatch(value)) {
                        return tr(
                            'password_must_be_alphanumeric'); 
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        navigationNotifier.pushReplacement(
                          context,
                          LoginScreen(),
                        );
                      },
                      child: Text(
                        tr('login'),
                        style: TextStyle(color: Color(0xFF6C63FF)),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _register(navigationNotifier);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Color(0xFFFF7A59),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              tr('register_button'),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
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

  Future<void> _register(NavigationNotifier navigationNotifier) async {
    try {
      await ref.read(authProvider.notifier).register(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('register_successful'))),
      );
      navigationNotifier.pushReplacement(
        context,
        LoginScreen(),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }
}
