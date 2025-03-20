class FacultyProfile {
  final int id;
  final String facultyId;
  final String firstName;
  final String lastName;
  final String institute;
  final String department;
  
  FacultyProfile({
    required this.id,
    required this.facultyId,
    required this.firstName,
    required this.lastName,
    required this.institute,
    required this.department,
  });
  
  // Factory constructor to create FacultyProfile from JSON
  factory FacultyProfile.fromJson(Map<String, dynamic> json) {
    return FacultyProfile(
      id: json['id'] ?? 0,
      facultyId: json['faculty_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      institute: json['institute'] ?? '',
      department: json['department'] ?? '',
    );
  }
  
  // Convert FacultyProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'faculty_id': facultyId,
      'first_name': firstName,
      'last_name': lastName,
      'institute': institute,
      'department': department,
    };
  }
  
  // Create a copy of this FacultyProfile with optional field updates
  FacultyProfile copyWith({
    int? id,
    String? facultyId,
    String? firstName,
    String? lastName,
    DateTime? birthdate,
    String? institute,
    String? department,

  }) {
    return FacultyProfile(
      id: id ?? this.id,
      facultyId: facultyId ?? this.facultyId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      institute: institute ?? this.institute,
      department: department ?? this.department,

    );
  }
}