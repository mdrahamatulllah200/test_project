part of 'task_bloc.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class ToggleTaskStatus extends TaskEvent {
  final int taskId;
  ToggleTaskStatus(this.taskId);
}
