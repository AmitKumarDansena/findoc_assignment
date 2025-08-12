import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Import BLoC components
import '../bloc/login/login_event.dart';
import '../bloc/login/login_state.dart';
import '../bloc/login/login_bloc.dart';
// Import the centralized validators
import '../utils/validators.dart';
// Import UI widgets
import '../widgets/animated_moving_object.dart';
import '../widgets/dynamic_background.dart';
// Import the next screen
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Dynamic Background Slideshow
          const DynamicBackground(
            imageCount: 5,
            interval: Duration(seconds: 7),
          ),
          // Animated Moving Objects (Floating Elements)
          const AnimatedMovingObject(index: 1),
          const AnimatedMovingObject(index: 2),
          // Main Login Form Content
          const SafeArea(
            child: Center(
              child: LoginForm(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _alignmentAnimation = Tween<Alignment>(
      begin: Alignment(-1.0, -0.8),
      end: Alignment(1.0, -0.8),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          // Handle state changes for navigation and SnackBar messages
          if (state.isSuccess) {
            // Navigate to Home Screen with a Fade Transition
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // Fade transition
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 600),
              ),
            );
          }
          if (state.isFailure) {
            // Show error SnackBar if login fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
          // Note: Validation errors are handled by the individual TextField BlocBuilders.
          // General submission errors are handled by isFailure.
          // The specific 'state' access errors from before should now be resolved
          // as we are correctly using the 'state' parameter within this listener.
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon or Title
                  const Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Email Input Field
                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.email != current.email ||
                        previous.errorMessage != current.errorMessage,
                    builder: (context, state) {
                      // 'state' is correctly available here as a parameter
                      return TextField(
                        onChanged: (email) => context
                            .read<LoginBloc>()
                            .add(LoginEmailChanged(email: email)),
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: Colors.blueGrey),
                          // Use Validators.isValidEmail from utils
                          errorText: state.email.isNotEmpty &&
                                  !Validators.isValidEmail(state.email)
                              ? 'Please enter a valid email'
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      );
                    },
                  ),
                  const SizedBox(height: 18.0),
                  // Password Input Field
                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.password != current.password ||
                        previous.errorMessage != current.errorMessage,
                    builder: (context, state) {
                      // 'state' is correctly available here as a parameter
                      return TextField(
                        onChanged: (password) => context
                            .read<LoginBloc>()
                            .add(LoginPasswordChanged(password: password)),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline,
                              color: Colors.blueGrey),
                          // Use Validators.isValidPassword from utils
                          errorText: state.password.isNotEmpty &&
                                  !Validators.isValidPassword(state.password)
                              ? 'Min 8 chars: uppercase, lowercase, number, symbol'
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.blueAccent, width: 2.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                        obscureText: true,
                      );
                    },
                  ),
                  const SizedBox(height: 30.0),
                  // Login Button
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      // 'state' is correctly available here as a parameter
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isValid && !state.isSubmitting
                              ? () => context
                                  .read<LoginBloc>()
                                  .add(LoginSubmitted())
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            backgroundColor: state.isValid
                                ? Colors.blueAccent
                                : Colors.grey.shade400,
                            foregroundColor: Colors.white,
                            elevation: 4,
                          ),
                          child: state.isSubmitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Login',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  ),
                  // Display Error Message if any (e.g., general submission error)
                  // This is handled by BlocListener's isFailure now.
                  // If you had specific validation messages to show outside
                  // the individual fields, you would access 'state' here within
                  // this BlocBuilder's builder callback.
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}