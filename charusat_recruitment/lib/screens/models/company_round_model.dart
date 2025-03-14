// File: lib/screens/models/company_round.dart

class CompanyRound {
  final String roundName;
  final String status;
  int index;

  CompanyRound({
    required this.roundName,
    required this.status, 
    required this.index,
  });

  // Factory constructor to create from JSON
  factory CompanyRound.fromJson(Map<String, dynamic> json) {
    return CompanyRound(
      roundName: json['round_name'] ?? '',
      status: json['status'] ?? 'pending',
      index: json['index'] is int ? json['index'] : 0,
    );
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      "round_name": roundName,
      "status": status,
      "index": index,
    };
  }
}