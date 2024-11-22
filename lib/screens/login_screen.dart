import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piton_books/providers/providers.dart';
import 'package:piton_books/services/local_auth_service.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'catalog_screen.dart';
import '../providers/navigation_provider.dart';  
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final _biometricAuthService = BiometricAuthService(); 

  @override
  void initState() {
    super.initState();
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    final authService = ref.read(authServiceProvider);
    final rememberMe = await authService.isRememberMe();
    if (rememberMe) {
      final token = await authService.getToken();
      if (token != null) {
        final navigationNotifier = ref.read(navigationProvider.notifier);
        navigationNotifier.pushReplacement(context, CatalogScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final navigationNotifier = ref.read(navigationProvider.notifier);  

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
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
                        SizedBox(height: 60),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              tr('welcome_back'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0x99090937),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              tr('login_title'),
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
                  SizedBox(height: 40),
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
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            activeColor: Color(0xFF6C63FF),
                            checkColor: Colors.white,
                          ),
                          Text(
                            tr('remember_me'),
                            style: TextStyle(color: Color(0xFF6251DD)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          navigationNotifier.pushReplacement(
                            context,
                            RegisterScreen(),
                          );
                        },
                        child: Text(
                          tr('register'),
                          style: TextStyle(color: Color(0xFF6C63FF)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  authState.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _login(authNotifier, navigationNotifier);
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
                              tr('login_button'),
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                  SizedBox(height: 20),
                  // Biometric login button
                  ElevatedButton(
                    onPressed: () async {
                      bool isAuthenticated = await _biometricAuthService.authenticateWithBiometrics();
                      if (isAuthenticated) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Authenticated successfully")));
                       
                        navigationNotifier.pushReplacement(
                          context,
                          CatalogScreen(),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Authentication failed")));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 92,),
                      backgroundColor: Color(0xFF6251DD), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Login with Biometrics",
                      style: TextStyle(fontSize: 18, color: Colors.white),
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

  Future<void> _login(AuthNotifier authNotifier, NavigationNotifier navigationNotifier) async {
    try {
      await authNotifier.login(
        email: _emailController.text,
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('login_successful'))),
      );
      navigationNotifier.pushReplacement(
        context,
        CatalogScreen(),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }
}
