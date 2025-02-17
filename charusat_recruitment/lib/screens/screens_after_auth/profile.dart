import 'package:charusat_recruitment/const.dart';
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

  Widget buildDetailItem(IconData icon, String title, String value) {
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
                Text(title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 3),
                Text(value, style: const TextStyle(fontSize: 16)),
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
              child:  Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 49, 62, 99),
                    radius: 50,
                    child: Text(
                      name.isNotEmpty ? name[0] : '',  
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "ID : ${studentid.toUpperCase()}",
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
                  buildDetailItem(Icons.person_2_rounded, 'Name',
                      name),
                  buildDetailItem(
                      Icons.assignment_ind_rounded, 'ID Number', studentid.toUpperCase()),
                  buildDetailItem(Icons.phone, 'Phone', '9876543210'),
                  buildDetailItem(
                      Icons.email, 'Email', email),
                  buildDetailItem(
                      Icons.location_on, 'City', city),
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
                  buildDetailItem(Icons.school, 'Degree', department),
                  buildDetailItem(Icons.grade, 'CGPA', '$cgpa / 10'),
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
                  buildDetailItem(Icons.code, 'Programming',
                      programmingskill),
                  buildDetailItem(Icons.build, 'Other Skill',
                      otherskill),
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
                  buildDetailItem(Icons.work, 'Flutter Developer Intern',
                      'Helium Automation (2023)'),
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
                  buildDetailItem(Icons.card_membership,
                      'Flutter Certification', 'Udemy (2023)'),
                  buildDetailItem(Icons.card_membership,
                      'React.js Certification', 'Coursera (2022)'),
                ],
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width -20,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color(0xff0f1d2c),
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: const Text("Log Out" , style: TextStyle(color: Colors.white),) ,
            )
          ],
        ),
      ),
    );
  }
}
