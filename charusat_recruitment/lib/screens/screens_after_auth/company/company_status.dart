import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:charusat_recruitment/screens/models/company_round_model.dart';

class CompanyLiveStatus extends StatelessWidget {
  final List<CompanyRound> rounds;
  late final int ongoingRoundIndex;
  late final int lastCompletedIndex;

  CompanyLiveStatus({Key? key, required this.rounds}) : super(key: key) {
    // Find the first pending round (ongoing round)
    ongoingRoundIndex = rounds.indexWhere((round) => round.status == "pending");

    // If no pending rounds are found, set to last index (all rounds are completed)
    if (ongoingRoundIndex == -1) {
      ongoingRoundIndex = rounds.length;
    }

    // Last completed round is just before the ongoing round
    lastCompletedIndex = ongoingRoundIndex - 1;
  }

  @override
  Widget build(BuildContext context) {
    if (rounds.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: rounds.length,
      itemBuilder: (context, index) {
        Color iconColor;
        Color lineColor;

        if (index < ongoingRoundIndex) {
          // Completed rounds (Blue)
          iconColor = Colors.blue;
          lineColor = Colors.blue;
        } else if (index == ongoingRoundIndex) {
          // Ongoing round (Green)
          iconColor = Colors.green;
          lineColor = Colors.green;
        } else {
          // Upcoming rounds (Gray)
          iconColor = Colors.grey;
          lineColor = Colors.grey;
        }

        return GestureDetector(
          onTap: () => _handleRoundTap(context, index),
          child: TimelineTile(
            isFirst: index == 0,
            isLast: index == rounds.length - 1,
            indicatorStyle: IndicatorStyle(
              width: 40,
              color: iconColor,
              iconStyle: IconStyle(
                iconData: Icons.circle,
                color: Colors.white,
              ),
            ),
            beforeLineStyle: LineStyle(color: lineColor, thickness: 3),
            afterLineStyle: LineStyle(color: lineColor, thickness: 3),
            endChild: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListTile(
                title: Text(
                  rounds[index].roundName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  index < ongoingRoundIndex
                      ? 'Completed'
                      : index == ongoingRoundIndex
                          ? 'Ongoing'
                          : 'Upcoming',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleRoundTap(BuildContext context, int index) {
    if (index == lastCompletedIndex) {
      // Navigate only if the tapped round is the last completed round
      Navigator.of(context).pushNamed('/studentlist');
    } else {
      // Show a message if tapped round is not last completed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You can only view the last completed round."),
        ),
      );
    }
  }
}
