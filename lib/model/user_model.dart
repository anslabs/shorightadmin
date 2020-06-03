
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel{

  final String email;
  final String photoUrl;
  final String phoneNumber;
  final String username;
  final String gender;
  final String birthDate;
  final String adress;

  UserModel(this.email, this.photoUrl, this.phoneNumber, this.username,
      this.gender, this.birthDate, this.adress);

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);


  Map<String, dynamic> toJson() => _$UserModelToJson(this);

}