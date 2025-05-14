import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DriverHistoryPage extends StatelessWidget {
  const DriverHistoryPage({super.key});

  // Dummy data for history
  final List<Map<String, dynamic>> historyData = const [
    {
      'date': '2023-06-15',
      'type': 'Accident',
      'severity': 'High',
      'location': 'Main Road, Islamabad',
      'description': 'Rear collision at traffic signal',
      'time': '14:30'
    },
    {
      'date': '2023-05-22',
      'type': 'Speeding',
      'severity': 'Medium',
      'location': 'Motorway M2',
      'description': 'Exceeded speed limit by 20km/h',
      'time': '09:15'
    },
    {
      'date': '2023-04-10',
      'type': 'Harsh Braking',
      'severity': 'Low',
      'location': 'Faisal Avenue',
      'description': 'Sudden brake application',
      'time': '17:45'
    },
    {
      'date': '2023-03-05',
      'type': 'Accident',
      'severity': 'Medium',
      'location': 'Blue Area',
      'description': 'Side swipe while lane changing',
      'time': '11:20'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate stats from dummy data
    final accidentCount = historyData.where((e) => e['type'] == 'Accident').length;
    final speedingCount = historyData.where((e) => e['type'] == 'Speeding').length;
    final harshBrakingCount = historyData.where((e) => e['type'] == 'Harsh Braking').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Driver History',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with stats
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Safety Overview',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF520521))),
                        const SizedBox(height: 15),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildStatCard(context, 'Accidents', accidentCount, Colors.red),
                              const SizedBox(width: 10),
                              _buildStatCard(context, 'Speeding', speedingCount, Colors.orange),
                              const SizedBox(width: 10),
                              _buildStatCard(context, 'Harsh Braking', harshBrakingCount, Colors.amber),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Recent Events header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text('Recent Events',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800])),
                  ),

                  // History List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: historyData.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final event = historyData[index];
                        return _buildHistoryCard(context, event);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, int count, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> event) {
    final date = DateTime.parse(event['date']);
    final formattedDate = DateFormat('MMM dd, yyyy').format(date);
    final time = event['time'];

    IconData icon;
    Color color;
    switch (event['type']) {
      case 'Accident':
        icon = Icons.car_crash;
        color = Colors.red;
        break;
      case 'Speeding':
        icon = Icons.speed;
        color = Colors.orange;
        break;
      case 'Harsh Braking':
        icon = Icons.emergency;
        color = Colors.amber;
        break;
      default:
        icon = Icons.warning;
        color = Colors.grey;
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    event['type'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(event['severity']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    event['severity'],
                    style: TextStyle(
                      color: _getSeverityColor(event['severity']),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDetailItem(Icons.calendar_today, formattedDate),
                  const SizedBox(width: 16),
                  _buildDetailItem(Icons.access_time, time),
                  const SizedBox(width: 16),
                  _buildDetailItem(Icons.location_on, event['location']),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              event['description'],
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}