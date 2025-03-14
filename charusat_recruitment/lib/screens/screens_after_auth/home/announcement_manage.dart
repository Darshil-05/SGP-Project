import 'dart:convert';
import 'package:charusat_recruitment/Providers/announcement_provider.dart';
import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/service/common_service/annoncement_service.dart';
import 'package:flutter/material.dart';
import 'package:charusat_recruitment/screens/Components/announcecard.dart';
import 'package:charusat_recruitment/screens/models/announcement_model.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AnnouncementManagement extends StatefulWidget {
  const AnnouncementManagement({super.key});

  @override
  State<AnnouncementManagement> createState() => _AnnouncementManagementState();
}

class _AnnouncementManagementState extends State<AnnouncementManagement> {
  // Controllers for TextFormFields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Color picker or a default color for new announcements
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    List<AnnouncementModel> announcements =
        Provider.of<AnnouncementProvider>(context).announcements;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Announcement Manage',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color(0xff0f1d2c),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: announcements
                .map((announce) => GestureDetector(
                      onLongPress: () {
                        // Show confirmation dialog for deletion
                        _showDeleteDialog(announce);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnnounceCard(announce: announce),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        backgroundColor: const Color(0xff0f1d2c),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Method to show bottom sheet with color picker
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey, // Assign form key
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      "Add Announcement",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: "mediumfont",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff0f1d2c)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff0f1d2c)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _organizationController,
                    decoration: const InputDecoration(
                      labelText: 'Organization Name',
                      labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff0f1d2c)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the organization name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          // Add the announcement with a unique id
                          print("Calling announcement");
                          AnnouncementService().addAnnouncement(context ,
                              _titleController.text,
                              _descriptionController.text,
                              _organizationController.text);
                        });

                        // Clear the text fields after adding the announcement
                        _titleController.clear();
                        _descriptionController.clear();
                        _organizationController.clear();

                        // Close the bottom sheet
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Method to show delete confirmation dialog
  void _showDeleteDialog(AnnouncementModel announcement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Announcement'),
          content:
              const Text('Are you sure you want to delete this announcement?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without deleting
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  AnnouncementService().deleteAnnouncement(context ,announcement.id);
                  Provider.of<AnnouncementProvider>(context, listen: false)
                      .removeAnnouncementById(announcement.id);
                });
                Navigator.pop(context); // Close the dialog after deletion
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
