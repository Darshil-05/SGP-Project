class StudentProfile {
  final int id;
  final List<String> certificates;
  final List<String> experience;
  final String idNo;
  final String firstName;
  final String lastName;
  final DateTime birthdate;
  final String institute;
  final String department;
  final double cgpa;
  final int passingYear;
  final String domains;
  final String? city;
  final String programmingSkill;
  final String techSkill;

  StudentProfile({
    required this.id,
    required this.certificates,
    required this.experience,
    required this.idNo,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.institute,
    required this.department,
    required this.cgpa,
    required this.passingYear,
    required this.domains,
    this.city,
    required this.programmingSkill,
    required this.techSkill,
  });

  // Factory constructor to create a StudentProfile from a JSON map
  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: json['id'] as int,
      certificates: (json['certificates'] as List<dynamic>).map((e) => e as String).toList(),
      experience: (json['experience'] as List<dynamic>).map((e) => e as String).toList(),
      idNo: json['id_no'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
      institute: json['institute'] as String,
      department: json['department'] as String,
      cgpa: (json['cgpa'] as num).toDouble(),
      passingYear: json['passing_year'] as int,
      domains: json['domains'] as String,
      city: json['city'] as String?,
      programmingSkill: json['programming_skill'] as String,
      techSkill: json['tech_skill'] as String,
    );
  }

  // Method to convert StudentProfile object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'certificates': certificates,
      'experience': experience,
      'id_no': idNo,
      'first_name': firstName,
      'last_name': lastName,
      'birthdate': birthdate.toIso8601String(),
      'institute': institute,
      'department': department,
      'cgpa': cgpa,
      'passing_year': passingYear,
      'domains': domains,
      'city': city,
      'programming_skill': programmingSkill,
      'tech_skill': techSkill,
    };
  }

  // Method to get full name
  String get fullName => '$firstName $lastName';

  // Method to calculate age
  int calculateAge() {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthdate.year;
    
    // Adjust age if birthday hasn't occurred yet this year
    if (currentDate.month < birthdate.month || 
        (currentDate.month == birthdate.month && currentDate.day < birthdate.day)) {
      age--;
    }
    
    return age;
  }
  // Method to create a copy with modified fields
  StudentProfile copyWith({
    int? id,
    List<String>? certificates,
    List<String>? experience,
    String? idNo,
    String? firstName,
    String? lastName,
    DateTime? birthdate,
    String? institute,
    String? department,
    double? cgpa,
    int? passingYear,
    String? domains,
    String? city,
    String? programmingSkill,
    String? techSkill,
  }) {
    return StudentProfile(
      id: id ?? this.id,
      certificates: certificates ?? this.certificates,
      experience: experience ?? this.experience,
      idNo: idNo ?? this.idNo,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdate: birthdate ?? this.birthdate,
      institute: institute ?? this.institute,
      department: department ?? this.department,
      cgpa: cgpa ?? this.cgpa,
      passingYear: passingYear ?? this.passingYear,
      domains: domains ?? this.domains,
      city: city ?? this.city,
      programmingSkill: programmingSkill ?? this.programmingSkill,
      techSkill: techSkill ?? this.techSkill,
    );
  }
}