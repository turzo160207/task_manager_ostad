import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_ostad/ui/screens/forgot_password_otp_screen.dart';
import 'package:task_manager_ostad/ui/utils/app_colors.dart';
import 'package:task_manager_ostad/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_ostad/ui/widgets/screen_background.dart';

import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/auth_controller.dart';
import '../widgets/snack_bar_message.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({Key? key}) : super(key: key);



  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  bool _isEmailVerificationInProgress = false;

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
                  'Your Email Address',
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'A 6 digits verification otp will be sent to your email address',
                  style: textTheme.titleSmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                _buildVerifyEmailForm(),
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

  Widget _buildVerifyEmailForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Email'),
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
            visible: !_isEmailVerificationInProgress,
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

    _verifyEmail();
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ForgotPasswordOtpScreen(),
    //   ),
    // );
  }
  Future<void> _verifyEmail() async {
    _isEmailVerificationInProgress = true;
    setState(() {});

    String email = _emailTEController.text.trim();

    String urlWithEmail = '${Urls.verifyEmail}/$email';

    final NetworkResponse response = await NetworkCaller.getRequest(
        url: urlWithEmail,
    );
    _isEmailVerificationInProgress = false;
    setState(() {});
    if (response.isSuccess) {

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ForgotPasswordOtpScreen(email: email)),
            (value) => false,
      );
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void _onTapSignIn() {
    Navigator.pop(context);
  }
}
