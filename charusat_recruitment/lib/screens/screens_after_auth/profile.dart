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
              child: const Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 49, 62, 99),
                    radius: 50,
                    child: Text(
                      "DP",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Darshil Patel",
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "ID : 22IT092",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
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
                  buildDetailItem(Icons.person_2_rounded, 'Full Name',
                      'Patel Darshil Pankajbhai'),
                  buildDetailItem(
                      Icons.assignment_ind_rounded, 'ID Number', '22IT092'),
                  buildDetailItem(Icons.phone, 'Phone', '9574257200'),
                  buildDetailItem(
                      Icons.email, 'Email', 'darshilpatel5505@gmail.com'),
                  buildDetailItem(
                      Icons.location_on, 'City', 'Mahesana , Gujarat'),
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
                  buildDetailItem(Icons.school, 'Degree', 'B.Tech in IT'),
                  buildDetailItem(Icons.calendar_today, 'Year', '2020 - 2024'),
                  buildDetailItem(Icons.grade, 'CGPA', '8.5 / 10'),
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
                      'Flutter, Dart, Python, React.js'),
                  buildDetailItem(Icons.build, 'Technologies',
                      'Firebase, Git, MongoDB, Node.js'),
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
                  buildDetailItem(Icons.work, 'React.js Developer Intern',
                      'Sparks to Idea (2023)'),
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
          ],
        ),
      ),
    );
  }
}