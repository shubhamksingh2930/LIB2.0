// lib/login_user_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // No longer strictly needed for phone formatters
import 'package:firebase_auth/firebase_auth.dart';
import 'user_dashboard_screen.dart';
import 'admin_login_screen.dart';
import 'services/firestore_service.dart'; // For saving user data

class LoginUserScreen extends StatefulWidget {
  const LoginUserScreen({super.key});

  @override
  State<LoginUserScreen> createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(); // For Sign Up
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;
  bool _isSignUpMode = false; // To toggle between Login and Sign Up UI
  bool _emailVerificationSent = false;
  Timer? _emailVerificationTimer;

  // --- Sign Up with Email and Password ---
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        // Save user data to Firestore immediately after creation
        // (even if email not yet verified, they exist in Auth)
        await _firestoreService.saveUser(
          user.uid,
          _nameController.text.trim(), // Get name from controller
          user.email!, // User will have an email
        );

        setState(() {
          _isLoading = false;
          _emailVerificationSent = true; // Show verification message
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! A verification email has been sent. Please verify your email to login.'),
              duration: Duration(seconds: 5),
            ),
          );
          // Optionally, start a timer to periodically check email verification status
          _startEmailVerificationCheckTimer(user);
        }
      } else if (user != null && user.emailVerified) {
        // This case is unlikely for a fresh sign-up but good to handle
        setState(() => _isLoading = false);
         await _firestoreService.saveUser( // Ensure data is saved
          user.uid,
          _nameController.text.trim(),
          user.email!,
        );
        _navigateToDashboard(userName: _nameController.text.trim(), userId: user.uid);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String message = "An error occurred during sign up.";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
        );
      }
      print("Sign up error: ${e.code} - ${e.message}");
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: ${e.toString()}')),
        );
      }
      print("Sign up unexpected error: $e");
    }
  }

  // --- Login with Email and Password ---
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;

      if (user != null) {
        if (user.emailVerified) {
          // Update last login in Firestore (name might not be available here directly without fetching)
          // The saveUser method in FirestoreService handles updating lastLogin.
          // We need to fetch the name if we want to pass it or just pass UID.
           await _firestoreService.saveUser(user.uid, "", user.email!); // Pass empty name, FirestoreService will handle existing data

          _navigateToDashboard(userName: user.displayName ?? "User", userId: user.uid); // Use displayName if available
        } else {
          setState(() {
            _isLoading = false;
            _emailVerificationSent = true; // Remind them to verify
          });
          await user.sendEmailVerification(); // Resend verification email
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please verify your email. A new verification link has been sent.')),
            );
          }
           _startEmailVerificationCheckTimer(user); // Start checking again
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      String message = "Login failed.";
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = 'Incorrect email or password.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else if (e.code == 'user-disabled') {
        message = 'This user account has been disabled.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
        );
      }
      print("Login error: ${e.code} - ${e.message}");
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: ${e.toString()}')),
        );
      }
      print("Login unexpected error: $e");
    }
  }

  // --- Helper for Email Verification Check (Optional but good UX) ---
  void _startEmailVerificationCheckTimer(User user) {
    _emailVerificationTimer?.cancel(); // Cancel any existing timer
    _emailVerificationTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await user.reload(); // Reload user data from Firebase
      User? refreshedUser = _auth.currentUser; // Get potentially refreshed user
      if (refreshedUser != null && refreshedUser.emailVerified) {
        timer.cancel();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email verified successfully! Logging in...'), backgroundColor: Colors.green),
          );
          // Fetch name from Firestore or use what's available
          // For simplicity, if signing up, _nameController has it. If logging in, it might be null.
          String nameToPass = _isSignUpMode ? _nameController.text.trim() : (refreshedUser.displayName ?? "User");
          await _firestoreService.saveUser(refreshedUser.uid, nameToPass, refreshedUser.email!);
          _navigateToDashboard(userName: nameToPass, userId: refreshedUser.uid);
        }
      }
      // If user navigates away or timer is cancelled elsewhere, this stops
      if (!mounted || !_emailVerificationSent) {
        timer.cancel();
      }
    });
  }


  void _navigateToDashboard({String? userName, String? userId}) {
    // Firestore saving is now handled within _signUp or _login if needed
    // This method just navigates
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const UserDashboardScreen()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailVerificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignUpMode ? 'Create Account' : 'User Login'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.black87),
            tooltip: 'Admin Login',
            onPressed: _isLoading ? null : () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Center( // Center the form vertically
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _isSignUpMode ? 'Join Us!' : 'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 30),

                if (_isSignUpMode) ...[ // Name field only for Sign Up
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isLoading ? null : (_isSignUpMode ? _signUp : _login),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_isSignUpMode ? 'Sign Up' : 'Login'),
                ),
                const SizedBox(height: 12),

                if (_emailVerificationSent && !_isSignUpMode && (_auth.currentUser != null && !_auth.currentUser!.emailVerified))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Text(
                          'Your email is not verified. Please check your inbox (and spam folder) for the verification link.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange.shade700),
                        ),
                        TextButton(
                          onPressed: _isLoading ? null : () async {
                            setState(() => _isLoading = true);
                            await _auth.currentUser?.sendEmailVerification();
                             if(mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification email resent.')));
                             }
                            setState(() => _isLoading = false);
                          },
                          child: const Text('Resend Verification Email'),
                        )
                      ],
                    ),
                  ),
                
                if (_emailVerificationSent && _isSignUpMode)
                 Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                          'A verification email has been sent to ${_emailController.text.trim()}. Please verify your email to complete registration and login.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                  ),


                TextButton(
                  onPressed: _isLoading ? null : () {
                    setState(() {
                      _isSignUpMode = !_isSignUpMode;
                      _emailVerificationSent = false; // Reset this when toggling
                      _formKey.currentState?.reset(); // Reset form fields and errors
                      _nameController.clear();
                      _emailController.clear();
                      _passwordController.clear();

                    });
                  },
                  child: Text(
                    _isSignUpMode ? 'Already have an account? Login' : 'New user? Create an account',
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