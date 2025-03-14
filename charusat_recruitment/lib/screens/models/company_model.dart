

import 'company_round_model.dart';

class CompanyModel {
  final int company_id;
  final String companyName;
  final String companyWebsite;
  final String headquarters;
  final String industry;
  final String details;
  final String datePlacementDrive;
  final String applicationDeadline;
  final String joiningDate;
  final String hrName;
  final String hrEmail;
  final String hrContact;
  final int bond;
  final String benefits;
  final String? docRequired; // Added this field to match API response
  final String eligibilityCriteria;
  final List<CompanyRound> interviewRounds; // Changed from noRounds to match API response
  final String durationInternship;
  final String stipend;
  final String jobRole;
  final String jobDescription;
  final String skills;
  final String jobLocation;
  final String jobSalary;
  final String jobType;
  final int minPackage;
  final int maxPackage;

  CompanyModel({
    required this.company_id,
    required this.companyName,
    required this.companyWebsite,
    required this.headquarters,
    required this.industry,
    required this.details,
    required this.datePlacementDrive,
    required this.applicationDeadline,
    required this.joiningDate,
    required this.hrName,
    required this.hrEmail,
    required this.hrContact,
    required this.bond,
    required this.benefits,
    this.docRequired,
    required this.eligibilityCriteria,
    required this.interviewRounds,
    required this.durationInternship,
    required this.stipend,
    required this.jobRole,
    required this.jobDescription,
    required this.skills,
    required this.jobLocation,
    required this.jobSalary,
    required this.jobType,
    required this.minPackage,
    required this.maxPackage,
  });

  // Factory constructor to create model from API response
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    List<CompanyRound> rounds = [];
    if (json['interview_rounds'] != null) {
      rounds = (json['interview_rounds'] as List)
          .map((round) => CompanyRound.fromJson(round))
          .toList();
    }

    return CompanyModel(
      company_id: json['company_id'] ?? 0,
      companyName: json['company_name'] ?? '',
      companyWebsite: json['company_website'] ?? '',
      headquarters: json['headquarters'] ?? '',
      industry: json['industry'] ?? '',
      details: json['details'] ?? '',
      datePlacementDrive: json['date_placementdrive'] ?? '',
      applicationDeadline: json['application_deadline'] ?? '',
      joiningDate: json['joining_date'] ?? '',
      hrName: json['hr_name'] ?? '',
      hrEmail: json['hr_email'] ?? '',
      hrContact: json['hr_contact'] ?? '',
      bond: json['bond'] is int ? json['bond'] : 0,
      benefits: json['benefits'] ?? '',
      docRequired: json['doc_required'],
      eligibilityCriteria: json['eligibility_criteria'] ?? '',
      interviewRounds: rounds,
      durationInternship: json['duration_internship'] ?? '',
      stipend: json['stipend']?.toString() ?? '',
      jobRole: json['job_role'] ?? '',
      jobDescription: json['job_description'] ?? '',
      skills: json['skills'] ?? '',
      jobLocation: json['job_location'] ?? '',
      jobSalary: json['job_salary']?.toString() ?? '',
      jobType: json['job_type'] ?? '',
      minPackage: json['min_package'] is int ? json['min_package'] : 0,
      maxPackage: json['max_package'] is int ? json['max_package'] : 0,
    );
  }

  // Convert model to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      "company_name": companyName,
      "company_website": companyWebsite,
      "headquarters": headquarters,
      "industry": industry,
      "details": details,
      "date_placementdrive": datePlacementDrive,
      "application_deadline": applicationDeadline,
      "joining_date": joiningDate,
      "hr_name": hrName,
      "hr_email": hrEmail,
      "hr_contact": hrContact,
      "bond": bond,
      "benefits": benefits,
      "doc_required": docRequired,
      "eligibility_criteria": eligibilityCriteria,
      "interview_rounds": interviewRounds.map((round) => round!.toJson()).toList(),
      "duration_internship": durationInternship,
      "stipend": stipend,
      "job_role": jobRole,
      "job_description": jobDescription,
      "skills": skills,
      "job_location": jobLocation, 
      "job_salary": jobSalary,
      "job_type": jobType,
      "min_package": minPackage,
      "max_package": maxPackage,
    };
  }
}