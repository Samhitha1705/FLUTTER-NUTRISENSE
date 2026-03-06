import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true;
    });

    final data = await ProfileService.getMyProfile();

    if (data != null) {
      setState(() {
        profile = data;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch profile")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void goToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    );

    /// Refresh profile after editing
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF1B4332),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profile == null
          ? const Center(child: Text("No profile data"))
          : ListView(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),

          /// EDIT PROFILE BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: goToEditProfile,
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B4332),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          _buildCardItem(Icons.person, "First Name", profile!['firstName']),
          _buildCardItem(Icons.person_outline, "Last Name", profile!['lastName']),
          _buildCardItem(Icons.email, "Email", profile!['email']),
          _buildCardItem(Icons.phone, "Phone", profile!['phone']),
          _buildCardItem(Icons.school, "Qualification", profile!['qualification']),
          _buildCardItem(Icons.book, "Specialization", profile!['specialization']),
          _buildCardItem(Icons.work, "Experience", profile!['experience']),
          _buildCardItem(Icons.badge, "Aadhaar Ref", profile!['aadhaarRef']),
          _buildCardItem(Icons.access_time, "Created At", profile!['createdAt']),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1B4332),
            Color(0xFF2D6A4F),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            backgroundImage: profile!['profilePhoto'] != null
                ? NetworkImage(profile!['profilePhoto'])
                : null,
            child: profile!['profilePhoto'] == null
                ? const Icon(Icons.person, size: 55, color: Colors.grey)
                : null,
          ),

          const SizedBox(height: 12),

          Text(
            "${profile!['firstName'] ?? ''} ${profile!['lastName'] ?? ''}",
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            profile!['email'] ?? "",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(IconData icon, String label, dynamic value) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1B4332)),

        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(value != null ? value.toString() : "-"),
      ),
    );
  }
}