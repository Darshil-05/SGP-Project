import 'package:flutter/material.dart';
import 'package:charusat_recruitment/screens/models/faculty_model.dart';
import 'package:charusat_recruitment/service/common_service/auth_service.dart';

import '../../../service/users/faculty_service.dart';

class FacultyProfilePage extends StatefulWidget {
  const FacultyProfilePage({super.key});

  @override
  State<FacultyProfilePage> createState() => _FacultyProfilePageState();
}

class _FacultyProfilePageState extends State<FacultyProfilePage> {
  bool personalDetailsVisible = false;
  bool departmentDetailsVisible = false;
  bool editable = false;
  bool _isLoading = true;
  FacultyProfile? _facultyProfile;

  // Services
  final FacultyService _facultyService = FacultyService();
  final AuthenticationService _authService = AuthenticationService();

  // Controllers for editable fields
  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController instituteController;
  late TextEditingController departmentController;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    firstnameController = TextEditingController();
    lastnameController = TextEditingController();
    instituteController = TextEditingController();
    departmentController = TextEditingController();

    // Fetch faculty details
    _fetchFacultyDetails();
  }

  // Fetch faculty details
  Future<void> _fetchFacultyDetails() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FacultyProfile facultyProfile = await _facultyService.getFacultyDetails(context);
      
      setState(() {
        _facultyProfile = facultyProfile;
        
        // Update controllers with fetched data
        firstnameController.text = facultyProfile.firstName;
        lastnameController.text = facultyProfile.lastName;
        instituteController.text = facultyProfile.institute;
        departmentController.text = facultyProfile.department;
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error - show snackbar or dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load faculty details: $e')),
      );
    }
  }

  // Save profile changes
  Future<void> _saveProfile() async {
    if (_facultyProfile == null) return;

    // Create an updated faculty profile
    FacultyProfile updatedProfile = FacultyProfile(
      id: _facultyProfile!.id,
      facultyId: _facultyProfile!.facultyId,
      firstName: firstnameController.text,
      lastName: lastnameController.text,
      institute: instituteController.text,
      department: departmentController.text,
    );

    try {
      bool success = await _facultyService.updateFacultyProfile(context, updatedProfile);
      
      if (success) {
        setState(() {
          editable = false;
          _facultyProfile = updatedProfile;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  Widget buildEditableDetailItem(
      IconData icon, String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 3),
                TextField(
                  enabled: editable,
                  controller: controller,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailCard(
      String title, bool visible, VoidCallback onTap,
      {Widget? content}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(
                  visible
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_right_rounded,
                ),
              ],
            ),
          ),
          if (content != null && visible) ...[
            const SizedBox(height: 10),
            content,
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _facultyProfile == null
          ? const Center(child: Text('Failed to load faculty profile'))
          : SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 25,
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 80.0),
                    child: Text(
                      "Faculty Profile",
                      style: TextStyle(fontSize: 25, fontFamily: "pop"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 49, 62, 99),
                          radius: 50,
                          child: Text(
                            firstnameController.text.isNotEmpty
                                ? firstnameController.text[0]
                                : '',
                            style: const TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${firstnameController.text} ${lastnameController.text}',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Personal Details Section
                  buildDetailCard(
                    'Personal Details',
                    personalDetailsVisible,
                    () {
                      setState(() {
                        personalDetailsVisible = !personalDetailsVisible;
                      });
                    },
                    content: Column(
                      children: [
                        buildEditableDetailItem(
                            Icons.person, 'First Name', firstnameController),
                        buildEditableDetailItem(
                            Icons.person_outline, 'Last Name', lastnameController),
                      ],
                    ),
                  ),
                  // Department Information Section
                  buildDetailCard(
                    'Department Information',
                    departmentDetailsVisible,
                    () {
                      setState(() {
                        departmentDetailsVisible = !departmentDetailsVisible;
                      });
                    },
                    content: Column(
                      children: [
                        buildEditableDetailItem(
                            Icons.business, 'Institute', instituteController),
                        buildEditableDetailItem(
                            Icons.school, 'Department', departmentController),
                      ],
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       if (editable) {
                  //         _saveProfile();
                  //       } else {
                  //         editable = true;
                  //       }
                  //     });
                  //   },
                  //   child: Container(
                  //     width: MediaQuery.sizeOf(context).width - 17,
                  //     padding: const EdgeInsets.all(8),
                  //     margin: const EdgeInsets.only(left: 8),
                  //     decoration: const BoxDecoration(
                  //         color: Color(0xff0f1d2c),
                  //         borderRadius: BorderRadius.all(Radius.circular(10))),
                  //     child: Center(
                  //         child: Text(
                  //       editable ? 'Save' : 'Edit Profile',
                  //       style: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 23,
                  //           fontWeight: FontWeight.bold),
                  //     )),
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      await _authService.logout();
                      if (mounted) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      }
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width - 17,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(left: 8),
                      decoration: const BoxDecoration(
                          color: Color(0xff0f1d2c),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Center(
                          child: Text(
                        "Log Out",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  const SizedBox(height: 40)
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    firstnameController.dispose();
    lastnameController.dispose();
    instituteController.dispose();
    departmentController.dispose();
    super.dispose();
  }
}