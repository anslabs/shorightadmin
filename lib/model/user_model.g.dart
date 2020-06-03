// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
    json['email'] as String,
    json['photoUrl'] as String,
    json['phoneNumber'] as String,
    json['username'] as String,
    json['gender'] as String,
    json['birthDate'] as String,
    json['adress'] as String,
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'phoneNumber': instance.phoneNumber,
      'username': instance.username,
      'gender': instance.gender,
      'birthDate': instance.birthDate,
      'adress': instance.adress,
    };
