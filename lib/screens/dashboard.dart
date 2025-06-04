import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _activeTab = "Dashboard";

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
                              onPressed: () {},
                            ),
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {},
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                          ),
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[300],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Hi, Stanley",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Welcome. Your cases, appointments, and consultations are ready.",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Image.network(
                                "https://i.fbcd.co/products/resized/resized-750-500/e618b396eb325029e0db2582bbf4b773e3c1d7edc8deae63d1bcabf0ebb8a4ad.jpg",
                                height: 100,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Overview",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _infoCard(
                              "Appointments",
                              Colors.lightBlueAccent,
                              "150",
                            ),
                            const SizedBox(width: 16),
                            _infoCard("Consultations", Colors.blue, "15"),
                            const SizedBox(width: 16),
                            _infoCard("Urgent Cases", Colors.red, "05"),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Today's Summary",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _sectionCard(),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget _infoCard(String title, Color color, String number) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 300,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: 150,
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                "https://i.fbcd.co/products/resized/resized-750-500/e618b396eb325029e0db2582bbf4b773e3c1d7edc8deae63d1bcabf0ebb8a4ad.jpg",
                height: 100,
                width: 150,
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    "Today's",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionCard() {
    return Table(
      border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
        4: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Name',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'ID',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Date',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Time',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Actions',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('John Doe', style: TextStyle(color: Colors.black)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('001', style: TextStyle(color: Colors.black)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('2025-05-21', style: TextStyle(color: Colors.black)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('10:00 AM', style: TextStyle(color: Colors.black)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Edit/Delete', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ],
    );
  }
}
