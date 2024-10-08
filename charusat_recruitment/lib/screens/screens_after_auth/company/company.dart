import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  final List<Map<String, String>> upcomingCompanies = [
    {
      'name': 'Tech Corp',
      'date': '2024-09-20',
      'location': 'San Francisco, CA',
      'description': 'A leading tech company in AI and cloud computing.',
      'image':
          'https://i.pinimg.com/736x/c4/70/80/c4708087930bd454d3013335c3eadf24.jpg', // Sample image URL
    },
    {
      'name': 'InnovateX',
      'date': '2024-10-01',
      'location': 'New York, NY',
      'description': 'A rising startup specializing in innovative solutions.',
      'image':
          'https://i.pinimg.com/736x/c4/70/80/c4708087930bd454d3013335c3eadf24.jpg',
    },
  ];

  final List<Map<String, String>> recentCompanies = [
    {
      'name': 'Green Energy Inc.',
      'date': '2024-09-10',
      'location': 'Austin, TX',
      'description': 'Pioneers in renewable energy and sustainability.',
      'image':
          'https://i.pinimg.com/736x/c4/70/80/c4708087930bd454d3013335c3eadf24.jpg',
    },
    {
      'name': 'FinTech Solutions',
      'date': '2024-08-28',
      'location': 'Boston, MA',
      'description':
          'Financial technology experts offering digital payment solutions.',
      'image':
          'https://i.pinimg.com/736x/c4/70/80/c4708087930bd454d3013335c3eadf24.jpg',
    },
  ];

  // Widget to build the list of companies
  Widget _buildCompanyList(List<Map<String, String>> companies) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
           Navigator.of(context).pushNamed('/companydetails');
        },
        child: Column(
          children: companies.map((company) {
            return Column(
              children: [
                 ClipRRect(
                    clipBehavior: Clip.hardEdge,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(5) , topRight: Radius.circular(5)),
                    child: Image.network(
                      company['image']!,
                      height: 150,
                      width: MediaQuery.sizeOf(context).width,
                      fit: BoxFit.cover,alignment: Alignment.centerLeft,
                    ),
                  ),
                Card(
                  color: Colors.white70,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5) , bottomRight: Radius.circular(5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        // Company details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Company Name
                              Text(
                                company['name']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Date and Location
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 14, color: Colors.black),
                                  const SizedBox(width: 5),
                                  Text(company['date']!,
                                      style: const TextStyle(color: Colors.black)),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.location_on,
                                      size: 14, color: Colors.black),
                                  const SizedBox(width: 5),
                                  Text(company['location']!,
                                      style: const TextStyle(color: Colors.black)),
                                ],
                              ),
                              const SizedBox(height: 5),
                              // Brief description
                              Text(
                                company['description']!,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 25,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 80.0),
              child: Text(
                "Companies",
                style: TextStyle(fontSize: 25, fontFamily: "pop"),
              ),
            ),
            const SizedBox(height: 20),
             Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  const Text(
                    "Upcomming",
                    style: TextStyle(fontSize: 20, fontFamily: "pop"),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/companymanager');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildCompanyList(upcomingCompanies),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Recent",
                style: TextStyle(fontSize: 20, fontFamily: "pop"),
              ),
            ),
            _buildCompanyList(recentCompanies),
          ],
        ),
      ),
    );
  }
}
