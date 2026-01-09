import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/app/page/bloc/task_bloc.dart';


class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    context.read<TaskBloc>().add(LoadTasks()); // ❌ Called on every build
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskLoaded) {
            return ListView(
              children: state.tasks.map((task) {
                return ListTile(
                  title: Text(task.title),
                  trailing: Checkbox(
                    value: task.completed,
                    onChanged: (_) {
                      context.read<TaskBloc>().add(ToggleTaskStatus(task.id));
                    },
                  ),
                );
              }).toList(),
            );
          }

          if (state is TaskError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
