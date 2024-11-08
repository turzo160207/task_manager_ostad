import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager_ostad/data/models/network_response.dart';
import 'package:task_manager_ostad/data/models/user_model.dart';
import 'package:task_manager_ostad/data/services/network_caller.dart';
import 'package:task_manager_ostad/ui/controllers/auth_controller.dart';
import 'package:task_manager_ostad/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_ostad/ui/widgets/snack_bar_message.dart';
import 'package:task_manager_ostad/ui/widgets/tm_app_bar.dart';

import '../../data/utils/urls.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? _selectedImage;
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setUserData();
  }

  void _setUserData() {
    _emailTEController.text = AuthController.userData?.email ?? '';
    _firstNameTEController.text = AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _phoneTEController.text = AuthController.userData?.mobile ?? '';
    _passwordTEController.text = AuthController.userData?.password ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        isProfileScreenOpen: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 48,
                ),
                Text(
                  'Update Profile',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 32,
                ),
                _buildPhotoPicker(),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  enabled: false,
                  controller: _emailTEController,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (String? value){
                    if (value?.trim().isEmpty ?? true){
                      return 'Enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _firstNameTEController,
                  decoration: InputDecoration(hintText: 'First Name'),
                  validator: (String? value){
                    if (value?.trim().isEmpty ?? true){
                      return 'Enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: InputDecoration(hintText: 'Last Name'),
                  validator: (String? value){
                    if (value?.trim().isEmpty ?? true){
                      return 'Enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _phoneTEController,
                  decoration: InputDecoration(hintText: 'Phone'),
                  validator: (String? value){
                    if (value?.trim().isEmpty ?? true){
                      return 'Enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _passwordTEController,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                SizedBox(
                  height: 16,
                ),
                Visibility(
                  visible: _updateProfileInProgress == false,
                  replacement:  CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProfile();
                      }
                    },
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _phoneTEController.text.trim(),
    };

    if (_passwordTEController.text.isNotEmpty) {
      requestBody['password'] = _passwordTEController.text;
    }
    if (_selectedImage != null) {
      List<int> imageBytes = await _selectedImage!.readAsBytes();
      String convertedImage = base64Encode(imageBytes);
      requestBody['photo'] = convertedImage;
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.updateProfile,
      body: requestBody,
    );

    _updateProfileInProgress = false;
    setState(() {

    });

    if (response.isSuccess){
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      showSnackBarMessage(context, 'Profile has been updated!');
    } else{
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(
                _getSelectedPhotoTitle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSelectedPhotoTitle() {
    if (_selectedImage != null) {
      return _selectedImage!.name;
    }
    return 'Select Photo';
  }

  Future<void> _pickImage() async {
    ImagePicker _imagePicker = ImagePicker();
    XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      AuthController.profileImage = pickedImage;
      setState(() {});
    }
  }
}
