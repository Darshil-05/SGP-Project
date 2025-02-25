import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/service/auth_service.dart';
import 'package:flutter/material.dart';

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
  bool editable = false;

  // Controllers for editable fields
  TextEditingController nameController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController cgpaController = TextEditingController();
  TextEditingController programmingSkillController = TextEditingController();
  TextEditingController otherSkillController = TextEditingController();
  TextEditingController workController = TextEditingController();
  TextEditingController certificateController = TextEditingController();
  TextEditingController certificate2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    nameController.text = name;
    studentIdController.text = studentid;
    phoneController.text = '9876543210';
    emailController.text = email;
    cityController.text = city;
    departmentController.text = department;
    cgpaController.text = cgpa.toString();
    programmingSkillController.text = programmingskill;
    otherSkillController.text = otherskill;
    otherSkillController.text = otherskill;
    workController.text = 'Heliumautomation';
    certificateController.text = 'Flutter Certification';
    certificate2Controller.text = 'React.js Certification';
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    nameController.dispose();
    studentIdController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    departmentController.dispose();
    cgpaController.dispose();
    programmingSkillController.dispose();
    otherSkillController.dispose();
    certificate2Controller.dispose();
    certificateController.dispose();
    workController.dispose();
    super.dispose();
  }

  Widget buildEditableDetailItem(
      IconData icon, String title, TextEditingController controller,
      {String? subtitle} // Optional subtitle parameter
      ) {
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
                      nameController.text.isNotEmpty
                          ? nameController.text[0]
                          : '',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    nameController.text,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "ID : ${studentIdController.text.toUpperCase()}",
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
                  buildEditableDetailItem(
                      Icons.person_2_rounded, 'Name', nameController),
                  buildEditableDetailItem(Icons.assignment_ind_rounded,
                      'ID Number', studentIdController),
                  buildEditableDetailItem(
                      Icons.phone, 'Phone', phoneController),
                  buildEditableDetailItem(
                      Icons.email, 'Email', emailController),
                  buildEditableDetailItem(
                      Icons.location_on, 'City', cityController),
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
                  buildEditableDetailItem(
                      Icons.school, 'Degree', departmentController),
                  buildEditableDetailItem(Icons.grade, 'CGPA', cgpaController),
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
                  buildEditableDetailItem(
                      Icons.code, 'Programming', programmingSkillController),
                  buildEditableDetailItem(
                      Icons.build, 'Other Skill', otherSkillController),
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
                  buildEditableDetailItem(
                      Icons.work, 'Flutter Developer Intern', workController,
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
                  buildEditableDetailItem(Icons.card_membership,
                      'Flutter Certification', certificateController,
                      subtitle: 'Udemy (2023)'),
                  buildEditableDetailItem(Icons.card_membership,
                      'React.js Certification', certificate2Controller,
                      subtitle: 'Coursera (2022)'),
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
                  style: TextStyle(
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
