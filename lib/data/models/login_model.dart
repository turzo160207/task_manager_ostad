import 'package:task_manager_ostad/data/models/user_model.dart';

// class LoginModel {
//   String? status;
//   UserModel? data; // Change this to a single UserModel
//   String? token;
//
//   LoginModel({this.status, this.data, this.token});
//
//   LoginModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//
//     // Parse `data` as a single UserModel object, not a list
//     data = json['data'] != null ? UserModel.fromJson(json['data']) : null;
//
//     token = json['token'];
//   }
// }

class LoginModel {
  String? status;
  UserModel? data;
  String? token;

  LoginModel({this.status, this.data, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UserModel.fromJson(json['data']) : null;
    token = json['token'];
  }
}


// class LoginModel {
//   String? status;
//   List<UserModel>? data;
//   String? token;
//
//   LoginModel({this.status, this.data, this.token});
//
//   LoginModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['data'] != null) {
//       data = <UserModel>[];
//       json['data'].forEach((v) {
//         data!.add(UserModel.fromJson(v));
//       });
//     }
//     token = json['token'];
//   }
// }