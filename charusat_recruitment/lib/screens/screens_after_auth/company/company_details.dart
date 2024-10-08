import 'package:flutter/material.dart';

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
            left: 6.0, right: 6, top: MediaQuery.of(context).padding.top + 20),
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
                              buildDetailItem(
                                  Icons.business, 'Company Name', 'Tech Corp'),
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
                              buildDetailItem(Icons.location_on, 'Job Location',
                                  'San Francisco'),
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
                              buildDetailItem(Icons.timeline, 'Process Stages',
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
                              buildDetailItem(Icons.date_range, 'Joining Date',
                                  '1st Jan 2025'),
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
                  : Column(
                      children: [
                        // Company Status Section
                        const Text(
                          'Company Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0f1d2c),
                          ),
                        ),
                        // Dynamic Company Status List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: statuses.length,
                          itemBuilder: (context, index) {
                            return _buildStatusTile(index + 1, statuses[index]);
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build each status tile with a number and status description
  Widget _buildStatusTile(int number, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Circle with number inside
          CircleAvatar(
            backgroundColor: const Color(0xff0f1d2c),
            radius: 20,
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Status text
          Text(
            status,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff0f1d2c),
            ),
          ),
        ],
      ),
    );
  }
}
