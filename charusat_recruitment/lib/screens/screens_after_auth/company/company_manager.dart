import 'package:flutter/material.dart';

class CompanyManager extends StatefulWidget {
  const CompanyManager({super.key});

  @override
  State<CompanyManager> createState() => _CompanyManagerState();
}

class _CompanyManagerState extends State<CompanyManager> {
  final _formKey = GlobalKey<FormState>();

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
  final TextEditingController _processStagesController = TextEditingController();
  final TextEditingController _eligibilityCriteriaController = TextEditingController();
  final TextEditingController _noRoundController = TextEditingController();
  final TextEditingController _cutoffMarksController = TextEditingController();
  final TextEditingController _selectionRatioController = TextEditingController();
  final TextEditingController _durationInternshipController = TextEditingController();
  final TextEditingController _stipendController = TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _jobLocationController = TextEditingController();
  final TextEditingController _jobSalaryController = TextEditingController();
  final TextEditingController _jobTypeController = TextEditingController();
  final TextEditingController _minPackageController = TextEditingController();
  final TextEditingController _maxPackageController = TextEditingController();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Company Name', _companyNameController),
              _buildTextField('Company Website', _companyWebsiteController),
              _buildTextField('Headquarters', _headquartersController),
              _buildTextField('Industry', _industryController),
              _buildTextField('Details', _detailsController),
              _buildTextField('Date of Placement Drive', _datePlacementDriveController),
              _buildTextField('Application Deadline', _applicationDeadlineController),
              _buildTextField('Joining Date', _joiningDateController),
              _buildTextField('HR Name', _hrNameController),
              _buildTextField('HR Email', _hrEmailController),
              _buildTextField('HR Contact', _hrContactController),
              _buildTextField('Benefits', _benefitsController),
              _buildTextField('Documents Required', _docRequiredController),
              _buildTextField('Process Stages', _processStagesController),
              _buildTextField('Eligibility Criteria', _eligibilityCriteriaController),
              _buildTextField('Number of Rounds', _noRoundController),
              _buildTextField('Cutoff Marks', _cutoffMarksController),
              _buildTextField('Selection Ratio', _selectionRatioController),
              _buildTextField('Duration of Internship', _durationInternshipController),
              _buildTextField('Stipend', _stipendController),
              _buildTextField('Job Role', _jobRoleController),
              _buildTextField('Job Description', _jobDescriptionController),
              _buildTextField('Skills', _skillsController),
              _buildTextField('Job Location', _jobLocationController),
              _buildTextField('Job Salary', _jobSalaryController),
              _buildTextField('Job Type', _jobTypeController),
              _buildTextField('Minimum Package', _minPackageController),
              _buildTextField('Maximum Package', _maxPackageController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission here
                  }
                },
                child: const Text('Submit'),
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
                        prefixIcon: const Icon(Icons.person, color: Color(0xff0f1d2c)),
                        labelText: label,
                        labelStyle: const TextStyle(color: Color(0xff0f1d2c)),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff0f1d2c)),
                        ),
                        
                      ),
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
    _processStagesController.dispose();
    _eligibilityCriteriaController.dispose();
    _noRoundController.dispose();
    _cutoffMarksController.dispose();
    _selectionRatioController.dispose();
    _durationInternshipController.dispose();
    _stipendController.dispose();
    _jobRoleController.dispose();
    _jobDescriptionController.dispose();
    _skillsController.dispose();
    _jobLocationController.dispose();
    _jobSalaryController.dispose();
    _jobTypeController.dispose();
    _minPackageController.dispose();
    _maxPackageController.dispose();
    super.dispose();
  }
}
