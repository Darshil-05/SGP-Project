class Institute {
  final String name;
  final List<String> departments;

  Institute({required this.name, required this.departments});
}

final List<Institute> institutes = [
  Institute(name: 'CSPIT', departments: ['Mechanical', 'Electrical']),
  Institute(name: 'DEPSTAR', departments: ['CS', 'CE', 'IT']),
  Institute(name: 'RPCP', departments: ['Pharmacy']),
];
