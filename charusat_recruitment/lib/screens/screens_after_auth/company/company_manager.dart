import 'package:charusat_recruitment/const.dart';
import 'package:flutter/material.dart';
import 'package:charusat_recruitment/Providers/company_provider.dart';
import 'package:charusat_recruitment/screens/models/company_model.dart';
import 'package:intl/intl.dart';

import '../../../service/company_service/company_service.dart';

class CompanyManager extends StatefulWidget {
  const CompanyManager({super.key});

  @override
  State<CompanyManager> createState() => _CompanyManagerState();
}

class _CompanyManagerState extends State<CompanyManager> {
  final _formKey = GlobalKey<FormState>();
  final CompanyService _companyService = CompanyService();
  
  // Controllers for each field
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyWebsiteController = TextEditingController();
  final TextEditingController _headquartersController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _datePlacementDriveController = TextEditingController();
  final TextEditingController _applicationDeadlineController = TextEditingController();
  final TextEditingController _joiningDateController = TextEditingController();
  final TextEditingController _hrNameController = TextEditingController();
  final TextEditingController _hrEmailController = TextEditingController();
  final TextEditingController _hrContactController = TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();
  final TextEditingController _docRequiredController = TextEditingController();
  final TextEditingController _eligibilityCriteriaController = TextEditingController();
  final TextEditingController _noRoundController = TextEditingController();
  final TextEditingController _durationInternshipController = TextEditingController();
  final TextEditingController _stipendController = TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();
  final TextEditingController _jobSalaryController = TextEditingController();
  final TextEditingController _minPackageController = TextEditingController();
  final TextEditingController _maxPackageController = TextEditingController();

  // Helper method to pick a date
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitCompany() async {
    if (_formKey.currentState!.validate()) {
      // Create the CompanyModel with empty interview rounds
      // The rounds will be added in the RoundManager screen
      final company = CompanyModel(
        company_id: 0, // This will be assigned by the server
        companyName: _companyNameController.text,
        companyWebsite: _companyWebsiteController.text,
        headquarters: _headquartersController.text,
        industry: _industryController.text,
        details: _detailsController.text,
        datePlacementDrive: _datePlacementDriveController.text,
        applicationDeadline: _applicationDeadlineController.text,
        joiningDate: _joiningDateController.text,
        hrName: _hrNameController.text,
        hrEmail: _hrEmailController.text,
        hrContact: _hrContactController.text,
        bond: int.tryParse(_noRoundController.text) ?? 0,
        benefits: _benefitsController.text,
        docRequired: _docRequiredController.text,
        eligibilityCriteria: _eligibilityCriteriaController.text,
        interviewRounds: [], // Empty list - will be filled in RoundManager
        durationInternship: _durationInternshipController.text,
        stipend: _stipendController.text,
        jobRole: _jobRoleController.text,
        jobDescription: _jobDescriptionController.text,
        skills: _skillsController.text,
        jobLocation: _jobLocationController.text,
        jobSalary: _jobSalaryController.text,
        jobType: "Full-time", // Default value
        minPackage: int.tryParse(_minPackageController.text) ?? 0,
        maxPackage: int.tryParse(_maxPackageController.text) ?? 0,
      );

      // Navigate to RoundManager and pass the company data
      Navigator.of(context).pushNamed('/round', arguments: company);
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
                onTap: () => _selectDate(context, _datePlacementDriveController),
                child: IgnorePointer(
                  child: _buildTextField(
                    'Date of Placement Drive',
                    _datePlacementDriveController,
                  ),
                ),
              ),

              // Application Deadline with Date Picker
              InkWell(
                onTap: () => _selectDate(context, _applicationDeadlineController),
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
              _buildTextField('Documents Required', _docRequiredController),
              _buildTextField('Eligibility Criteria', _eligibilityCriteriaController),
              _buildTextField('Bond Period (months)', _noRoundController),
              _buildTextField('Duration of Internship', _durationInternshipController),
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
                onTap: _submitCompany,
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: const BoxDecoration(
                    color: Color(0xff0f1d2c),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
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