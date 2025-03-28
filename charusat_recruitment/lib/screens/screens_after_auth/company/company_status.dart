import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:charusat_recruitment/screens/models/company_round_model.dart';

class CompanyLiveStatus extends StatelessWidget {
  final List<CompanyRound> rounds;
  
  const CompanyLiveStatus({Key? key, required this.rounds}) : super(key: key);
  
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
        // Determine colors based on the status
        Color iconColor;
        Color lineColor;
        String statusText;

        // Get the current round's status, handling both correct and typo versions
        String status = rounds[index].status.toLowerCase();
        bool isCompleted = status == "completed" || status == "compeleted";
        bool isRunning = status == "running";
        bool isPending = status == "pending";

        // Determine the status look based on the current round's status
        if (isCompleted) {
          iconColor = Colors.blue;
          lineColor = Colors.blue;
          statusText = "Completed";
        } else if (isRunning) {
          iconColor = Colors.green;
          lineColor = Colors.green;
          statusText = "Ongoing";
        } else { // pending or any other status
          iconColor = Colors.grey;
          lineColor = Colors.grey;
          statusText = "Upcoming";
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
            beforeLineStyle: LineStyle(color: _getBeforeLineColor(index), thickness: 3),
            afterLineStyle: LineStyle(color: _getAfterLineColor(index), thickness: 3),
            endChild: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListTile(
                title: Text(
                  rounds[index].roundName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(statusText),
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method to determine the color of the line before current node
  Color _getBeforeLineColor(int index) {
    if (index == 0) return Colors.transparent;
    
    String prevStatus = rounds[index - 1].status.toLowerCase();
    bool isPrevCompleted = prevStatus == "completed" || prevStatus == "compeleted";
    bool isPrevRunning = prevStatus == "running";
    
    if (isPrevCompleted) return Colors.blue;
    if (isPrevRunning) return Colors.green;
    return Colors.grey;
  }

  // Helper method to determine the color of the line after current node
  Color _getAfterLineColor(int index) {
    if (index == rounds.length - 1) return Colors.transparent;
    
    String currentStatus = rounds[index].status.toLowerCase();
    bool isCurrentCompleted = currentStatus == "completed" || currentStatus == "compeleted";
    bool isCurrentRunning = currentStatus == "running";
    
    if (isCurrentCompleted) return Colors.blue;
    if (isCurrentRunning) return Colors.green;
    return Colors.grey;
  }

  void _handleRoundTap(BuildContext context, int index) {
    // Find the last completed round index
    int lastCompletedIndex = -1;
    for (int i = rounds.length - 1; i >= 0; i--) {
      String status = rounds[i].status.toLowerCase();
      if (status == "completed" || status == "compeleted") {
        lastCompletedIndex = i;
        break;
      }
    }

    // If all rounds are completed, allow navigation to the last round
    bool allCompleted = rounds.every((round) {
      String status = round.status.toLowerCase();
      return status == "completed" || status == "compeleted";
    });
    
    String currentStatus = rounds[index].status.toLowerCase();
    bool isCurrentCompleted = currentStatus == "completed" || currentStatus == "compeleted";
    
    if ((isCurrentCompleted && index == lastCompletedIndex) || 
        (allCompleted && index == rounds.length - 1)) {
      // Navigate only if the tapped round is the last completed round
      // OR if all rounds are completed and this is the last round
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