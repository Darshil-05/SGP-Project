class Faculty{
  final String firstname;
  final String birthdate;
  final String institute;
  final String department;
  String role = 'faculty';
  
  Faculty({
    required this.firstname,
    required this.birthdate,
    required this.institute,
    required this.department
  });
}