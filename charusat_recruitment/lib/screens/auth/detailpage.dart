import 'package:charusat_recruitment/screens/models/institute_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  String? _selectedInstitute;
  String? _selectedDepartment;
  String? _selectedYear;
  List<String> _departments = [];

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Collect student details from text controllers
      String firstname = _firstnameController.text;
      String lastname = _lastnameController.text;
      String studentId = _studentIdController.text;
      String phone = _phoneController.text;

      // You can now use these details for further processing
      print("First Name: $firstname");
      print("Last Name: $lastname");
      print("Student ID: $studentId");
      print("Phone: $phone");

      // Reset form after submission
      _formKey.currentState!.reset();
    }
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
                            return 'Please enter the student\'s name';
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
                          // Check if the value is empty
                          if (value == null || value.isEmpty) {
                            return 'Please enter the mobile number';
                          }
                          final RegExp mobileNumberRegex =
                              RegExp(r'^[6-9]\d{9}$');
                          if (!mobileNumberRegex.hasMatch(value)) {
                            return 'Please enter a valid 10-digit mobile number starting with 6 or above';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
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
                    )
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
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneController,
                  cursorColor: const Color(0xff0f1d2c), // Set the cursor color
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff0f1d2c)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    // Check if the value is empty
                    if (value == null || value.isEmpty) {
                      return 'Please enter the mobile number';
                    }
                    final RegExp mobileNumberRegex = RegExp(r'^[6-9]\d{9}$');
                    if (!mobileNumberRegex.hasMatch(value)) {
                      return 'Please enter a valid 10-digit mobile number starting with 6 or above';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Institute',
                    labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff0f1d2c)),
                    ),
                  ),
                  value: _selectedInstitute,
                  items: institutes.map((Institute institute) {
                    return DropdownMenuItem<String>(
                      value: institute.name,
                      child: Text(institute.name),
                    );
                  }).toList(),
                  onChanged: _onInstituteChanged,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Department',
                    labelStyle: TextStyle(color: Color(0xff0f1d2c)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff0f1d2c)),
                    ),
                  ),
                  value: _selectedDepartment,
                  items: _departments.map((String department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                  onChanged: _onDepartmentChanged,
                  disabledHint: const Text('Select Institute first'),
                ),
                GestureDetector(
                  onTap: (){
                    
                  },
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.07,
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    decoration: BoxDecoration(
                      color: const Color(0xff0f1d2c),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: -3,
                          offset: const Offset(3, 3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          letterSpacing: 3,
                        ),
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

  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    _firstnameController.dispose();
    _lastnameController.dispose();
    _studentIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
