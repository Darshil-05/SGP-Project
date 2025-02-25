import 'dart:convert';
import 'package:charusat_recruitment/screens/models/company_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:charusat_recruitment/const.dart';

class CompanyService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Future<Map<String, List<Map<String, String>>>> getCompanies() async {
    var url = Uri.parse('$serverurl/company/company/company-info/');
    var response = await http.get(url);

    List<Map<String, String>> upcomingCompanies = [];
    List<Map<String, String>> recentCompanies = [];
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);

      for (var company in jsonData) {
        String companyDateStr = company['date_placementdrive'].toString();
        DateTime companyDate = DateTime.parse(companyDateStr);
        DateTime currentDate = DateTime.now();
        Map<String, String> companyDetails = {
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
    } else {
      throw Exception("Failed to load companies");
    }

    return {
      'upcoming': upcomingCompanies,
      'recent': recentCompanies,
    };
  }

Future<bool> addCompany(CompanyModel company) async {
    print("Calling addCompany... ${company.companyName}");

    try {
      // Retrieve JWT token
      String? accessToken = await _storage.read(key: 'access_token');
      if (accessToken == null) {
        print("Error: No access token found.");
        return false;
      }

      // Set up request headers
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // Attach JWT token
      };

      // Create request
      var request = http.Request(
        'POST',
        Uri.parse('$serverurl/company/companies/'),
      );

      // Set request body
      request.body = json.encode({
        "company_name": company.companyName, // Fixed typo from "comapny_name"
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
        print("Failed to add company: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("Error adding company: $e");
      return false;
    }
  }
}
