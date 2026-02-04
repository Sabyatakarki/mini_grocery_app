import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/utils/snackbar_utils.dart';
import 'package:mini_grocery/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:mini_grocery/features/auth/data/models/auth_api_model.dart';
import 'package:mini_grocery/core/services/storage/user_session_service.dart';
import 'package:mini_grocery/features/auth/presentation/pages/loginpagescreen.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptTerms) {
      SnackbarUtils.showWarning(
        context,
        "Please accept Terms & Privacy Policy",
      );
      return;
    }

    final fullName = fullNameController.text.trim();
    if (fullName.isEmpty) {
      SnackbarUtils.showError(context, "Full name is required");
      return;
    }

    setState(() => _isLoading = true);

    final authRemote = ref.read(authRemoteDatasourceProvider);
    final userSession = ref.read(userSessionServiceProvider);

    try {
      final newUser = await authRemote.register(
        AuthApiModel(
          fullName: fullName,
          email: emailController.text.trim(),
          username: emailController.text.trim(),
          phoneNumber: phoneController.text.trim(), // added phone
          password: passController.text.trim(),
        ),
      );

      if (newUser.id == null || newUser.id!.isEmpty) {
        SnackbarUtils.showError(context, "Registration failed: User ID not found");
        return;
      }

      await userSession.saveUserSession(
        userId: newUser.id!,
        email: newUser.email,
        fullName: newUser.fullName,
        username: newUser.username,
        phoneNumber: newUser.phoneNumber,
        
      );

      if (!mounted) return;

      SnackbarUtils.showSuccess(context, "Account Created Successfully");

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(context, "Failed to create account: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF488A1F),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Join us and start your fresh shopping journey",
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // FULL NAME
                _buildField(
                  label: "Full Name",
                  controller: fullNameController,
                  icon: Icons.person_outline,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Full name required" : null,
                ),

                const SizedBox(height: 20),

                // EMAIL
                _buildField(
                  label: "Email",
                  controller: emailController,
                  icon: Icons.email_outlined,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Email required";
                    if (!v.contains('@')) return "Invalid email";
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // PHONE NUMBER
                _buildField(
                  label: "Phone Number",
                  controller: phoneController,
                  icon: Icons.phone_outlined,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Phone number required";
                    final regex = RegExp(r'^\d{10}$'); // 10 digits
                    if (!regex.hasMatch(v)) return "Phone Number must be 10 digits";
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // PASSWORD
                _buildPasswordField(
                  label: "Password",
                  controller: passController,
                  visible: _passwordVisible,
                  onToggle: () =>
                      setState(() => _passwordVisible = !_passwordVisible),
                ),

                const SizedBox(height: 20),

                // CONFIRM PASSWORD
                _buildPasswordField(
                  label: "Confirm Password",
                  controller: confirmPassController,
                  visible: _confirmPasswordVisible,
                  onToggle: () => setState(
                      () => _confirmPasswordVisible =
                          !_confirmPasswordVisible),
                  validator: (v) =>
                      v != passController.text ? "Passwords do not match" : null,
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      activeColor: const Color(0xFF6BAA44),
                      onChanged: (v) => setState(() => _acceptTerms = v!),
                    ),
                    const Expanded(
                      child: Text(
                        "I agree to the Terms & Privacy Policy",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6BAA44),
                    minimumSize: const Size(180, 45),
                    shape: const StadiumBorder(),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: const Color(0xFFF7FFCF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !visible,
          validator: validator ?? (v) => v == null || v.length < 6
              ? "Minimum 6 characters"
              : null,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon:
                  Icon(visible ? Icons.visibility : Icons.visibility_off),
              onPressed: onToggle,
            ),
            filled: true,
            fillColor: const Color(0xFFF7FFCF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
