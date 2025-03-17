import 'package:charusat_recruitment/service/users/faculty_service.dart';
import 'package:charusat_recruitment/screens/models/institute_model.dart';
import 'package:flutter/material.dart';


class FacultyDetailsPage extends StatefulWidget {
  const FacultyDetailsPage({super.key});

  @override
  _FacultyDetailsPageState createState() => _FacultyDetailsPageState();
}

class _FacultyDetailsPageState extends State<FacultyDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to handle text input
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _facultyIdController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  
  String? _selectedInstitute;
  String? _selectedDepartment;
  List<String> _departments = [];
  bool _isLoading = false;

  // Function to handle institute changes
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
      firstDate: DateTime(1940, 1), // Earliest date
      lastDate: DateTime.now(), // Latest date
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        debugPrint(_dobController.text);
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
        _isLoading = true;
      });
      
      try {
        final facultyService = FacultyService();
        
        // Collect faculty details from text controllers
        final Map<String, String> facultyData = {
          "id_no": _facultyIdController.text,
          "first_name": _firstnameController.text,
          "birthdate": _dobController.text,
          "institute": _selectedInstitute!,
          "department": _selectedDepartment!,
          "role": "faculty"
        };

        bool success = await facultyService.addFaculty(context, facultyData);
        if (!success) {
          _showErrorDialog(context, "Failed to add faculty. Please try again.");
        }
      } catch (e) {
        _showErrorDialog(context, "An error occurred: ${e.toString()}");
      } finally {
        setState(() {
          _isLoading = false;
        });
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
          'Faculty Details',
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
                TextFormField(
                  controller: _firstnameController,
                  cursorColor: const Color(0xff0f1d2c),
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
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
                      return 'Please enter the faculty\'s full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _facultyIdController,
                        cursorColor: const Color(0xff0f1d2c),
                        decoration: const InputDecoration(
                          labelText: 'Faculty ID',
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
                            return 'Please enter the faculty ID';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
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
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select date of birth';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
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
                const SizedBox(height: 24.0),
                GestureDetector(
                  onTap: _isLoading ? null : _submitForm,
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: const Color(0xff0f1d2c),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Center(
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