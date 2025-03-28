import 'package:charusat_recruitment/Providers/announcement_provider.dart';
import 'package:charusat_recruitment/const.dart';
import 'package:charusat_recruitment/screens/Components/announcecard.dart';
import 'package:charusat_recruitment/screens/models/announcement_model.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/home/pie_chart.dart';
import 'package:charusat_recruitment/service/common_service/annoncement_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Providers/pie_chart_provider.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  @override
  void initState() {
    print("inside a home after auth");

    AnnouncementService().getAnnouncements(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<AnnouncementModel> announcements =
        Provider.of<AnnouncementProvider>(context).announcements;
    return Scaffold(
      body: RefreshIndicator.adaptive(
        edgeOffset: 20,
        color: const Color(0xff0f1d2c),
        backgroundColor: Colors.white,
        onRefresh: () {
          return AnnouncementService().getAnnouncements(context);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 70,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          physics: const BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.normal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Row(
                  children: [
                    const Text(
                      "Announcement",
                      style: TextStyle(fontSize: 30, fontFamily: "pop"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if(role == 'faculty')(InkWell(
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
                    ))
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
                          ),
                        ),
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
