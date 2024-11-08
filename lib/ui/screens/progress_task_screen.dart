import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool _getInProgressTaskListInProgress = false;
  List<TaskModel> _inProgressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_getInProgressTaskListInProgress,
      replacement: const CenteredCircularProgressIndicator(),
      child: RefreshIndicator(
        onRefresh: () async {
          _getCompletedTaskList();
        },
        child: ListView.separated(
          itemCount: _inProgressTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskModel: _inProgressTaskList[index],
              onRefreshList: _getCompletedTaskList,
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8);
          },
        ),
      ),
    );
  }

  Future<void> _getCompletedTaskList() async {
    _inProgressTaskList.clear();
    _getInProgressTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.inProgressTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _inProgressTaskList = taskListModel.taskList ?? [];
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getInProgressTaskListInProgress = false;
    setState(() {});
  }
}
