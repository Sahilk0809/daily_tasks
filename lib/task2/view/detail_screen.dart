import 'package:flutter/material.dart';
import '../modal/user_modal.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "User Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(user.image),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "${user.firstName} ${user.lastName}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Username: ${user.username}",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle("Personal Details"),
              _buildDetail(Icons.email, "Email", user.email),
              _buildDetail(Icons.phone, "Phone", user.phone),
              _buildDetail(Icons.cake, "Date of Birth", user.birthDate),
              _buildDetail(Icons.person, "Gender", user.gender.name),
              _buildDetail(Icons.bloodtype, "Blood Group", user.bloodGroup),
              _buildDetail(Icons.height, "Height", "${user.height} cm"),
              _buildDetail(Icons.monitor_weight, "Weight", "${user.weight} kg"),
              _buildDetail(Icons.remove_red_eye, "Eye Color", user.eyeColor),
              const Divider(color: Colors.grey, height: 30),
              _buildSectionTitle("Address"),
              _buildDetail(
                Icons.location_city,
                "Address",
                "${user.address.address}, ${user.address.city}, ${user.address.state}, ${user.address.postalCode}",
              ),
              const Divider(color: Colors.grey, height: 30),
              _buildSectionTitle("Company"),
              _buildDetail(Icons.work, "Company Name", user.company.name),
              _buildDetail(
                  Icons.apartment, "Department", user.company.department),
              const Divider(color: Colors.grey, height: 30),
              _buildSectionTitle("Education"),
              _buildDetail(Icons.school, "University", user.university),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
