import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:charusat_recruitment/screens/models/institute_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../const.dart';

class StudentDetailsPage extends StatefulWidget {
  const StudentDetailsPage({super.key});

  @override
  _StudentDetailsPageState createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to handle text input
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cgpaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _programmingskillController =
      TextEditingController();
  final TextEditingController _otherskillController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();
  String? _selectedInstitute;
  String? _selectedDepartment;
  String? _selectedYear;
  List<String> _departments = [];
  bool _isLoading = false; // New loading state

  // Function to handle form submission
  void _onInstituteChanged(String? value) {
    setState(() {
      _selectedInstitute = value;
      _departments = institutes
          .firstWhere((institute) => institute.name == value)
          .departments;
      _selectedDepartment = null; // Reset the department when institute changes
    });
  }

  // Function to select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date
      firstDate: DateTime(1900, 1), // Earliest date
      lastDate: DateTime.now(), // Latest date
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _onDepartmentChanged(String? value) {
    setState(() {
      _selectedDepartment = value;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Collect student details from text controllers
      final Map<String, String> studentData = {
        "firstname": _firstnameController.text,
        "lastname": _lastnameController.text,
        "student_id": _studentIdController.text,
        "phone": _phoneController.text,
      };

      try {
        final response = await http.post(
          Uri.parse("$serverurl/submit"),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(studentData),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          print('Submission successful');
          if (mounted) {
            // You can redirect or show a success message here
            Navigator.of(context).popAndPushNamed('/student_detail');
          }
        } else {
          final error =
              jsonDecode(response.body)['error'] ?? 'Unknown error occurred';
          _showErrorDialog(context, error);
        }
      } catch (e) {
        _showErrorDialog(
            context, 'An error occurred. Please try again. ${e.toString()}');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Hide loading indicator
          });
        }
      }
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Color(0xff0f1d2c)),
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xff0f1d2c)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Student Details',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color(0xff0f1d2c),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstnameController,
                        cursorColor:
                            const Color(0xff0f1d2c), // Set the cursor color
                        decoration: const InputDecoration(
                          labelText: 'First Name',
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
                            return 'Please enter the student\'s first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                        width: 16.0), // Add some spacing between the fields
                    Expanded(
                      child: TextFormField(
                        controller: _lastnameController,
                        cursorColor:
                            const Color(0xff0f1d2c), // Set the cursor color
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
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
                            return 'Please enter the student\'s last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _studentIdController,
                        cursorColor:
                            const Color(0xff0f1d2c), // Set the cursor color
                        decoration: const InputDecoration(
                          labelText: 'Student ID',
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
                            return 'Please enter the student ID';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Current Year',
                          labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff0f1d2c)),
                          ),
                        ),
                        value: _selectedYear,
                        items: ['1', '2', '3', '4']
                            .map((year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(year),
                                ))
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedYear = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your current year';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dobController,
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff0f1d2c)),
                          ),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true, // Makes text field read-only
                        onTap: () =>
                            _selectDate(context), // Opens date picker on tap
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your date of birth';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _cgpaController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'CGPA',
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
                            return 'Please enter your CGPA';
                          }
                          final double? cgpa = double.tryParse(value);
                          if (cgpa == null) {
                            return 'Please enter a valid number for CGPA';
                          }
                          if (cgpa < 0 || cgpa > 10) {
                            return 'CGPA should be between 0.0 and 10.0';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _cityController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'City',
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
                      return 'Please enter your City';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _domainController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Domain',
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
                      return 'Please enter your Domain';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _programmingskillController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Programming skills',
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
                      return 'Please enter your City';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _otherskillController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Other skills',
                    labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff0f1d2c)),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Institute',
                    labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff0f1d2c)),
                    ),
                  ),
                  value: _selectedInstitute,
                  items: institutes
                      .map((institute) => DropdownMenuItem(
                            value: institute.name,
                            child: Text(institute.name),
                          ))
                      .toList(),
                  onChanged: _onInstituteChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an institute';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff0f1d2c)),
                    ),
                  ),
                  value: _selectedDepartment,
                  items: _departments
                      .map((department) => DropdownMenuItem(
                            value: department,
                            child: Text(department),
                          ))
                      .toList(),
                  onChanged: _onDepartmentChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a department';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _submitForm, // Submit form on tap
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff0f1d2c),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}