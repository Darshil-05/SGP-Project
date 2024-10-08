import 'dart:convert';

import 'package:charusat_recruitment/Providers/announcement_provider.dart';
import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/screens/Components/announcecard.dart';
import 'package:charusat_recruitment/screens/models/announcement_model.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/pie_chart_provider.dart';
import 'package:http/http.dart' as http;

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
Future<void> getAnnouncements() async {
  print("calling geting");

  var request = http.Request('GET', Uri.parse('$serverurl/announcement/announcements/'));
  request.body = ''''''; // You can add any necessary body content if required

  try {
    // Send the request and wait for the response
    http.StreamedResponse streamedResponse = await request.send().timeout(Duration(seconds: 15));

    // Convert streamed response to regular response
    final response = await http.Response.fromStream(streamedResponse);

    print("wait over");

    if (response.statusCode == 201 || response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      print("inside");

      // Map response data to the AnnouncementModel
      List<AnnouncementModel> announce = responseData.map<AnnouncementModel>((item) {
        print(item['title']);
        return AnnouncementModel(
          id: item['id'],
          title: item['title'],
          subtitle: item['description'],
          companyName: item['comapny_name'],
          color: Colors.blue, // Assigning a default color or handle based on data
        );
      }).toList();

      // Adding the `announce` list to your provider
      Provider.of<AnnouncementProvider>(context, listen: false).announcements = announce;
    } else {
      showErrorDialog(context, "Error loading announcements");
    }
  } catch (e) {
    print("Error occurred: $e");
    showErrorDialog(context, "Error loading announcements");
  }
}

  @override
  void initState() {
    getAnnouncements();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<AnnouncementModel> announcements = Provider.of<AnnouncementProvider>(context).announcements;
    return Scaffold(
      body: RefreshIndicator.adaptive(
        edgeOffset: 20,
        color: Color(0xff0f1d2c),
        backgroundColor: Colors.white,
        onRefresh: () {
getAnnouncements();
          return Future.delayed(Duration(seconds: 2), () {
            print("Hello World");
          });
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 65,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.normal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    const Text(
                      "Announcement",
                      style: TextStyle(fontSize: 30, fontFamily: "pop"),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/announcement');
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: announcements.isNotEmpty
                    ? Row(
                        children: announcements
                            .map((announce) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AnnounceCard(announce: announce),
                                ))
                            .toList(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnnounceCard(
                            announce: AnnouncementModel(
                                id: 0,
                                title: "No Announcement",
                                subtitle: " ",
                                companyName: " ",
                                color: const Color(0xff005fe7))),
                      ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  "Analysis",
                  style: TextStyle(fontSize: 30, fontFamily: "pop"),
                ),
              ),
              const SizedBox(height: 10),

              // Row of buttons for selecting the time period
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeButton('Last Year', 'lastYear'),
                      const SizedBox(width: 8),
                      _buildTimeButton('Last 2 Years', 'last2Years'),
                      const SizedBox(width: 8),
                      _buildTimeButton('Last 5 Years', 'last5Years'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Listen to changes in PieChartProvider
              Consumer<PieChartProvider>(
                builder: (context, provider, child) {
                  return CustomPieChart(
                    selectedYear: provider.selectedYear,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build a custom button
  Widget _buildTimeButton(String label, String value) {
    return OutlinedButton(
      onPressed: () {
        // Update selected year in PieChartProvider
        Provider.of<PieChartProvider>(context, listen: false)
            .setSelectedYear(value);
      },
      style: OutlinedButton.styleFrom(
        backgroundColor:
            Provider.of<PieChartProvider>(context).selectedYear == value
                ? const Color(0xff0f1d2c)
                : Colors.white,
        side: const BorderSide(color: Color(0xff0f1d2c)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Circular border
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Provider.of<PieChartProvider>(context).selectedYear == value
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}
