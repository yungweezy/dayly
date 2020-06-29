import 'package:flutter/material.dart';
import 'package:dayly/components/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:dayly/models/task_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayly/services/database.dart';
import 'package:dayly/models/user.dart';
import 'package:dayly/models/task.dart';

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          padding: EdgeInsets.only(top: 5),
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: UniqueKey(),
              onDismissed: (direction) async {
                setState(() {
                  taskData.deleteTask(task);
                });
                await DatabaseService(uid: _user.uid).deleteTask(task);
              },
              child: TaskTile(
                taskTitle: task.name,
                taskDescription: task.description,
                isChecked: task.isDone,
                checkboxCallback: (checkboxState) async {
                  taskData.updateTask(task);
                  await DatabaseService(uid: _user.uid)
                      .updateTask(task, task.isDone);
                },
                categoryColor: task.color,
              ),
              background: Container(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.blueGrey),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
