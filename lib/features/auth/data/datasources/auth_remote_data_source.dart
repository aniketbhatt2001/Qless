import 'package:dio/dio.dart';
import 'package:canteen_mangement/core/constants/api_endpoints.dart';
import 'package:canteen_mangement/core/errors/app_error_handler.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/update_profile_request_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<AuthResponseModel> register(RegisterRequestModel request);
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(UpdateProfileRequestModel request);
  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post(ApiEndpoints.login, data: request.toJson());
      return AuthResponseModel.fromJson(response.data);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _dio.post(ApiEndpoints.register, data: request.toJson());
      return AuthResponseModel.fromJson(response.data);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.getProfile);
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<UserModel> updateProfile(UpdateProfileRequestModel request) async {
    try {
      final response = await _dio.put(ApiEndpoints.updateProfile, data: request.toJson());
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _dio.delete(ApiEndpoints.deleteAccount);
    } catch (e) {
      throw AppErrorHandler.handle(e);
    }
  }
}
