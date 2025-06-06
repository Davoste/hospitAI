import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Patients extends StatefulWidget {
  const Patients({super.key});

  @override
  State<Patients> createState() => _PatientsState();
}

int currentPage = 1;
int totalPatients = 0;

class _PatientsState extends State<Patients> {
  List<Map<String, dynamic>> patients = [];
  String _activeTab = "Patients";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await getTotalPatients();
    await fetchPatients();
  }

  Future<void> fetchPatients() async {
    final url =
        searchQuery.isEmpty
            ? 'http://127.0.0.1:5000/get_patients?page=$currentPage&limit=10'
            : 'http://127.0.0.1:5000/search_patients?q=$searchQuery';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        patients = List<Map<String, dynamic>>.from(data);
      });
    } else {
      throw Exception('Failed to load patient data');
    }
  }

  Future<void> getTotalPatients() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/total_patients'),
    );
    if (response.statusCode == 200) {
      final total = jsonDecode(response.body)['total'];
      setState(() {
        totalPatients = total;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
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
                ...[
                  _buildSidebarItem(Icons.dashboard, "Dashboard", "/dashboard"),
                  _buildSidebarItem(Icons.people, "Patients", "/patients"),
                  _buildSidebarItem(
                    Icons.calendar_view_day,
                    "Appointments",
                    "/appointments",
                  ),
                  _buildSidebarItem(Icons.message, "Messages", "/messages"),
                  _buildSidebarItem(Icons.group, "Staff management", "/staff"),
                  _buildSidebarItem(
                    Icons.local_pharmacy,
                    "Pharmacy",
                    "/pharmacy",
                  ),
                ],
                const Spacer(),
                ...[
                  _buildSidebarItem(Icons.settings, "Settings", "/settings"),
                  _buildSidebarItem(Icons.support_agent, "Support", "/support"),
                  _buildSidebarItem(Icons.logout, "Logout", "/logout"),
                ],
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '© 2025 MediCare',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
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
                              onPressed: () {
                                setState(() {
                                  searchQuery = "";
                                });
                                fetchPatients();
                              },
                            ),
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                fetchPatients();
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                            fetchPatients();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton.icon(
                        onPressed: () {
                          if (ModalRoute.of(context)?.settings.name !=
                              '/newPatient') {
                            Navigator.pushNamed(context, '/newPatient');
                          }
                        },
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
                ),

                // Body content
                Row(
                  children: [
                    patientCard(
                      "Total Numbers of Patients",
                      totalPatients.toString(),
                    ),
                    patientCard("Patients Currently Admitted", "52"),
                    patientCard("Patients Discharged", "36"),
                  ],
                ),
                const Text(
                  "PATIENT LIST",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildPatientTable(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed:
                            currentPage > 1
                                ? () {
                                  setState(() => currentPage--);
                                  fetchPatients();
                                }
                                : null,
                        child: const Text('Previous'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => currentPage++);
                          fetchPatients();
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column patientCard(String title, String number) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            width: 300,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            width: 300,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPatientTable() {
    if (patients.isEmpty) {
      return const Text('No patients found.');
    }

    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(2),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Colors.blueAccent),
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Name', style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('ID', style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('DOB', style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Phone', style: TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Action', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        ...patients.map(
          (patient) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(patient['name'] ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(patient['id'].toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(patient['dob'] ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(patient['phone'] ?? ''),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => showEditDialog(context, patient),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed:
                          () => showDeleteConfirmation(context, patient['id']),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showDeleteConfirmation(BuildContext context, int id) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete this patient?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final response = await http.delete(
                    Uri.parse('http://127.0.0.1:5000/delete_patient/$id'),
                  );
                  Navigator.pop(ctx);
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Patient deleted')),
                    );
                    _loadData();
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void showEditDialog(BuildContext context, Map<String, dynamic> patient) {
    final nameController = TextEditingController(text: patient['name']);
    final dobController = TextEditingController(text: patient['dob']);
    final phoneController = TextEditingController(text: patient['phone']);
    final symptomController = TextEditingController();
    final diagnosisController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Edit Patient'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: dobController,
                          decoration: const InputDecoration(labelText: 'DOB'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(labelText: 'Phone'),
                        ),
                      ),
                    ],
                  ),

                  TextField(
                    controller: symptomController,
                    decoration: const InputDecoration(labelText: 'Symptoms'),
                  ),
                  TextField(
                    controller: diagnosisController,
                    decoration: const InputDecoration(labelText: 'Diagnosis'),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  final predictionResponse = await http.post(
                    Uri.parse('http://127.0.0.1:5000/predict_diagnosis'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({'symptoms': symptomController.text}),
                  );

                  if (predictionResponse.statusCode == 200) {
                    final result = jsonDecode(predictionResponse.body);
                    final predictedDiagnosis = result['predicted_diagnosis'];
                    print('Predicted diagnosis: $predictedDiagnosis');
                    showDialog(
                      context: context,
                      builder:
                          (ctx) => AlertDialog(
                            title: const Text('Prediction Result'),
                            content: Text(
                              'Predicted Diagnosis: $predictedDiagnosis',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder:
                          (ctx) => AlertDialog(
                            title: const Text('Prediction Failed'),
                            content: Text(
                              'Status Code: ${predictionResponse.statusCode}\n${predictionResponse.body}',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                    );
                  }
                },
                child: const Text('hospitAI'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final patientId = patient['id'];

                  // // 🔄 Update patient info
                  final updateResponse = await http.put(
                    Uri.parse(
                      'http://127.0.0.1:5000/update_patient/$patientId',
                    ),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'name': nameController.text,
                      'dob': dobController.text,
                      'phone': phoneController.text,
                    }),
                  );

                  // ➕ Add symptoms
                  final symptomResponse = await http.post(
                    Uri.parse('http://127.0.0.1:5000/add_patient_symptoms'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'patient_id': patientId,
                      'symptoms': symptomController.text,
                      'diagnosis': diagnosisController.text,
                      'notes':
                          '${symptomController.text}\nDiagnosis: ${diagnosisController.text}',
                      'severity': 'moderate',
                    }),
                  );

                  Navigator.pop(ctx);

                  if (updateResponse.statusCode == 200 &&
                      symptomResponse.statusCode == 200) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.green[100],
                          title: const Text(
                            'Success',
                            style: TextStyle(color: Colors.green),
                          ),
                          content: const Text('Patient updated successfully!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _loadData(); // Reload updated data
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // ❌ Show error popup
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.red[100],
                          title: const Text(
                            'Error',
                            style: TextStyle(color: Colors.red),
                          ),
                          content: const Text('Failed to save patient data.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Close',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Save'),
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
}
