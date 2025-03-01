import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyComplaintsScreen extends StatefulWidget {
  @override
  _MyComplaintsScreenState createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Complaints')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: DropdownButton<String>(
              value: _selectedStatus,
              items: ['All', 'Pending', 'Resolved'].map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (newStatus) {
                setState(() => _selectedStatus = newStatus!);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('complaints')
                  .where('userId', isEqualTo: _auth.currentUser!.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var complaints = snapshot.data!.docs;

                // Apply filter
                if (_selectedStatus != 'All') {
                  complaints = complaints.where((doc) => doc['status'] == _selectedStatus).toList();
                }

                return ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    var complaint = complaints[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(complaint['issue']),
                        subtitle: Text(complaint['description']),
                        trailing: Text(
                          complaint['status'],
                          style: TextStyle(
                            color: complaint['status'] == 'Resolved' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
