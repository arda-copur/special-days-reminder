// ignore_for_file: unused_element, prefer_final_fields, unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Özel Gün Hatırlatıcısı',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Event {
  String eventType;
  String person;
  DateTime? selectedDate;
  int remainingDays;

  Event({
    required this.eventType,
    required this.person,
    required this.remainingDays,
    this.selectedDate,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _eventTypeController = TextEditingController();
  final TextEditingController _personController = TextEditingController();
  DateTime? _selectedDate;
  List<Event> _events = [];

  void _calculateRemainingDays() {
    
      final now = DateTime.now();
      final difference = _selectedDate!.difference(now).inDays;
       if (_events.isNotEmpty && _events.last.selectedDate != null) {
      final difference = _events.last.selectedDate!.difference(now).inDays;
      setState(() {
        _events.last.remainingDays = difference;
      });
       
    }
  }

  void _addEvent() {
    final eventType = _eventTypeController.text;
    final person = _personController.text;

    if (eventType.isNotEmpty && person.isNotEmpty ) {
      final selectedDate = _dateController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(_dateController.text) : null;
      final remainingDays = selectedDate != null ? selectedDate.difference(DateTime.now()).inDays : 0;

      final newEvent = Event(
        eventType: eventType,
        person: person,
        remainingDays: remainingDays,
        selectedDate: selectedDate,
      );

      setState(() {
        _events.add(newEvent);
      });

      _eventTypeController.clear();
      _personController.clear();
      _dateController.clear();
      _calculateRemainingDays();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[ Container(
          margin: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(image: DecorationImage(image: NetworkImage("https://wallpaperaccess.com/full/1912591.jpg"),
          fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
             
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                 
                  Text(
                    'Tarih Seçin:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(       
                    onPressed: () async {
                      final DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
          
                      if (selectedDate != null) {
                        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
          
                        setState(() {
                          _selectedDate = selectedDate;
                          _calculateRemainingDays();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.black, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    
                    child: Text('Tarih Seç'),
                  ),
                  
                  Text(
                    'Özel Gün Türü:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    
                    controller: _eventTypeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      hintText: 'Doğum Günü, Anneler Günü, vb.',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Kim İçin:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _personController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'İsim',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _addEvent();
                    },
                     style: ElevatedButton.styleFrom(primary: Colors.black, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    child: Text('Etkinlik Ekle'),
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: _events.map((event) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Etkinlik: ${event.eventType}, Kim İçin: ${event.person}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: event.remainingDays / 365,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${event.remainingDays} gün kaldı',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
