import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 251, 192),
      ),
      home: const MyHomePage(title: 'MyPlanner+'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Meeting> meetings = <Meeting>[];

  List<Meeting> _getDataSource() {
    return meetings;
  }

  void _addActivity() {
    setState(() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var focusController = TextEditingController();
          var timeController = TextEditingController();
          return AlertDialog(
            scrollable: true,
            title: Text('Entry'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: focusController,
                      decoration: InputDecoration(
                        labelText: 'Focus',
                        icon: Icon(Icons.account_box),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Time',
                        icon: Icon(Icons.access_time),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Tags',
                        icon: Icon(Icons.message),
                      ),
                    ),
                    ElevatedButton(
                      child: Text("Start Task"),
                      onPressed: () {
                        setState(() {
                          final DateTime today = DateTime.now();
                          final DateTime startTime =
                            DateTime(today.year, today.month, today.day, 9, 0, 0);
                          final DateTime endTime = startTime.add(const Duration(hours: 1));

                          var newMeeting = Meeting(
                            focusController.text,
                            startTime,
                            endTime,
                            const Color(0xFF0F8644),
                            false,
                          );

                          newMeeting.isTimerRunning = true;
                          newMeeting.stopwatch.start();

                          meetings.add(newMeeting);
                        });
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SecondRoute()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text("Submit"),
                onPressed: () {
                  setState(() {
                    final DateTime today = DateTime.now();
                    final DateTime startTime =
                      DateTime(today.year, today.month, today.day, 9, 0, 0);
                    final DateTime endTime = startTime.add(const Duration(hours: 1));
                    meetings.add(
                      Meeting(focusController.text, startTime, endTime, const Color(0xFF0F8644), false)
                    );
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              ),
            ],
          );
        }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SfCalendar(
              dataSource: MeetingDataSource(_getDataSource()),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivity,
        tooltip: 'New Activity',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Put your pause functionality here
          },
          child: Icon(
            Icons.pause,
            size: 48.0,
          ),
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  bool isTimerRunning(int index) {
    return appointments![index].isTimerRunning;
  }

  int getElapsedSeconds(int index) {
    return appointments![index].elapsedSeconds;
  }
  
  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  bool isTimerRunning = false; // Indicates whether the timer is running
  int elapsedSeconds = 0; // Stores the elapsed time in seconds
  Stopwatch stopwatch = Stopwatch(); // Stopwatch to measure elapsed time

}