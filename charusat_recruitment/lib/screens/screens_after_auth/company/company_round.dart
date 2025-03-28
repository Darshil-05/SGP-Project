import 'package:flutter/material.dart';
import 'package:charusat_recruitment/screens/models/company_model.dart';

import '../../../service/company_service/company_service.dart';
import '../../models/company_round_model.dart';

class RoundManager extends StatefulWidget {
  const RoundManager({super.key});

  @override
  State<RoundManager> createState() => _RoundManagerState();
}

class _RoundManagerState extends State<RoundManager> {
  final CompanyService _companyService = CompanyService();
  late CompanyModel _company;
  List<CompanyRound> _rounds = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get company data from arguments
    _company = ModalRoute.of(context)!.settings.arguments as CompanyModel;

    // Initialize rounds with default values
    setState(() {
     
      _isLoading = false;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    print("inside a round");

     _rounds = [
        CompanyRound(
            roundName: "Application Deadline", status: "pending", index: 0),
        CompanyRound(roundName: "Finalist", status: "completed", index: 6),
      ];
    super.initState();
  }
  // Method to add a new round
 void _addRound() {
  TextEditingController _controller = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add New Round"),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: "Round Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.trim().isNotEmpty) {
                setState(() {
                  // Insert new round before Finalist
                  print("Before add length ${_rounds.length}");
                  _rounds.insert(
                      _rounds.length - 1,
                      CompanyRound(
                          roundName: _controller.text.trim(),
                          status: "pending",
                          index: _rounds.length - 1)); 
                        print("after add length ${_rounds.length}");
                  // Update indices for all rounds
                  // for (int i = 0; i < _rounds.length; i++) {
                  //   _rounds[i].index = i; // Directly update the index
                  // }
                });
                // After the loop
                print("All rounds after update:");
                for (var round in _rounds) {
                  print(round.toJson());
                }
                Navigator.of(context).pop();
              }
            },
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}

  // Method to delete a round
  void _deleteRound(int index) {
    setState(() {
      _rounds.removeAt(index);

      // Update indices for remaining rounds
      for (int i = 0; i < _rounds.length; i++) {
        _rounds[i] = CompanyRound(
            roundName: _rounds[i].roundName,
            status: _rounds[i].status,
            index: i);
      }
    });
  }

  // Method to submit company with rounds
  Future<void> _submitCompanyWithRounds() async {
    setState(() {
      _isLoading = true;
    });
    _rounds[_rounds.length -1].index = _rounds.length -1; 

    // Create a new company with the updated rounds
    final updatedCompany = CompanyModel(
      companyid: _company.companyid,
      companyName: _company.companyName,
      companyWebsite: _company.companyWebsite,
      headquarters: _company.headquarters,
      industry: _company.industry,
      details: _company.details,
      datePlacementDrive: _company.datePlacementDrive,
      applicationDeadline: _company.applicationDeadline,
      joiningDate: _company.joiningDate,
      hrName: _company.hrName,
      hrEmail: _company.hrEmail,
      hrContact: _company.hrContact,
      bond: _company.bond,
      benefits: _company.benefits,
      docRequired: _company.docRequired,
      eligibilityCriteria: _company.eligibilityCriteria,
      interviewRounds: _rounds, // Add the updated rounds
      durationInternship: _company.durationInternship,
      stipend: _company.stipend,
      jobRole: _company.jobRole,
      jobDescription: _company.jobDescription,
      skills: _company.skills,
      jobLocation: _company.jobLocation,
      jobSalary: _company.jobSalary,
      jobType: _company.jobType,
      minPackage: _company.minPackage,
      maxPackage: _company.maxPackage,
    );

    // Call the service to add the company
    bool success = await _companyService.addCompany(context, updatedCompany);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Company added successfully!')),
      );

      // Navigate back to the previous screen or dashboard
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Round Manager",
          style: TextStyle(fontFamily: "pop"),
        ),
        backgroundColor: const Color(0xff0f1d2c),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Interview Rounds",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "pop",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _rounds.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final item = _rounds.removeAt(oldIndex);
                        _rounds.insert(newIndex, item);
                        // Update indices for all rounds after reordering
                        for (int i = 0; i < _rounds.length; i++) {
                          _rounds[i] = CompanyRound(
                              roundName: _rounds[i].roundName,
                              status: _rounds[i].status,
                              index: i);
                        }
                      });
                    },
                    itemBuilder: (context, index) {
                      return Card(
                        key: ValueKey(_rounds[index].roundName),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: index == 0 || index == _rounds.length - 1
                            ? Colors.white
                            : const Color(0xff0f1d2c),
                        child: ListTile(
                          title: Text(
                            _rounds[index].roundName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: "pop",
                              color: index == 0 || index == _rounds.length - 1
                                  ? const Color(0xff0f1d2c)
                                  : Colors.white,
                            ),
                          ),
                          trailing: _rounds[index].roundName !=
                                      "Application Deadline" &&
                                  _rounds[index].roundName != "Finalist"
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteRound(index),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Submit Button
                InkWell(
                  onTap: _submitCompanyWithRounds,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xff0f1d2c),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: const Text(
                      "Submit Company",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRound,
        backgroundColor: const Color(0xff0f1d2c),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
