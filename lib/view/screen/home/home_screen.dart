import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/view/screen/verification_details_screen.dart';

import '../../../services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final TextEditingController _noteController = TextEditingController();
final TextEditingController _titleController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  final AuthService authService = Get.put(AuthService());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  void _signOut() async {
    await authService.signOut();
    Get.offAllNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Note"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: const Text("Title"),
                    ),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: "Add Title",
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.topLeft,
                      child: const Text("Note"),
                    ),
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        hintText: "Add Note",
                      ),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          String id =
                              DateTime.now().microsecondsSinceEpoch.toString();
                          firestore.collection('TodoList').doc(id).set({
                            'id': id,
                            'Title': _titleController.text.toString(),
                            'Post': _noteController.text.toString(),
                          }).then((value) {
                            Get.snackbar(
                                "Note Info", "Note Successfully added");
                            _titleController.clear();
                            _noteController.clear();
                          }).catchError((error) {
                            Get.snackbar("Error", error.toString());
                          });
                          Get.back(); // Close the dialog
                        },
                        child: const Text("Add"),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back(); // Close the dialog
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, size: 32),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                user?.emailVerified == true
                    ? 'Your email is verified'
                    : 'Your email is not verified',
                style: TextStyle(
                  color:
                      user?.emailVerified == true ? Colors.green : Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: firestore.collection('TodoList').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Unknown Error: Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final notes = snapshot.data?.docs;
                    if (notes == null || notes.isEmpty) {
                      return const Center(child: Text('No notes available'));
                    }
                    return ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        var note = notes[index];
                        return Card(
                          color: Colors.cyan,
                          child: ListTile(
                            title: Text(note['Title']),
                            subtitle: Text(note['Post']),
                          ),
                        );
                      },
                    );
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => VerificationDetailsScreen());
                },
                child: const Text("Go to Verification Details"))
          ],
        ),
      ),
    );
  }
}
