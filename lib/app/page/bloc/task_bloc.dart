import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:test_project/data/models/task.dart';

import 'package:test_project/repository/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<ToggleTaskStatus>(_onToggleTask);
  }
  final Box<Task> taskBox = Hive.box<Task>('tasks');
  Future<void> _onLoadTasks(TaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());


    //Internet check for offline handling
    final bool isConnected = await InternetConnection().hasInternetAccess;
    if (isConnected) {
      try {
        // Try fetching tasks from repository (API)
        final tasks = await repository.fetchTasks();
        emit(TaskLoaded(tasks));
      } catch (e) {
        // Log error
        debugPrint('Failed to load tasks: $e');

        // Attempt to load cached/offline tasks if available
        try {
          final cachedTasks = await repository.fetchCachedTasks();
          if (cachedTasks.isNotEmpty) {
            emit(TaskLoaded(cachedTasks));
            return; // Exit after loading cache
          }
        } catch (cacheError) {
          debugPrint('Failed to load cached tasks: $cacheError');
        }

        //Emit error if both API and cache fail
        emit(TaskError(
            'Failed to load tasks. Please check your internet connection.'));
      }
    } else {
      // Attempt to load cached/offline tasks if available
      try {
        final cachedTasks = await repository.fetchCachedTasks();
        if (cachedTasks.isNotEmpty) {
          emit(TaskLoaded(cachedTasks));
          return; // Exit after loading cache
        }
      } catch (cacheError) {
        debugPrint('Failed to load cached tasks: $cacheError');
      }
    }
  }

  Future<void> _onToggleTask(
      ToggleTaskStatus event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final tasks = (state as TaskLoaded).tasks;
var localTask;
      final newTasks = tasks.map((task) {
        if (task.id == event.taskId) {
          // Return a new Task with toggled completed   // Update Hive
          localTask= task;

          return Task(
              id: task.id,
              title: task.title,
              completed: !task.completed); // ❌ Mutable update
        } else {
          return task;
        }
      }).toList();

      await taskBox.clear();
      await taskBox.addAll(newTasks);
      emit(TaskLoaded(newTasks)); //UI rebuilds
    }
  }
}
