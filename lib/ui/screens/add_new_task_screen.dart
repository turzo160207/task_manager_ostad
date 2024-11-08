import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_ostad/data/models/network_response.dart';
import 'package:task_manager_ostad/data/services/network_caller.dart';
import 'package:task_manager_ostad/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_ostad/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_ostad/ui/widgets/tm_app_bar.dart';

import '../../data/utils/urls.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;
  bool _shouldRefreshPreviousPage = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result){
        if( didPop){
          return;
        }
        Navigator.pop(context, _shouldRefreshPreviousPage);
      },
      child: Scaffold(
        appBar: TMAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 42,
                  ),
                  Text(
                    'Add New Task',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    controller: _titleTEController,
                    decoration: InputDecoration(hintText: 'Tite'),
                    validator: (String? value){
                      if(value?.trim().isEmpty?? true){
                        return 'Enter a value';
                      }
                      return null;
                    }
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _descriptionTEController,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: 'Description'
                    ),
                      validator: (String? value){
                        if(value?.trim().isEmpty?? true){
                          return 'Enter a value';
                        }
                        return null;
                      }
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: !_addNewTaskInProgress,
                    replacement:  CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                        onPressed: _onTapSubmitButton,
                        child: Icon(Icons.arrow_circle_right_outlined)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _onTapSubmitButton(){
    if(_formKey.currentState!.validate()){
      _addNewTask();
    }
  }
  Future<void> _addNewTask() async{
    _addNewTaskInProgress = true;
    setState(() {

    });
    Map<String, dynamic> requestBody = {
      'title': _titleTEController.text.trim(),
      'description': _descriptionTEController.text.trim(),
      'status': 'New',
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.addNewTask,body: requestBody);

    _addNewTaskInProgress = false;
    setState(() {

    });
    if (response.isSuccess){
      _shouldRefreshPreviousPage = true;
      _clearTextField();
      showSnackBarMessage(context, 'New Task added!');
    } else{
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void _clearTextField(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }
}
