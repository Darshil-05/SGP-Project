import 'package:charusat_recruitment/screens/models/announcement_model.dart';
import 'package:flutter/material.dart';

class AnnounceCard extends StatefulWidget {
  const AnnounceCard({super.key, required this.announce});

  final AnnouncementModel announce;
  @override
  State<AnnounceCard> createState() => _AnnounceCardState();
}

class _AnnounceCardState extends State<AnnounceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 360,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.blue,
            Colors.blue.withOpacity(0.5)
          ], 
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight,
          ),
            boxShadow: [ BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 1,
              offset: Offset(1, 4)
            ), BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 1,
              offset: const Offset(2, 6)
            ),],
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.announce.title,
            style: const TextStyle(
                fontSize: 24, fontFamily: "pop", color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.announce.subtitle,
            maxLines: 2,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontSize: 17, color: Colors.white.withOpacity(0.7)),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(widget.announce.companyName,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white))
        ],
      ),
    );
  }
}
