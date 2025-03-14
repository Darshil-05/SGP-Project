import 'dart:convert';

import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/screens/models/company_round_model.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/company/company_status.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charusat_recruitment/service/company_service/company_service.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CompanyDetailsPage extends StatefulWidget {
  const CompanyDetailsPage({super.key});

  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  // Statuses for company
  List<String> statuses = [
    "Company Listed",
    "Form Open",
    "Aptitude Started",
  ];
  int _currentStep = 2;
  bool detailsVisible = false;
  bool jobDetailsVisible = false;
  bool selectionProcessVisible = false;
  bool internshipVisible = false;
  bool timelineVisible = false;
  bool contactVisible = false;
  bool additionalInfoVisible = false;
  List<Step> _buildSteps() {
    return [
      Step(
        title: Text('Applied'),
        content: Text('You applied on 27 September 2024.'),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Round 1: Technical Interview'),
        content: Text('Technical interview is ongoing.'),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Round 2: HR Interview'),
        content: Text('HR interview will take place on 30 September 2024.'),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: Text('Final List'),
        content: Text('Final offer will be sent on 1 October 2024.'),
        isActive: _currentStep >= 3,
        state: _currentStep == 3 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  Widget buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 3),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> applyForCompany(
      String studentId, int companyId, BuildContext context) async {
    bool _isLoading = true;
    String? _errorMessage;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    print("Applying for company: $companyId with student ID: $studentId");

    var headers = {
      'Content-Type': 'application/json',
    };

    var request = http.Request(
      'POST',
      Uri.parse('$serverurl/company/company-registration/'),
    );

    request.body = json.encode({
      "input_student_id": studentId,
      "input_company_id": companyId,
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse streamedResponse =
          await request.send().timeout(const Duration(seconds: 10));
      final response = await http.Response.fromStream(streamedResponse);

      print("Response received");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Application successful: ${response.body}");
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully applied!")),
        );
      } else {
        print("Application failed: ${response.reasonPhrase}");
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to apply. Please try again.";
        });
      }
    } catch (e) {
      print("Error applying: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = "Error applying. Please check your connection.";
      });
    }
  }

  void showApplyPopup(BuildContext context, String companyName) {
    bool _isChecked = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Apply for $companyName",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "I have read all company details and I am ready to apply.",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_isChecked)
                    const Text(
                      "Are you sure you want to apply for this company?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _isChecked
                      ? () async {
                          // Show loading indicator while processing
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                child: CircularProgressIndicator()),
                          );

                          // Call the addStudent function
                          bool success = await CompanyService()
                              .registerstudent(context, 2, '22IT092');

                          // Close the loading dialog
                          Navigator.of(context).pop();

                          // Show appropriate message based on success or failure
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "You have successfully applied for $companyName."),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Failed to apply. Please try again."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isChecked
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  child: const Text("Apply"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildDetailCard(String title, bool visible, VoidCallback onTap,
      {Widget? content}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(
                  visible
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_right_rounded,
                ),
              ],
            ),
          ),
          if (content != null && visible) ...[
            const SizedBox(height: 10),
            content,
          ]
        ],
      ),
    );
  }

  int selectedIndex = 0;
  final List<String> buttonLabels = ['Details', 'Status'];

  Widget _buildButton(int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            buttonLabels[index],
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? const Color(0xff0f1d2c) : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Show underline if selected
          Opacity(
            opacity: isSelected ? 1 : 0,
            child: Container(
              height: 2,
              width: 60,
              color: const Color(0xff0f1d2c),
              margin: const EdgeInsets.only(top: 4),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
              left: 6.0,
              right: 6,
              top: MediaQuery.of(context).padding.top + 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      const Text(
                        "Tech Mahindra",
                        style: TextStyle(fontSize: 22, fontFamily: "pop"),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5), // Border radius of 5
                  child: Image.network(
                    'https://i.pinimg.com/736x/c4/70/80/c4708087930bd454d3013335c3eadf24.jpg',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(buttonLabels.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildButton(index),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                // make here a two tab
                (selectedIndex == 0)
                    ? Column(
                        children: [
                          buildDetailCard(
                            'Company Information',
                            detailsVisible,
                            () {
                              setState(() {
                                detailsVisible = !detailsVisible;
                              });
                            },
                            content: Column(
                              children: [
                                buildDetailItem(Icons.business, 'Company Name',
                                    'Tech Corp'),
                                buildDetailItem(Icons.language, 'Website',
                                    'www.techcorp.com'),
                                buildDetailItem(Icons.location_city,
                                    'Headquarters', 'San Francisco'),
                                buildDetailItem(Icons.work, 'Industry',
                                    'Information Technology'),
                              ],
                            ),
                          ),

                          // Job Details Section
                          buildDetailCard(
                            'Job Details',
                            jobDetailsVisible,
                            () {
                              setState(() {
                                jobDetailsVisible = !jobDetailsVisible;
                              });
                            },
                            content: Column(
                              children: [
                                buildDetailItem(Icons.work, 'Job Role/Position',
                                    'Software Engineer'),
                                buildDetailItem(
                                    Icons.description,
                                    'Job Description',
                                    'Developing and maintaining web applications.'),
                                buildDetailItem(Icons.code, 'Required Skills',
                                    'Flutter, Node.js, MongoDB'),
                                buildDetailItem(Icons.location_on,
                                    'Job Location', 'San Francisco'),
                                buildDetailItem(
                                    Icons.money, 'Salary/CTC', '\$80,000/year'),
                                buildDetailItem(
                                    Icons.access_time, 'Job Type', 'Full-time'),
                              ],
                            ),
                          ),

                          // Selection Process Section
                          buildDetailCard(
                            'Selection Process',
                            selectionProcessVisible,
                            () {
                              setState(() {
                                selectionProcessVisible =
                                    !selectionProcessVisible;
                              });
                            },
                            content: Column(
                              children: [
                                buildDetailItem(
                                    Icons.timeline,
                                    'Process Stages',
                                    'Written Test, Technical Interview, HR Interview'),
                                buildDetailItem(
                                    Icons.school,
                                    'Eligibility Criteria',
                                    'Minimum GPA: 7.0, IT & CS Branches'),
                                buildDetailItem(Icons.format_list_numbered,
                                    'Number of Rounds', '3'),
                                buildDetailItem(
                                    Icons.trending_up,
                                    'Cutoff Marks/Percentage',
                                    '70% Aptitude Test Score'),
                                buildDetailItem(
                                    Icons.person, 'Selection Ratio', '1:10'),
                              ],
                            ),
                          ),

                          // Internship/Training Section
                          buildDetailCard(
                            'Internship/Training (if applicable)',
                            internshipVisible,
                            () {
                              setState(() {
                                internshipVisible = !internshipVisible;
                              });
                            },
                            content: Column(
                              children: [
                                buildDetailItem(Icons.calendar_today,
                                    'Duration of Internship', '6 months'),
                                buildDetailItem(Icons.attach_money, 'Stipend',
                                    '\$2,000/month'),
                                buildDetailItem(Icons.check_circle,
                                    'Conversion to Full-time', 'Yes'),
                              ],
                            ),
                          ),

                          // Timeline Section
                          buildDetailCard(
                            'Timeline',
                            timelineVisible,
                            () {
                              setState(() {
                                timelineVisible = !timelineVisible;
                              });
                            },
                            content: Column(
                              children: [
                                buildDetailItem(Icons.event,
                                    'Date of Placement Drive', '12th Oct 2024'),
                                buildDetailItem(Icons.hourglass_bottom,
                                    'Application Deadline', '1st Oct 2024'),
                                buildDetailItem(Icons.date_range,
                                    'Joining Date', '1st Jan 2025'),
                              ],
                            ),
                          ),

                          // Contact Details Section
                          buildDetailCard(
                            'Contact Details',
                            contactVisible,
                            () {
                              setState(() {
                                contactVisible = !contactVisible;
                              });
                            },
                            content: Column(
                              children: [
                                buildDetailItem(
                                    Icons.person, 'HR Name', 'John Doe'),
                                buildDetailItem(Icons.email, 'Email Address',
                                    'hr@techcorp.com'),
                                buildDetailItem(Icons.phone, 'Phone Number',
                                    '+1-234-567-890'),
                              ],
                            ),
                          ),

                          // Additional Information Section
                          buildDetailCard(
                            'Additional Information',
                            additionalInfoVisible,
                            () {
                              setState(() {
                                additionalInfoVisible = !additionalInfoVisible;
                              });
                            },
                            content: Column(
                              children: [
                                buildDetailItem(Icons.assignment,
                                    'Bond/Agreement', '2 years service bond'),
                                buildDetailItem(Icons.card_giftcard, 'Benefits',
                                    'Health insurance, Relocation allowance'),
                                buildDetailItem(
                                    Icons.file_present,
                                    'Documents Required',
                                    'Resume, Mark sheets, ID proof'),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 500,
                        child: CompanyLiveStatus(
                          rounds: [
                            CompanyRound(
                                roundName: "Application Deadline",
                                status: "Completed",
                                index: 0),
                                 CompanyRound(roundName: "first", status: "Completed", index: 2),
        CompanyRound(roundName: "second", status: "pending", index: 3),
        CompanyRound(roundName: "third", status: "pending", index: 4),
        CompanyRound(roundName: "fourth", status: "pending", index: 5),
                            CompanyRound(
                                roundName: "Finalist",
                                status: "pending",
                                index: 6),
                          ],

                          // Indicates which round is ongoing (0-based index)
                        ),
                      ),
              ],
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          height: 50, // Set height of the button
          width: 100, // Set width of the button
          child: FloatingActionButton(
            onPressed: () {
              showApplyPopup(context, "Company_name");
            },
            backgroundColor: const Color(0xff0f1d2c),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10), // Optional: Rounded rectangle shape
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(
                "Apply",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }
}
