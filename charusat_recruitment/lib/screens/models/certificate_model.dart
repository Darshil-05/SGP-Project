class Certificate {
  final int id;
  final String name;
  final String platform;

  Certificate({
    required this.id,
    required this.name,
    required this.platform,
  });

  // Convert from JSON
  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      platform: json['platform'] ?? "",
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'platform': platform,
    };
  }
}
