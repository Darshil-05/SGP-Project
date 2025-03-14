import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/service/common_service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../../service/users/student_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool personalDetailsVisible = false;
  bool educationDetailsVisible = false;
  bool skillsVisible = false;
  bool experienceVisible = false;
  bool certificationVisible = false;

  // Variables to store user data
  late String userName;
  late String studentId;
  late String phone;
  late String userEmail;
  late String userCity;
  late String userDepartment;
  late String userCgpa;
  late String programmingSkill;
  late String otherSkill;
  late String workExperience;
  late String certification1;
  late String certification2;

  @override
  void initState() {
    super.initState();
    // Initialize with current values
    userName = name;
    studentId = studentid;
    phone = '9876543210';
    userEmail = email;
    userCity = city;
    userDepartment = department;
    userCgpa = cgpa.toString();
    programmingSkill = programmingskill;
    otherSkill = otherskill;
    workExperience = 'Heliumautomation';
    certification1 = 'Flutter Certification';
    certification2 = 'React.js Certification';
  }

  Widget buildDetailItem(IconData icon, String title, String value , bool editable, {String? subtitle}) {
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
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          if(editable) InkWell(
            onTap: (){
              //popup alert box
              showEditDialog(context, title, value , studentId  );
            },
            child: Icon(Icons.edit, color: Colors.black)),
        ],
      ),
    );
  }

  Widget buildDetailCard(
      String title, String? subtitle, bool visible, VoidCallback onTap,
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
          if (subtitle != null) ...[
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
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
                "Profile",
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
                      userName.isNotEmpty ? userName[0] : '',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "ID : ${studentId.toUpperCase()}",
                    style: const TextStyle(fontSize: 18),
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
              null,
              personalDetailsVisible,
              () {
                setState(() {
                  personalDetailsVisible = !personalDetailsVisible;
                });
              },
              content: Column(
                children: [
                  buildDetailItem(Icons.person_2_rounded, 'Name', userName ,true),
                  buildDetailItem(Icons.assignment_ind_rounded, 'ID Number', studentId, false),
                  buildDetailItem(Icons.phone, 'Phone', phone ,true),
                  buildDetailItem(Icons.email, 'Email', userEmail ,true),
                  buildDetailItem(Icons.location_on, 'City', userCity ,true),
                ],
              ),
            ),
            // Educational Information Section
            buildDetailCard(
              'Educational Information',
              null,
              educationDetailsVisible,
              () {
                setState(() {
                  educationDetailsVisible = !educationDetailsVisible;
                });
              },
              content: Column(
                children: [
                  buildDetailItem(Icons.school, 'Degree', userDepartment , false),
                  buildDetailItem(Icons.grade, 'CGPA', userCgpa ,true),
                ],
              ),
            ),
            // Skills Section
            buildDetailCard(
              'Skills',
              null,
              skillsVisible,
              () {
                setState(() {
                  skillsVisible = !skillsVisible;
                });
              },
              content: Column(
                children: [
                  buildDetailItem(Icons.code, 'Programming', programmingSkill ,true),
                  buildDetailItem(Icons.build, 'Other Skill', otherSkill ,true),
                ],
              ),
            ),
            // Experience Section
            buildDetailCard(
              'Experience',
              null,
              experienceVisible,
              () {
                setState(() {
                  experienceVisible = !experienceVisible;
                });
              },
              content: Column(
                children: [
                  buildDetailItem(Icons.work, 'Flutter Developer Intern', workExperience,true,
                      subtitle: 'Helium Automation (2023)'),
                ],
              ),
            ),
            // Certification Section
            buildDetailCard(
              'Certification',
              null,
              certificationVisible,
              () {
                setState(() {
                  certificationVisible = !certificationVisible;
                });
              },
              content: Column(
                children: [
                  buildDetailItem(Icons.card_membership, 'Flutter Certification', certification1,true,
                      subtitle: 'Udemy (2023)',),
                  buildDetailItem(Icons.card_membership, 'React.js Certification', certification2,
                      subtitle: 'Coursera (2022)',true),
                ],
              ),
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

void showEditDialog(BuildContext context, String title, String value, String studentId) {
  final TextEditingController controller = TextEditingController(text: value);
  final StudentService studentService = StudentService();
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Get the new value from controller
              String newValue = controller.text;
              
              // Close the dialog
              Navigator.of(context).pop();
              
              // Call the service to update the field
              bool success = await studentService.updateStudentField(
                context,
                studentId,newValue
              );
              
              // Show success or error message
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title updated successfully')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
  
  // No return value needed
}