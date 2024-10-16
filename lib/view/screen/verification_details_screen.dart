import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerificationDetailsScreen extends StatefulWidget {
  const VerificationDetailsScreen({super.key});

  @override
  State<VerificationDetailsScreen> createState() =>
      _VerificationDetailsScreenState();
}

class _VerificationDetailsScreenState extends State<VerificationDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Refreshing...')),
          );
        },
        child: const Icon(Icons.refresh),
      ),
      appBar: AppBar(title: const Text('Verification Details')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allUsers = snapshot.data?.docs ?? [];

          final verifiedUsers = allUsers
              .where((doc) => doc['isVerified'] == true)
              .map((doc) =>
                  {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();

          final unverifiedUsers = allUsers
              .where((doc) => doc['isVerified'] == false)
              .map((doc) =>
                  {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Verified Users',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: verifiedUsers.length,
                    itemBuilder: (context, index) {
                      final user = verifiedUsers[index];
                      return Card(
                        child: ListTile(
                          title: Text(user['email']),
                          subtitle: Text('isVerified: ${user['isVerified']}'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Unverified Users',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: unverifiedUsers.length,
                    itemBuilder: (context, index) {
                      final user = unverifiedUsers[index];
                      return Card(
                        child: ListTile(
                          title: Text(user['email']),
                          subtitle: Text('isVerified: ${user['isVerified']}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
