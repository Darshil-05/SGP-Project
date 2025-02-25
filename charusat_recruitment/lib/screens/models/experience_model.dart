class Experience {
  final int id;
  final String role;
  final String organization;

  Experience({
    required this.id,
    required this.role,
    required this.organization,
  });

  // Convert from JSON
  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'] ?? 0,
      role: json['role'] ?? "",
      organization: json['organization'] ?? "",
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'organization': organization,
    };
  }
}
