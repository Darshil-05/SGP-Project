import 'dart:convert';
import 'package:charusat_recruitment/screens/models/company_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:charusat_recruitment/const.dart';

class CompanyService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, List<Map<String, String>>>> getCompanies(BuildContext context) async {
    try {
      var url = Uri.parse('$serverurl/company/company/company-info/');
      var response = await http.get(url).timeout(const Duration(seconds: 10));

      List<Map<String, String>> upcomingCompanies = [];
      List<Map<String, String>> recentCompanies = [];

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);

        for (var company in jsonData) {
          String companyDateStr = company['date_placementdrive'].toString();
          DateTime companyDate = DateTime.parse(companyDateStr);
          DateTime currentDate = DateTime.now();

          Map<String, String> companyDetails = {
            'id': company['id'].toString(),
            'name': company['company_name'],
            'date': companyDateStr,
            'location': company['job_location'],
            'description': company['job_description'],
            'image': serverurl + company['image_url']
          };

          if (companyDate.isAfter(currentDate)) {
            upcomingCompanies.add(companyDetails);
          } else {
            recentCompanies.add(companyDetails);
          }
        }

        return {
          'upcoming': upcomingCompanies,
          'recent': recentCompanies,
        };

      } else {
        _showErrorDialog(context, "Failed to load companies", response.statusCode);
        return {
          'upcoming': [],
          'recent': [],
        };
      }
    } catch (e) {
      _showErrorDialog(context, "Error fetching companies: $e", null);
      return {
        'upcoming': [],
        'recent': [],
      };
    }
  }

  Future<bool> addCompany(BuildContext context, CompanyModel company) async {
    print("Calling addCompany... ${company.companyName}");

    try {
      // Retrieve JWT token
      String? accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        _showErrorDialog(context, "Error: No access token found", null);
        return false;
      }

      // Set up request headers
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      // Create request
      var request = http.Request(
        'POST',
        Uri.parse('$serverurl/company/companies/'),
      );

      // Set request body
      request.body = json.encode({
        "company_name": company.companyName,
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

      // Attach headers
      request.headers.addAll(headers);

      // Send request
      http.StreamedResponse streamedResponse =
          await request.send().timeout(const Duration(seconds: 10));

      // Convert streamed response to standard response
      final response = await http.Response.fromStream(streamedResponse);

      print("Request finished ${response.body} ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Company added successfully");
        return true;
      } else {
        _showErrorDialog(context, "Failed to add company", response.statusCode);
        return false;
      }
    } catch (e) {
      _showErrorDialog(context, "Error adding company: $e", null);
      return false;
    }
  }

  void _showErrorDialog(BuildContext context, String message, int? statusCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(statusCode != null ? "$message\nStatus Code: $statusCode" : message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
