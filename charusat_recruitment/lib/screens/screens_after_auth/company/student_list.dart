import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:charusat_recruitment/const.dart';
import 'package:flutter/material.dart';


class StudentListManager extends StatefulWidget {
  final int companyId ;
  const StudentListManager({super.key , required this.companyId});

  @override
  State<StudentListManager> createState() => _StudentListManagerState();
}

class _StudentListManagerState extends State<StudentListManager> {
  List<Map<String, String>> _students = [];
  final List<bool> _selected = [];
  bool _isLoading = true;  // Track loading state
  String? _errorMessage;   // Track error messages
  final TextEditingController _searchController = TextEditingController();
  final bool _isShortlistMode =(role == 'faculty');

  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    print("inside a student list");

    getStudents();
  }

  Future<void> getStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    print("Fetching students");

    var request = http.Request(
        'GET', Uri.parse('$serverurl/company/company-registration/?company_id=${widget.companyId}'));

    try {
      http.StreamedResponse streamedResponse =
          await request.send().timeout(const Duration(seconds: 10));
      final response = await http.Response.fromStream(streamedResponse);

      print("Response received");

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> responseData = json.decode(response.body);
        print("Students data: $responseData");

        if (responseData.isEmpty) {
          setState(() {
            _isLoading = false;
            _errorMessage = "No students found"; // Show message when no students are found
          });
          return;
        }

        List<Map<String, String>> students = responseData.map<Map<String, String>>((item) {
          return {
            'id': item['student_id'].toString(),
            'name': item['student_name'].toString()
          };
        }).toList();

        setState(() {
          _students = students;
          _selected.clear();
          _selected.addAll(List.generate(_students.length, (_) => false));
          _isLoading = false; // Data loaded successfully
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "Error loading students"; // Handle API error
        });
      }
    } catch (e) {
      print("Error fetching students: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = "Error loading students"; // Handle request failure
      });
    }
  }

  List<Map<String, String>> _filteredStudents() {
    if (_searchQuery.isEmpty) {
      return _students;
    }
    return _students.where((student) {
      final id = student["id"]!.toLowerCase();
      final name = student["name"]!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return id.contains(query) || name.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _filteredStudents();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isShortlistMode ? "Shortlist" : "Student List",
          style: const TextStyle(fontFamily: "pop"),
        ),
        backgroundColor: const Color(0xff0f1d2c),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: const TextStyle(fontSize: 16)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Search by ID or Name",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = filteredStudents[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                student["id"]!,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff0f1d2c)),
                              ),
                              subtitle: Text(
                                student["name"]!,
                                style: const TextStyle(color: Color(0xff0f1d2c)),
                              ),
                              trailing: _isShortlistMode
                                  ? Checkbox(
                                      value: index < _selected.length ? _selected[index] : false, // Safe indexing
                                      onChanged: (value) {
                                        if (index < _selected.length) {
                                          setState(() {
                                            _selected[index] = value ?? false;
                                          });
                                        }
                                      },
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: _isShortlistMode && _students.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                final shortlistedStudents = _students
                    .asMap()
                    .entries
                    .where((entry) => _selected[entry.key])
                    .map((entry) => entry.value)
                    .toList();
                _showShortlistDialog(shortlistedStudents);
              },
              backgroundColor: const Color(0xff0f1d2c),
              label: const Text(
                "Done",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              icon: const Icon(Icons.done),
            )
          : null,
    );
  }

  void _showShortlistDialog(List<Map<String, String>> shortlistedStudents) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Shortlisted Students", style: TextStyle(color: Color(0xff0f1d2c))),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: shortlistedStudents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    "${shortlistedStudents[index]["id"]!}  | ${shortlistedStudents[index]["name"]!}",
                    style: const TextStyle(color: Color(0xff0f1d2c)),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
