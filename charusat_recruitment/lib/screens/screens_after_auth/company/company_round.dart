import 'package:flutter/material.dart';

class RoundManager extends StatefulWidget {
  const RoundManager({super.key});

  @override
  State<RoundManager> createState() => _RoundManagerState();
}

class _RoundManagerState extends State<RoundManager> {
  final List<String> _rounds = [
    "Application Deadline",
    "Finalist",
  ];

  // Method to add a new round
  void _addRound() {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Round"),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Round Name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  setState(() {
                    _rounds.insert(_rounds.length - 1, _controller.text.trim());
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Method to delete a round
  void _deleteRound(int index) {
    setState(() {
      _rounds.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Round Manager",
          style: TextStyle(fontFamily: "pop"),
        ),
        backgroundColor: const Color(0xff0f1d2c),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _rounds.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _rounds.removeAt(oldIndex);
                  _rounds.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                return Card(
                  key: ValueKey(_rounds[index]),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: index == _rounds.length - 1 || index == 0
                      ? Colors.white
                      : const Color(0xff0f1d2c),
                  child: ListTile(
                    title: Text(
                      _rounds[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: "pop",
                        color: index == _rounds.length - 1 || index == 0
                            ? const Color(0xff0f1d2c)
                            : Colors.white,
                      ),
                    ),
                    trailing: _rounds[index] != "Application Deadline" &&
                            _rounds[index] != "Finalist"
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteRound(index),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Add Company Button
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ElevatedButton(
              onPressed: () {
                // Add logic for "Add Company" here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0f1d2c),
                minimumSize: const Size(200, 50),
              ),
              child: const Text(
                "Add Company",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRound,
        backgroundColor: const Color(0xff0f1d2c),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
