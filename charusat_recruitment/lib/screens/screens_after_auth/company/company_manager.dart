import 'dart:convert';

import 'package:charusat_recruitment/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charusat_recruitment/Providers/company_provider.dart';
import 'package:charusat_recruitment/screens/models/company_model.dart';
import 'package:intl/intl.dart'; // To format the date
import 'package:http/http.dart' as http;
class CompanyManager extends StatefulWidget {
  const CompanyManager({super.key});

  @override
  State<CompanyManager> createState() => _CompanyManagerState();
}

class _CompanyManagerState extends State<CompanyManager> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each field
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyWebsiteController =
      TextEditingController();
  final TextEditingController _headquartersController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _datePlacementDriveController =
      TextEditingController();
  final TextEditingController _applicationDeadlineController =
      TextEditingController();
  final TextEditingController _joiningDateController = TextEditingController();
  final TextEditingController _hrNameController = TextEditingController();
  final TextEditingController _hrEmailController = TextEditingController();
  final TextEditingController _hrContactController = TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();
  final TextEditingController _docRequiredController = TextEditingController();
  final TextEditingController _eligibilityCriteriaController =
      TextEditingController();
  final TextEditingController _noRoundController = TextEditingController();
  final TextEditingController _durationInternshipController =
      TextEditingController();
  final TextEditingController _stipendController = TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();
  final TextEditingController _jobSalaryController = TextEditingController();
  final TextEditingController _minPackageController = TextEditingController();
  final TextEditingController _maxPackageController = TextEditingController();

  // Helper method to pick a date
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd')
            .format(picked); // Update the controller's text
      });
    }
  }
  void addCompany(CompanyModel company) async {
      print("Calling addCompany... ${company.companyName}");


    var request = http.Request(
      'POST',
      Uri.parse('$serverurl/company/companies/'),
    );


    request.body = json.encode({
      "comapny_name": company.companyName,
      "company_website": company.companyWebsite,
      "headquarters": company.headquarters,
      "industry": company.industry,
      "details": company.details,
      "date_placementdrive": company.datePlacementDrive,
      "application_deadline": company.applicationDeadline,
      "joining_date": company.joiningDate,
      "hr_name": company.hrName,
      "hr_email": company.hrEmail,
      "hr_contact": company.hrContact,
      "bond": company.bond,
      "benefits": company.benefits,
      "eligibility_criteria": company.eligibilityCriteria,
      "no_round": company.noRounds,
      "duration_internship": company.durationInternship,
      "stipend": company.stipend,
      "job_role": company.jobRole,
      "job_description": company.jobDescription,
      "skills": company.skills,
      "job_location": company.jobLocation,
      "job_salary": company.jobSalary,
      "job_type": company.jobType,
      "min_package": company.minPackage,
      "max_package": company.maxPackage,
    });
     request.headers.addAll({
      'Content-Type': 'application/json',
    });
 

    try {
       http.StreamedResponse streamedResponse =
          await request.send().timeout(const Duration(seconds: 10));

      // Convert streamed response to regular response
      final response = await http.Response.fromStream(streamedResponse);

      print("Request finished  ${response.body} ${response.statusCode}");


      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Company added successfully");
        Navigator.of(context).pop();
      } else {
        print("Failed to add company: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error adding company: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Manager'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTextField('Company Name', _companyNameController),
              _buildTextField('Company Website', _companyWebsiteController),
              _buildTextField('Headquarters', _headquartersController),
              _buildTextField('Industry', _industryController),
              _buildTextField('Details', _detailsController),

              // Date of Placement Drive with Date Picker
              InkWell(
                onTap: () =>
                    _selectDate(context, _datePlacementDriveController),
                child: IgnorePointer(
                  child: _buildTextField(
                    'Date of Placement Drive',
                    _datePlacementDriveController,
                  ),
                ),
              ),

              // Application Deadline with Date Picker
              InkWell(
                onTap: () =>
                    _selectDate(context, _applicationDeadlineController),
                child: IgnorePointer(
                  child: _buildTextField(
                    'Application Deadline',
                    _applicationDeadlineController,
                  ),
                ),
              ),

              // Joining Date with Date Picker
              InkWell(
                onTap: () => _selectDate(context, _joiningDateController),
                child: IgnorePointer(
                  child: _buildTextField(
                    'Joining Date',
                    _joiningDateController,
                  ),
                ),
              ),

              _buildTextField('HR Name', _hrNameController),
              _buildTextField('HR Email', _hrEmailController),
              _buildTextField('HR Contact', _hrContactController),
              _buildTextField('Benefits', _benefitsController),
              _buildTextField(
                  'Eligibility Criteria', _eligibilityCriteriaController),
              _buildTextField('Number of Rounds', _noRoundController),
              _buildTextField(
                  'Duration of Internship', _durationInternshipController),
              _buildTextField('Stipend', _stipendController),
              _buildTextField('Job Role', _jobRoleController),
              _buildTextField('Job Description', _jobDescriptionController),
              _buildTextField('Skills', _skillsController),
              _buildTextField('Job Location', _jobLocationController),
              _buildTextField('Job Salary', _jobSalaryController),
              _buildTextField('Minimum Package', _minPackageController),
              _buildTextField('Maximum Package', _maxPackageController),

              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    addCompany(
                      CompanyModel(
                        companyName: _companyNameController.text,
                        companyWebsite: _companyWebsiteController.text,
                        headquarters: _headquartersController.text,
                        industry: _industryController.text,
                        details: _detailsController.text,
                        datePlacementDrive: _datePlacementDriveController.text,
                        applicationDeadline:
                            _applicationDeadlineController.text,
                        joiningDate: _joiningDateController.text,
                        hrName: _hrNameController.text,
                        hrEmail: _hrEmailController.text,
                        hrContact: _hrContactController.text,
                        bond: 2,
                        benefits: _benefitsController.text,
                        eligibilityCriteria:
                            _eligibilityCriteriaController.text,
                        noRounds: _noRoundController.text,
                        durationInternship: _durationInternshipController.text,
                        stipend: _stipendController.text,
                        jobRole: _jobRoleController.text,
                        jobDescription: _jobDescriptionController.text,
                        skills: _skillsController.text,
                        jobLocation: _jobLocationController.text,
                        jobSalary: _jobSalaryController.text,
                        jobType: "Full-time",
                        minPackage: int.parse(_minPackageController.text),
                        maxPackage: int.parse(_maxPackageController.text),
                      ),
                    );

                  }
                },
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: const BoxDecoration(
                    color: Color(0xff0f1d2c),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a text field
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xff0f1d2c)),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff0f1d2c)),
          ),
        ),
        cursorColor: const Color(0xff0f1d2c),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed
    _companyNameController.dispose();
    _companyWebsiteController.dispose();
    _headquartersController.dispose();
    _industryController.dispose();
    _detailsController.dispose();
    _datePlacementDriveController.dispose();
    _applicationDeadlineController.dispose();
    _joiningDateController.dispose();
    _hrNameController.dispose();
    _hrEmailController.dispose();
    _hrContactController.dispose();
    _benefitsController.dispose();
    _docRequiredController.dispose();
    _eligibilityCriteriaController.dispose();
    _noRoundController.dispose();
    _durationInternshipController.dispose();
    _stipendController.dispose();
    _jobRoleController.dispose();
    _jobDescriptionController.dispose();
    _skillsController.dispose();
    _jobLocationController.dispose();
    _jobSalaryController.dispose();
    _minPackageController.dispose();
    _maxPackageController.dispose();
    super.dispose();
  }
}
