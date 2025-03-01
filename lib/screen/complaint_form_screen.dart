import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComplaintFormScreen extends StatefulWidget {
  @override
  _ComplaintFormScreenState createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  void _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      String title = _titleController.text.trim();
      String description = _descriptionController.text.trim();
      String userId = FirebaseAuth.instance.currentUser?.uid ?? "Anonymous";
      Timestamp timestamp = Timestamp.now(); // Firestore timestamp

      try {
        Future<void> addComplaint(String title, String description,
            String userId, Timestamp timestamp) async {
          await FirebaseFirestore.instance.collection('complaints').add({
            'title': title,
            'description': description,
            'userId': userId,
            'timestamp': timestamp,
          });
        }

        _titleController.clear();
        _descriptionController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting complaint: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submit a Complaint")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Title cannot be empty' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Description cannot be empty' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitComplaint,
                child: Text('Submit Complaint'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
