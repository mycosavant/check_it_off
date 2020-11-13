import 'package:check_it_off/models/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  test('Task Equals Task', () {
    DateTime order = DateTime.now();
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    var testDate = formatter.format(order);
    Task task1 = Task(
        name: 'test',
        isDone: false,
        recurring: false,
        numberOfRecurrences: 0,
        interval: recurrenceInterval.None,
        priority: priorityLevel.Normal,
        dueDate: testDate.toString());

    Task task2 = Task(
        name: 'test',
        isDone: false,
        recurring: false,
        numberOfRecurrences: 0,
        interval: recurrenceInterval.None,
        priority: priorityLevel.Normal,
        dueDate: testDate.toString());

    expect(task1, task2);
  });

  test('Task Not Equal Task', () {
    DateTime order = DateTime.now();
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    var testDate = formatter.format(order);
    Task task1 = Task(
        name: 'test',
        isDone: false,
        recurring: false,
        numberOfRecurrences: 0,
        interval: recurrenceInterval.None,
        priority: priorityLevel.Normal,
        dueDate: testDate.toString());

    Task task2 = Task(
        name: 'different test',
        isDone: false,
        recurring: false,
        numberOfRecurrences: 0,
        interval: recurrenceInterval.None,
        priority: priorityLevel.Normal,
        dueDate: testDate.toString());

    expect(task1, isNot(equals(task2)));
  });

  test('Task properties', () {
    DateTime order = DateTime.now();
    DateFormat formatter = DateFormat('MM/dd/yyyy');
    var testDate = formatter.format(order);
    Task task1 = Task(
        name: 'test',
        isDone: false,
        recurring: false,
        numberOfRecurrences: 0,
        interval: recurrenceInterval.None,
        priority: priorityLevel.Normal,
        dueDate: testDate.toString());
    expect(task1.name, 'test');
    expect(task1.isDone, false);
    expect(task1.recurring, false);
    expect(task1.numberOfRecurrences, 0);
    expect(task1.interval, recurrenceInterval.None);
    expect(task1.priority, priorityLevel.Normal);
    expect(task1.dueDate, testDate.toString());
  });
}
