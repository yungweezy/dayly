import 'package:dayly/models/schedulable.dart';
import 'package:flutter/foundation.dart';
import 'package:dayly/models/task.dart';
import 'dart:collection';
import 'package:flutter/material.dart';

class TaskData extends ChangeNotifier {
  int _finishedTaskCount = 0;

  List<Task> _tasks = [];
  List<Schedulable> _schedules = [];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  UnmodifiableListView<Schedulable> get schedules {
    return UnmodifiableListView(_schedules);
  }

  int get taskCount {
    return _tasks.length;
  }

  int get finishedTaskCount {
    return _finishedTaskCount;
  }

  set finishedTaskNum(int finishedTask) {
    _finishedTaskCount = finishedTask;
  }

  //Add new task to list
  void addTask(String taskTitle, String taskDescription, String tag,
      int priorityScore, int duration) {
    final task = Task(
      name: taskTitle,
      description: taskDescription,
      tag: tag,
      priorityScore: priorityScore,
      duration: duration,
    );
    _tasks.add(task);
    notifyListeners();
  }

  //Update the status of task
  void updateTask(Task task) {
    if (!task.isDone) {
      _finishedTaskCount += 1;
    } else {
      _finishedTaskCount -= 1;
    }
    task.toggleDone();
    notifyListeners();
  }

  void deleteTask(Task task) async {
    if (task.isDone) {
      _finishedTaskCount -= 1;
    }
    _tasks.remove(task);
    notifyListeners();
  }

  set taskList(List<Task> taskList) {
    _tasks = taskList;
    notifyListeners();
  }

  List<Schedulable> toSchedule() {
    List<Schedulable> scheduleList = [];
    for (int i = 0; i < this.taskCount; i++) {
      if (!this._tasks[i].isDone) {
        scheduleList.add(this._tasks[i].toSchedulable());
      }
    }
    return scheduleList;
  }

  set scheduleList(List<Schedulable> scheduleList) {
    _schedules = scheduleList;
    notifyListeners();
  }

  void deleteSchedulable() async {
    _schedules = [];
    notifyListeners();
  }
}
