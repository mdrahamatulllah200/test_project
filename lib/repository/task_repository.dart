import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../data/models/task.dart';

class TaskRepository {
  final Box<Task> taskBox = Hive.box<Task>('tasks');
  Future<List<Task>> fetchTasks() async {
    final url = Uri.parse('https://695fd9b27f037703a8150672.mockapi.io/tasks');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        var datas = data.map((e) => Task.fromJson(e)).toList();

        await taskBox.clear();
        await taskBox.addAll(datas);
        return datas;
      } else {
        throw Exception(
            'Failed to load tasks (Status: ${response.statusCode})');
      }
    } catch (e) {
      // Handle network errors
      throw Exception('Network error: $e');
    }
  }

  // Fetch from Hive cache
  Future<List<Task>> fetchCachedTasks() async {
    return taskBox.values.toList();
  }
}
