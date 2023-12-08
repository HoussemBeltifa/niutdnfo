import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Flight {
  final String departureAirport;
  final String arrivalAirport;

  Flight({required this.departureAirport, required this.arrivalAirport});
}

Future<List<Flight>> fetchFlights() async {
  final response = await http.get(Uri.parse(
      'http://api.aviationstack.com/v1/flights?access_key=516fd59d80b35f8d5918c511532e1f45'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final flightsData = jsonData['data'] as List<dynamic>;

    return flightsData.map((flightData) {
      final departureAirport =
          flightData['departure']['airport'] ?? 'Unknown Departure Airport';
      final arrivalAirport =
          flightData['arrival']['airport'] ?? 'Unknown Arrival Airport';

      return Flight(
        departureAirport: departureAirport,
        arrivalAirport: arrivalAirport,
      );
    }).toList();
  } else {
    throw Exception('Failed to load flights');
  }
}

class FlightListScreen extends StatefulWidget {
  @override
  _FlightListScreenState createState() => _FlightListScreenState();
}

class _FlightListScreenState extends State<FlightListScreen> {
  late Future<List<Flight>> _flightsFuture;
  List<Flight> _filteredFlights = [];
  bool _showListView = false; // Add this variable

  var searchcontroller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _flightsFuture = fetchFlights();
  }

  void _filterFlights(String query) {
    _flightsFuture.then((flights) {
      setState(() {
        _filteredFlights = flights
            .where((flight) =>
                flight.departureAirport
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                flight.arrivalAirport
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
        _showListView = true; // Show the ListView when filtering
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Flight List')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchcontroller,
              onChanged: _filterFlights,
              decoration: InputDecoration(
                labelText: 'Search Airport',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Toggle Confirm Travel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showListView =
                    !_showListView; // Toggle the visibility of ListView
              });
            },
            child: Text('Toggle ListView'),
          ),
          if (_showListView)
            Expanded(
                child: FutureBuilder<List<Flight>>(
              future: _flightsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No flights available.'));
                } else {
                  final flights = _filteredFlights.isNotEmpty
                      ? _filteredFlights
                      : snapshot.data!;

                  return ListView.builder(
                      itemCount: flights.length,
                      itemBuilder: (context, index) {
                        final flight = flights[index];
                        return ElevatedButton(
                          onPressed: () {
                            searchcontroller.text = flight.departureAirport;
                            // Implement the action you want when the button is pressed
                            print(
                                'Button pressed for flight: ${flight.departureAirport}');
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.white),
                          ),
                          child: ListTile(
                            title:
                                Text('Departure: ${flight.departureAirport}'),
                            subtitle: Text('Arrival: ${flight.arrivalAirport}'),
                          ),
                        );
                      });
                }
              },
            ))
        ]));
  }
}
