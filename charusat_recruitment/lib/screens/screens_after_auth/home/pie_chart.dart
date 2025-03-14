import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class CustomPieChart extends StatelessWidget {
  final String selectedYear;

  const CustomPieChart({super.key, required this.selectedYear});

  @override
  Widget build(BuildContext context) {
    // Update dataMap based on selectedYear
    Map<String, double> dataMap;

    switch (selectedYear) {
      case 'last2Years':
        dataMap = {
          "Full Stack Web Developer": 35,
          "AI/ML": 25,
          "Cyber Security": 20,
          "Mobile App Developer": 10,
          "Data Analytics": 5,
          "Other Roles": 5,
        };
        break;
      case 'last5Years':
        dataMap = {
          "Full Stack Web Developer": 30,
          "AI/ML": 20,
          "Cyber Security": 15,
          "Mobile App Developer": 20,
          "Data Analytics": 10,
          "Other Roles": 5,
        };
        break;
      case 'lastYear':
      default:
        dataMap = {
          "Full Stack Web Developer": 40,
          "AI/ML": 30,
          "Cyber Security": 10,
          "Mobile App Developer": 10,
          "Data Analytics": 5,
          "Other Roles": 5,
        };
    }

    final List<Color> colorList = [
      const Color(0xff519DE9),
      const Color(0xffA30000),
      const Color(0xff7CC674),
      const Color(0xff73C5C5),
      const Color(0xff8481DD),
      const Color(0xffF6D173),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0), // Add padding to avoid overlap
          child: PieChart(
            dataMap: dataMap,
            colorList: colorList,
            chartRadius: MediaQuery.of(context).size.width / 1.8, // Reduced size to fit better
            chartType: ChartType.ring,
            ringStrokeWidth: 80,
            legendOptions: const LegendOptions(
              showLegends: false, // Disable built-in legends
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: false, // Do not show values on the pie chart
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
            ),
          ),
        ),
        const ListTile(
          leading: Text("Color", style: TextStyle(fontSize: 15)),
          title: Text("Job role", style: TextStyle(fontSize: 15)),
          trailing: Text("Percentage", style: TextStyle(fontSize: 15)),
        ),
        Column(
          children: List.generate(dataMap.length, (index) {
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: colorList[index], // Set the color from colorList
                      shape: BoxShape.circle,
                    ),
                  ),
                  title: Text(
                    dataMap.keys.toList()[index],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: Text(
                    "${dataMap.values.toList()[index]}%",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                if (index < dataMap.length - 1) // Avoid adding divider after the last item
                  const Divider(), // Add a divider between each ListTile
              ],
            );
          }),
        ),
      ],
    );
  }
}
