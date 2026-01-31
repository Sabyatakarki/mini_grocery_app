import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_grocery/features/profile/presentation/state/profile_state.dart';
import 'package:mini_grocery/features/profile/presentation/view_model/profile_view_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileViewModelProvider).profile;

    _fullNameController = TextEditingController(text: profile?.fullName ?? '');
    _emailController = TextEditingController(text: profile?.email ?? '');
    _phoneController = TextEditingController(text: profile?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ───────────── PICK IMAGE ─────────────
  Future<void> _pickImage(ImageSource source) async {
    final viewModel = ref.read(profileViewModelProvider.notifier);
    await viewModel.pickImage(source);
  }

  void _showPickOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ───────────── SAVE TEXT FIELDS ─────────────
  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = ref.read(profileViewModelProvider.notifier);

    // This will automatically attach JWT from SharedPreferences
    await viewModel.updateProfile(
      fullName: _fullNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
    );

    final state = ref.read(profileViewModelProvider);
    if (state.status == ProfileStatus.success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context);
    } else if (state.errorMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage!)),
      );
    }
  }

  // ───────────── PROFILE IMAGE ─────────────
  ImageProvider? _getProfileImage(ProfileState state) {
    if (state.pickedImage != null) return FileImage(state.pickedImage!);

    final url = state.profile?.profilePicture;
    if (url != null && url.startsWith('http')) return NetworkImage(url);

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileViewModelProvider);

    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _getProfileImage(state),
                      child: _getProfileImage(state) == null
                          ? const Icon(Icons.person, size: 55)
                          : null,
                    ),
                    if (state.isUploadingImage)
                      const Positioned.fill(
                        child: CircularProgressIndicator(),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.edit, size: 16),
                          onPressed: _showPickOptions,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildTextField("Full Name", _fullNameController),
              _buildTextField("Email", _emailController),
              _buildTextField("Phone", _phoneController),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: state.status == ProfileStatus.loading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: state.status == ProfileStatus.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }
}
