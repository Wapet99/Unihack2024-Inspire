import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;
  final List<Meeting> meetings = <Meeting>[];
  List<Meeting> _getDataSource() {

  return meetings;
  }

  void _addActivity() {
    /**/
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
                                hintText: 'activities',
                                icon: Icon(Icons.account_box),
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                labelText: 'Time',
                                hintText: '00:00 - 00:00',
                                icon: Icon(Icons.access_time),
                              ),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Tags',
                                hintText: '#',
                                icon: Icon(Icons.add_chart),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                     actions: [
                      ElevatedButton(
                          child: Text("Submit"),
                          onPressed: () {
                            // your code
                            setState(() {
                            final DateTime today = DateTime.now();
                            final DateTime startTime =
                            DateTime(today.year, today.month, today.day, 9, 0, 0);
                            final DateTime endTime = startTime.add(const Duration(hours: 1));
                            meetings.add(
                            Meeting(focusController.text, startTime, endTime, const Color(0xFF0F8644), false));
                            });
                          })
                    ],
                  );
                });
    /*final DateTime today = DateTime.now();
    final DateTime startTime =
    DateTime(today.year, today.month, today.day, 11, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(
      Meeting('Conference', startTime, endTime, const Color(0xFF0F8644), false));*/
  });
    //setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //_counter++;
    //});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /*const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),*/
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
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
}