import 'package:add_2_calendar/add_2_calendar.dart';

class CalendarHelper{
  CalendarHelper();

  void addTaskToCalendar(Event e){
    Add2Calendar.addEvent2Cal(e);
  }

  Event addEventForCalendar(String title, String description, DateTime dueDate,){
    return Event(
      title: title,
      description: description,
      location: '',
      startDate: dueDate,
      endDate: dueDate,
      timeZone: '',
      allDay: true
    );
  }
}