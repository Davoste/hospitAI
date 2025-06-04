import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class addPatient extends StatefulWidget {
  const addPatient({super.key});

  @override
  State<addPatient> createState() => _addPatientState();
}

class _addPatientState extends State<addPatient> {
  String _activeTab = "Patients";
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _conditionsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final TextEditingController _emergencyContactNameController =
      TextEditingController();
  final TextEditingController _emergencyContactNumberController =
      TextEditingController();

  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            _buildSidebar(),
            Expanded(
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Patient Registration Form",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildFormFields(),
                            const SizedBox(height: 24),
                            Center(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.check),
                                label: const Text(
                                  'Add Patient',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: _submitForm,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 70,
            alignment: Alignment.center,
            color: Colors.white,
            child: const Text(
              'MediCare',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(color: Colors.white24),
          _buildSidebarItem(Icons.dashboard, "Dashboard", "/dashboard"),
          _buildSidebarItem(Icons.people, "Patients", "/patients"),
          _buildSidebarItem(
            Icons.calendar_view_day,
            "Appointments",
            "/appointments",
          ),
          _buildSidebarItem(Icons.message, "Messages", "/messages"),
          _buildSidebarItem(Icons.group, "Staff management", "/staff"),
          _buildSidebarItem(Icons.local_pharmacy, "Pharmacy", "/pharmacy"),
          const Spacer(),
          _buildSidebarItem(Icons.settings, "Settings", "/settings"),
          _buildSidebarItem(Icons.support_agent, "Support", "/support"),
          _buildSidebarItem(Icons.logout, "Logout", "/logout"),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '© 2025 MediCare',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, String routeName) {
    final bool isActive = _activeTab == title;
    return Container(
      decoration:
          isActive
              ? BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              )
              : null,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: () {
          setState(() {
            _activeTab = title;
          });
          if (ModalRoute.of(context)?.settings.name != routeName) {
            Navigator.pushNamed(context, routeName);
          }
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 32),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {},
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "New Patient",
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.message_outlined),
          const SizedBox(width: 16),
          const Icon(Icons.notifications_none),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: Colors.brown.shade800,
            child: const Text('AH'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      validator:
                          (value) => value!.isEmpty ? 'Enter full name' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Enter age' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      items:
                          ['Male', 'Female', 'Other']
                              .map(
                                (gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => setState(() => _selectedGender = value!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: _selectDate,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Select date of birth' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator:
                          (value) => value!.isEmpty ? 'Enter address' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      keyboardType: TextInputType.phone,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Enter phone number' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (optional)',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Patient's Background",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _conditionsController,
                decoration: const InputDecoration(
                  labelText: 'Known Medical Conditions',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _allergiesController,
                decoration: const InputDecoration(labelText: 'Allergies'),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _medicationsController,
                decoration: const InputDecoration(
                  labelText: 'Current Medications',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emergencyContactNameController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact Name',
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Enter contact name' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _emergencyContactNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact Number',
                      ),
                      keyboardType: TextInputType.phone,
                      validator:
                          (value) =>
                              value!.isEmpty ? 'Enter contact number' : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse("http://127.0.0.1:5000/add_patient");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": _nameController.text,
          "age": int.tryParse(_ageController.text) ?? 0,
          "gender": _selectedGender,
          "dob": _dobController.text,
          "address": _addressController.text,
          "phone": _phoneController.text,
          "email": _emailController.text,
          "conditions": _conditionsController.text,
          "allergies": _allergiesController.text,
          "medications": _medicationsController.text,
          "emergency_contact_name": _emergencyContactNameController.text,
          "emergency_contact_number": _emergencyContactNumberController.text,
        }),
      );
      // Clear all form fields
      _nameController.clear();
      _ageController.clear();
      _dobController.clear();
      _addressController.clear();
      _phoneController.clear();
      _emailController.clear();
      _conditionsController.clear();
      _allergiesController.clear();
      _medicationsController.clear();
      _emergencyContactNameController.clear();
      _emergencyContactNumberController.clear();
      setState(() {
        _selectedGender = 'Male';
      });
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text(
                  "Success",
                  style: TextStyle(color: Colors.green),
                ),
                content: const Text(
                  "Patient added successfully!",
                  style: TextStyle(color: Colors.green),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
        );
      } else {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Error", style: TextStyle(color: Colors.red)),
                content: const Text(
                  "Patient adding Failed!",
                  style: TextStyle(color: Colors.red),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
        );
      }
    }
  }
}
