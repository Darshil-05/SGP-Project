
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CompanyLiveStatus extends StatelessWidget {
  final List<String>? rounds; // Nullable for safety
  final int? ongoingRoundIndex;

  const CompanyLiveStatus({
    Key? key,
    required this.rounds,
    required this.ongoingRoundIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fallback if rounds or ongoingRoundIndex is null
    if (rounds == null || ongoingRoundIndex == null) {
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
      itemCount: rounds!.length,
      itemBuilder: (context, index) {
        // Handle invalid ongoingRoundIndex
        if (ongoingRoundIndex! < 0 || ongoingRoundIndex! >= rounds!.length) {
          return Center(
            child: Text(
              'Invalid ongoing round index',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }

        Color iconColor;
        Color lineColor;

        if (index < ongoingRoundIndex!) {
          // Completed rounds
          iconColor = Colors.green;
          lineColor = Colors.green;
        } else if (index == ongoingRoundIndex) {
          // Ongoing round
          iconColor = Colors.blue;
          lineColor = Colors.blue;
        } else {
          // Upcoming rounds
          iconColor = Colors.grey;
          lineColor = Colors.grey;
        }

        return GestureDetector(
          onTap: () => _showRoundDetails(context, rounds![index]),
          child: TimelineTile(
            isFirst: index == 0,
            isLast: index == rounds!.length - 1,
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
                  rounds![index],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  index < ongoingRoundIndex!
                      ? 'View student list'
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
  void _showRoundDetails(BuildContext context, String roundName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Round Details'),
        content: Text('You selected: $roundName'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).popAndPushNamed('/studentlist');
              
              },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
