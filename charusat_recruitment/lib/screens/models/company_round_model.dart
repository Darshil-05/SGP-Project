class CompanyRound {
  final String roundName;
  final String status;
  int index;

  CompanyRound({
    required this.roundName,
    required this.status, 
    required this.index,
  });

  // Factory constructor to create from JSON with automatic sorting
  factory CompanyRound.fromJson(Map<String, dynamic> json) {
    return CompanyRound(
      roundName: json['round_name'] ?? '',
      status: json['status'] ?? 'pending',
      index: json['index'] is int ? json['index'] : 0,
    );
  }

  // Static method to sort a list of CompanyRound by index
  static List<CompanyRound> sortRounds(List<CompanyRound> rounds) {
    // Create a copy of the list to avoid modifying the original
    var sortedRounds = List<CompanyRound>.from(rounds);
    
    // Sort the rounds based on their index
    sortedRounds.sort((a, b) => a.index.compareTo(b.index));
    
    return sortedRounds;
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