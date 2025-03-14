import 'package:charusat_recruitment/screens/models/faculty_model.dart';
import 'package:flutter/material.dart';
import 'package:charusat_recruitment/service/common_service/auth_service.dart';

class FacultyProfilePage extends StatefulWidget {
  final Faculty faculty;
  
  const FacultyProfilePage({super.key, required this.faculty});

  @override
  State<FacultyProfilePage> createState() => _FacultyProfilePageState();
}

class _FacultyProfilePageState extends State<FacultyProfilePage> {
  bool personalDetailsVisible = false;
  bool departmentDetailsVisible = false;
  bool editable = false;

  // Controllers for editable fields - only for Faculty model properties
  TextEditingController firstnameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController instituteController = TextEditingController();
  TextEditingController departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    firstnameController.text = widget.faculty.firstname;
    birthdateController.text = widget.faculty.birthdate;
    instituteController.text = widget.faculty.institute;
    departmentController.text = widget.faculty.department;
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    firstnameController.dispose();
    birthdateController.dispose();
    instituteController.dispose();
    departmentController.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
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
                  const SizedBox(
                    height: 8,
                  ),
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
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    firstnameController.text,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
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
                      Icons.cake, 'Date of Birth', birthdateController),
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
            InkWell(
              onTap: () {
                // Save the updated values
                setState(() {
                  editable = !editable;
                });
                print(editable ? "Done editing" : "Started editing mode");
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width - 17,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                    color: Color(0xff0f1d2c),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                    child: Text(
                  editable ? 'Save' : 'Edit Profile',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                AuthenticationService authService = AuthenticationService();
                await authService.logout();
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
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}