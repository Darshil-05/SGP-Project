import 'package:charusat_recruitment/const.dart';
import 'package:flutter/material.dart';
import 'package:charusat_recruitment/service/company_service/company_service.dart';

import 'company_details.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  late Future<Map<String, List<Map<String, String>>>> companyData;

  @override
  void initState() {
    super.initState();
    companyData = CompanyService().getCompanies(context);
  }

  Future<void> _refresh() async {
    setState(() {
      companyData = CompanyService().getCompanies(context);
    });
  }

  Widget _buildCompanyList(List<Map<String, String>> companies) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: companies.map((company) {
          return GestureDetector(
            onTap: () {
              int companyId = int.parse(company['id']!);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CompanyDetailsPage(companyid: companyId),
                ),
              );
            },
            child: Column(
              children: [
                ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  child: Image.network(
                    company['image']!,
                    height: 150,
                    width: MediaQuery.sizeOf(context).width,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                  ),
                ),
                Card(
                  color: Colors.white70,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
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
                                      style:
                                          const TextStyle(color: Colors.black)),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.location_on,
                                      size: 14, color: Colors.black),
                                  const SizedBox(width: 5),
                                  Text(company['location']!,
                                      style:
                                          const TextStyle(color: Colors.black)),
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
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder(
          future: companyData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 50),
                        const SizedBox(height: 10),
                        Text(
                          'Error: ${snapshot.error}',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _refresh,
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            var companies = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 25,
                bottom: MediaQuery.of(context).padding.bottom,
              ),
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
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        const Text(
                          "Upcomming",
                          style: TextStyle(fontSize: 20, fontFamily: "pop"),
                        ),
                        const SizedBox(width: 15),
                        if (role == 'faculty')
                          (InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('/companymanager');
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
                          ))
                      ],
                    ),
                  ),
                  _buildCompanyList(companies['upcoming']!),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Recent",
                      style: TextStyle(fontSize: 20, fontFamily: "pop"),
                    ),
                  ),
                  _buildCompanyList(companies['recent']!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
