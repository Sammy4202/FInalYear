import 'package:flutter/material.dart';

class TransportationData {
  final double latitude;
  final double longitude;
  final String type; // "traffic_incident", "road_closure", "transit_change"
  final String description;
  final DateTime timestamp;
  final int? upvotes; // Optional
  final int? downvotes; // Optional
  final String? userId; // Optional for user attribution

  TransportationData({
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.description,
    required this.timestamp,
    this.upvotes,
    this.downvotes,
    this.userId,
  });
}

class ReportForm extends StatefulWidget {
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  String _selectedOption = "";
  final _formKey = GlobalKey<FormState>();

  // Define options for dropdown menu based on report type
  final List<String> _reportOptions = [
    "Traffic Incident",
    "Road Closure",
    "Transit Service Change",
  ];

  // Text editing controllers for user input
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField(
            value: _selectedOption,
            hint: Text("Report Type"),
            items: _reportOptions.map((option) => DropdownMenuItem(
              value: option,
              child: Text(option),
            )).toList(),
            onChanged: (value) {
              setState(() {
                _selectedOption = value.toString();
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select a report type";
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: "Description",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please provide a description";
              }
              return null;
            },
          ),
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: "Location (optional)",
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Handle form submission logic here (send report data)
                // You can access user input through controllers
                print("Report Type: $_selectedOption");
                print("Description: ${_descriptionController.text}");
                print("Location: ${_locationController.text}");
                // Clear form after submission
                _formKey.currentState!.reset();
                _selectedOption = "";
                _descriptionController.text = "";
                _locationController.text = "";
              }
            },
            child: Text("Submit Report"),
          ),
        ],
      ),
    );
  }
}
