import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/login/login_bloc.dart';
import '../blocs/login/login_event.dart';
import '../blocs/login/login_state.dart';
import '../repositories/picsum_repository.dart';
import 'home_page.dart';
import '../utils/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final picsumRepository = context.read<PicsumRepository>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.status == LoginStatus.success) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => HomePage(picsumRepository: picsumRepository),
                  ),
                );
              } else if (state.status == LoginStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
                );
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Welcome',
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onChanged: (v) =>
                        context.read<LoginBloc>().add(LoginEmailChanged(v)),
                    validator: (value) {
                      if (!Validators.isValidEmail(value ?? '')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    onChanged: (v) =>
                        context.read<LoginBloc>().add(LoginPasswordChanged(v)),
                    validator: (value) {
                      if (!Validators.isValidPassword(value ?? '')) {
                        return 'Password must have uppercase, lowercase, number, and symbol';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.status == LoginStatus.loading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ?? false) {
                                  context
                                      .read<LoginBloc>()
                                      .add(LoginSubmitted());
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: state.status == LoginStatus.loading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Submit'),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Password must be at least 8 characters and include uppercase, lowercase, number, and symbol.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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
