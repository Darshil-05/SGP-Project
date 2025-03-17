import 'package:charusat_recruitment/screens/screens_after_auth/company/company_status.dart';
import 'package:flutter/material.dart';
import 'package:charusat_recruitment/service/company_service/company_service.dart';

import '../../models/company_model.dart';

class CompanyDetailsPage extends StatefulWidget {
  final int companyid;
  const CompanyDetailsPage({super.key, required this.companyid});

  @override
  _CompanyDetailsPageState createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  // CompanyModel to store company details
  CompanyModel? companyData;
  bool isLoading = true;
  
  // Statuses for company
  List<String> statuses = [
    "Company Listed",
    "Form Open",
    "Aptitude Started",
  ];
  bool detailsVisible = false;
  bool jobDetailsVisible = false;
  bool selectionProcessVisible = false;
  bool internshipVisible = false;
  bool timelineVisible = false;
  bool contactVisible = false;
  bool additionalInfoVisible = false;

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
                              .registerstudent(context, widget.companyid, '22IT092');

                          // Close the loading dialog
                          Navigator.of(context).pop();

                          // Show appropriate message based on success or failure
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "You have successfully applied for ${companyData?.companyName ?? companyName}."),
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
  void initState() {
    super.initState();
    // Fix: Use widget.companyid to access the parameter passed to the widget
    _loadCompanyDetails();
  }
  
  // Function to load company details
  Future<void> _loadCompanyDetails() async {
    try {
      final data = await CompanyService().getCompanyDetails(context, widget.companyid);
      setState(() {
        companyData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to load company details"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
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
                      Text(
                        companyData?.companyName ?? "Company Details",
                        style: const TextStyle(fontSize: 22, fontFamily: "pop"),
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
                                    companyData?.companyName ?? 'Not available'),
                                buildDetailItem(Icons.language, 'Website',
                                    companyData?.companyWebsite ?? 'Not available'),
                                buildDetailItem(Icons.location_city,
                                    'Headquarters', companyData?.headquarters ?? 'Not available'),
                                buildDetailItem(Icons.work, 'Industry',
                                    companyData?.industry ?? 'Not available'),
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
                                    companyData?.jobRole ?? 'Not available'),
                                buildDetailItem(
                                    Icons.description,
                                    'Job Description',
                                    companyData?.jobDescription ?? 'Not available'),
                                buildDetailItem(Icons.code, 'Required Skills',
                                    companyData?.skills ?? 'Not available'),
                                buildDetailItem(Icons.location_on,
                                    'Job Location', companyData?.jobLocation ?? 'Not available'),
                                buildDetailItem(
                                    Icons.money, 'Salary/CTC', companyData?.jobSalary ?? 'Not available'),
                                buildDetailItem(
                                    Icons.access_time, 'Job Type', companyData?.jobType ?? 'Not available'),
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
                                    companyData?.interviewRounds.map((r) => r.roundName).join(', ') ?? 'Not available'),
                                buildDetailItem(
                                    Icons.school,
                                    'Eligibility Criteria',
                                    companyData?.eligibilityCriteria ?? 'Not available'),
                                buildDetailItem(Icons.format_list_numbered,
                                    'Number of Rounds', companyData?.interviewRounds.length.toString() ?? '0'),
                                buildDetailItem(
                                    Icons.trending_up,
                                    'Package Range',
                                    '${companyData?.minPackage ?? 0} - ${companyData?.maxPackage ?? 0} LPA'),
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
                                    'Duration of Internship', companyData?.durationInternship ?? 'Not applicable'),
                                buildDetailItem(Icons.attach_money, 'Stipend',
                                    companyData?.stipend ?? 'Not applicable'),
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
                                    'Date of Placement Drive', companyData?.datePlacementDrive ?? 'Not available'),
                                buildDetailItem(Icons.hourglass_bottom,
                                    'Application Deadline', companyData?.applicationDeadline ?? 'Not available'),
                                buildDetailItem(Icons.date_range,
                                    'Joining Date', companyData?.joiningDate ?? 'Not available'),
                              ],
                            ),
                          ),

                          // Contact
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
                                    Icons.person, 'HR Name', companyData?.hrName ?? 'Not available'),
                                buildDetailItem(Icons.email, 'Email Address',
                                    companyData?.hrEmail ?? 'Not available'),
                                buildDetailItem(Icons.phone, 'Phone Number',
                                    companyData?.hrContact ?? 'Not available'),
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
                                    'Bond/Agreement', companyData?.bond != null && companyData!.bond > 0 ? "${companyData!.bond} years service bond" : "No bond"),
                                buildDetailItem(Icons.card_giftcard, 'Benefits',
                                    companyData?.benefits ?? 'Not available'),
                                buildDetailItem(
                                    Icons.file_present,
                                    'Documents Required',
                                    companyData?.docRequired ?? 'Resume, Mark sheets, ID proof'),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 500,
                        child: companyData != null 
                          ? CompanyLiveStatus(
                              rounds: companyData!.interviewRounds,
                            )
                          : const Center(child: Text("No rounds information available")),
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
              showApplyPopup(context, companyData?.companyName ?? "Company");
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