import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_ostad/ui/screens/reset_password_screen.dart';
import 'package:task_manager_ostad/ui/screens/sign_in_screen.dart';
import 'package:task_manager_ostad/ui/utils/app_colors.dart';
import 'package:task_manager_ostad/ui/widgets/screen_background.dart';

import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpScreen({Key? key, required this.email})
      : super(key: key);
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpTEController = TextEditingController();
  bool _isOtpVerificationInProgress = false;

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
                  'Pin Verification',
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'A 6 digits verification otp has been sent to your email address',
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
          PinCodeTextField(
            controller: _otpTEController,
            length: 6,
            obscureText: false,
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              inactiveColor: Colors.grey,
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white,
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter your otp';
              }
              return null;
            },
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
            appContext: context,
          ),
          SizedBox(
            height: 24,
          ),
          ElevatedButton(
            onPressed: _onTapNextButton,
            child: Icon(Icons.arrow_circle_right_outlined),
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

    _verifyOtp();
    // Navigator.push(context,MaterialPageRoute(builder: (context) => ResetPasswordScreen(),),);
  }

  Future<void> _verifyOtp() async {
    _isOtpVerificationInProgress = true;
    setState(() {});

    String otp = _otpTEController.text.trim();
    // String urlWithEmail = '${Urls.verifyEmail}/$email';
    String email = widget.email;

    String urlWithOtp = '${Urls.verifyOTP}/$email/$otp';

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: urlWithOtp,
    );
    _isOtpVerificationInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      print('Email: $email');
      print('OTP: $otp');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: email, otp: otp)),
        (value) => false,
      );
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => SignInScreen()), (_) => false);
  }
}
