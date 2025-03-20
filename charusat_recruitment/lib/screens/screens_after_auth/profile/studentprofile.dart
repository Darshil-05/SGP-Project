import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/service/common_service/auth_service.dart';
import 'package:charusat_recruitment/service/users/student_service.dart';
import 'package:charusat_recruitment/screens/models/student_model.dart';
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
  
  // State variables
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  
  // Student profile
  late StudentProfile studentProfile;
  late String studentId;
  
  @override
  void initState() {
    super.initState();
    // Get studentId from const.dart
    studentId = studentid;
    // Load student profile
    _loadStudentProfile();
  }
  
  // Load student profile from service
  Future<void> _loadStudentProfile() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    
    try {
      final StudentService studentService = StudentService();
      studentProfile = await studentService.getStudentDetails(context, studentId);
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });
    }
  }

  Widget buildDetailItem(IconData icon, String title, String value, bool editable, 
      {String? subtitle, String? fieldName}) {
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
              // Pass the field name to the edit dialog
              showEditDialog(context, title, value, studentId, fieldName ?? '');
            },
            child: const Icon(Icons.edit, color: Colors.black)),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? _buildErrorView()
              : _buildProfileView(),
    );
  }
  
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text('Failed to load profile: $errorMessage', 
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadStudentProfile,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileView() {
    return SingleChildScrollView(
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
                    studentProfile.firstName.isNotEmpty ? studentProfile.firstName[0] : '',
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  studentProfile.fullName,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "ID : ${studentProfile.idNo.toUpperCase()}",
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
                buildDetailItem(Icons.person_2_rounded, 'First Name', studentProfile.firstName, true, fieldName: 'first_name'),
                buildDetailItem(Icons.person_2_rounded, 'Last Name', studentProfile.lastName, true, fieldName: 'last_name'),
                buildDetailItem(Icons.assignment_ind_rounded, 'ID Number', studentProfile.idNo, false),
                buildDetailItem(Icons.cake, 'Birthdate', _formatDate(studentProfile.birthdate), true, fieldName: 'birthdate'),
                buildDetailItem(Icons.location_on, 'City', studentProfile.city ?? 'Not specified', true, fieldName: 'city'),
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
                buildDetailItem(Icons.school, 'Institute', studentProfile.institute, false),
                buildDetailItem(Icons.school, 'Department', studentProfile.department, false),
                buildDetailItem(Icons.grade, 'CGPA', studentProfile.cgpa.toString(), true, fieldName: 'cgpa'),
                buildDetailItem(Icons.calendar_today, 'Passing Year', studentProfile.passingYear.toString(), true, fieldName: 'passing_year'),
                buildDetailItem(Icons.category, 'Domains', studentProfile.domains, true, fieldName: 'domains'),
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
                buildDetailItem(Icons.code, 'Programming', studentProfile.programmingSkill, true, fieldName: 'programming_skill'),
                buildDetailItem(Icons.build, 'Technical Skills', studentProfile.techSkill, true, fieldName: 'tech_skill'),
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
              children: studentProfile.experience.isEmpty
                  ? [
                      const Center(
                        child: Text('No experience added yet'),
                      )
                    ]
                  : List.generate(
                      studentProfile.experience.length,
                      (index) => buildDetailItem(
                        Icons.work,
                        studentProfile.experience[index],
                        '', // We don't have organization details in the widget
                        false,
                      ),
                    ),
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
              children: studentProfile.certificates.isEmpty
                  ? [
                      const Center(
                        child: Text('No certifications added yet'),
                      )
                    ]
                  : List.generate(
                      studentProfile.certificates.length,
                      (index) => buildDetailItem(
                        Icons.card_membership,
                        studentProfile.certificates[index],
                        '', // We don't have platform details in the widget
                        false,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
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
    );
  }
  
  // Helper method to format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

void showEditDialog(BuildContext context, String title, String value, String studentId, String fieldName) {
  final TextEditingController controller = TextEditingController(text: value);
  final StudentService studentService = StudentService();
  
  // Determine the field type to properly handle different types of data
  bool isNumeric = ['cgpa', 'passing_year'].contains(fieldName);
  bool isDate = fieldName == 'birthdate';
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit $title'),
        content: isDate
            ? _buildDatePickerField(context, controller, value)
            : TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: title,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
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
              dynamic newValue = controller.text;
              
              // Convert value based on field type
              if (fieldName == 'cgpa') {
                newValue = double.tryParse(newValue) ?? 0.0;
              } else if (fieldName == 'passing_year') {
                newValue = int.tryParse(newValue) ?? 0;
              }
              
              // Close the dialog
              Navigator.of(context).pop();
              
              // Call the service to update the field
              bool success = await studentService.updateStudentField(
                context,
                studentId,
                fieldName,
                newValue,
              );
              
              // Show success or error message and refresh the page if update was successful
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title updated successfully')),
                );
                
                // Refresh the page
                if (context.mounted) {
                  // Find the ProfilePage state and reload profile
                  final _ProfilePageState? state = 
                      context.findAncestorStateOfType<_ProfilePageState>();
                  if (state != null) {
                    state._loadStudentProfile();
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}

// Helper widget for date picker
Widget _buildDatePickerField(
    BuildContext context, TextEditingController controller, String initialValue) {
  DateTime? selectedDate;
  
  // Parse the initial date value
  try {
    final parts = initialValue.split('/');
    if (parts.length == 3) {
      selectedDate = DateTime(
        int.parse(parts[2]), // year
        int.parse(parts[1]), // month
        int.parse(parts[0]), // day
      );
    }
  } catch (_) {
    selectedDate = DateTime.now();
  }
  
  controller.text = selectedDate != null
      ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
      : '';
  
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextField(
        controller: controller,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: 'Birthdate',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );
          
          if (picked != null) {
            controller.text = '${picked.day}/${picked.month}/${picked.year}';
          }
        },
        child: const Text('Select Date'),
      ),
    ],
  );
}