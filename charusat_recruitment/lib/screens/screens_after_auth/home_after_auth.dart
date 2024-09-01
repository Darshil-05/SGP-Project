import 'package:charusat_recruitment/screens/Components/announcecard.dart';
import 'package:charusat_recruitment/screens/models/announcement_model.dart';
import 'package:charusat_recruitment/screens/screens_after_auth/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/pie_chart_provider.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final List<AnnouncementModel> _announce = AnnouncementModel.annouce;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 65,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Announcement",
                style: TextStyle(fontSize: 30, fontFamily: "pop"),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _announce
                    .map((announce) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnnounceCard(announce: announce),
                        ))
                    .toList(),
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
        backgroundColor: Provider.of<PieChartProvider>(context).selectedYear == value
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
              : Colors.blue,
        ),
      ),
    );
  }
}
