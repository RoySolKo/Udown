import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:udown/pages/home/widget_assets/menu_navigator.dart';
import 'package:udown/pages/home/dayview.dart';
import 'package:udown/services/database.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> with TickerProviderStateMixin {
  Map<DateTime, List> _events = Map();
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print(day);
    events.forEach((element) {
      print(element);
    });
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  Future<void> _initializeEvents() async {
    DateFormat newFormat = DateFormat("yyyy-MM-dd");
    Provider.of<QuerySnapshot>(context,listen: true).docs.forEach((doc) {
      Map unknownType = doc.data()['start'];
      if (unknownType['date'] != null) {
        DateTime date = DateTime.parse(unknownType['date']);
        if (_events[date] == null) {
          _events[date] = List();
          _events[date].add(doc.data()['summary']);
        } else {
          _events[date].add(doc.data()['summary']);
        }
      }
      if (unknownType['dateTime'] != null) {
        DateTime date = DateTime.parse(unknownType['dateTime']);
        String newDate = newFormat.format(date);
        date = DateTime.parse(newDate);
        if (_events[date] == null) {
          _events[date] = List();
          _events[date].add(doc.data()['summary']);
        } else {
          _events[date].add(doc.data()['summary']);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_events.isEmpty) {
      return FutureBuilder<dynamic>(
          future: _initializeEvents(),
          builder: (context, snapshot) => WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  tooltip: "Add a new event",
                  child: Icon(Icons.add),
                  onPressed: null,
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.miniEndFloat,
                appBar: AppBar(leading: Container(), actions: <Widget>[
                  DropMenu(),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 6, 0))
                ]),
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _buildTableCalendarWithBuilders(),
                    Expanded(child: _buildEventList()),
                  ],
                ),
              )));
    } else {
      return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              tooltip: "Add a new event",
              child: Icon(Icons.add),
              onPressed: null,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndFloat,
            appBar: AppBar(leading: Container(), actions: <Widget>[
              DropMenu(),
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 6, 0))
            ]),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildTableCalendarWithBuilders(),
                Expanded(child: _buildEventList()),
              ],
            ),
          ));
    }
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'en_US',
      calendarController: _calendarController,
      events: _events,
      holidays: null,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.twoWeeks: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.red[100],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.green[100],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onDayLongPressed: (day, events) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DayView(today: day)));
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.blue[700]
            : _calendarController.isToday(date)
                ? Colors.blue[700]
                : Colors.blueGrey[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    _selectedEvents.asMap().forEach((key, value) {
      print(key.toString() + " " + value.toString());
    });
    if (_selectedEvents.isNotEmpty) {
      return ListView(
        children: _selectedEvents
            .map((event) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.8),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(event.toString()),
                    //leading: Text,
                    onTap: () => print('$event tapped!'),
                    //onLongPress: () => DayView(event),
                  ),
                ))
            .toList(),
      );
    } else {
      return Center(
          child: Container(child: Image.asset('assets/nothing_todo.gif')));
    }
  }
}
