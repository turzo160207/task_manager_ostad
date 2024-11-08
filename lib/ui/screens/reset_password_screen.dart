import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_ostad/ui/screens/forgot_password_otp_screen.dart';
import 'package:task_manager_ostad/ui/screens/sign_in_screen.dart';
import 'package:task_manager_ostad/ui/utils/app_colors.dart';
import 'package:task_manager_ostad/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_ostad/ui/widgets/screen_background.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  ResetPasswordScreen({Key? key, required this.email, required this.otp}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  bool _isPasswordResetInProgress = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 82,
                ),
                Text(
                  'Set Password',
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Minimum length password 8 character with letter and number combination',
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                _buildResetPasswordForm(),
                SizedBox(
                  height: 48,
                ),
                Center(
                  child: _buildHaveAccountSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _passwordTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Password'),
            validator: (String? value){
              if (value?.trim().isEmpty ?? true){
                return 'Enter new password';
              }
              return null;
            },
          ),
          SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _confirmPasswordTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Confirm Password'),
            validator: (String? value){
              if (value?.trim().isEmpty ?? true){
                return 'Enter your email';
              }
              return null;
            },
          ),
          SizedBox(
            height: 24,
          ),
          Visibility(
            visible: !_isPasswordResetInProgress,
            replacement: CenteredCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTapNextButton,
              child: Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHaveAccountSection() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
        text: "Have account?",
        children: [
          TextSpan(
              text: 'Sign In',
              style: TextStyle(
                color: AppColors.themeColor,
              ),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignIn),
        ],
      ),
    );
  }

  void _onTapNextButton() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _passwordReset();
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen()),
    //         (_) => false
    // );
  }
  Future<void> _passwordReset() async {
    _isPasswordResetInProgress = true;
    setState(() {});

    print(widget.email);
    print(widget.otp);

    Map<String, dynamic> requestBody = {
      'email' : widget.email,
      "OTP": widget.otp,
      'password' : _passwordTEController.text,
    };

    final NetworkResponse response =
    await NetworkCaller.postRequest(url: Urls.resetPassword, body: requestBody);
    _isPasswordResetInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      // await AuthController.saveAccessToken(response.responseData['token']);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
            (value) => false,
      );
    } else if(_passwordTEController.text.trim() != _confirmPasswordTEController.text.trim()){
      showSnackBarMessage(context, "The passwords don't match", true);
    }
    else if(_passwordTEController.text.trim() != _confirmPasswordTEController.text.trim()){
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen()),
            (_) => false
    );
  }
}
