import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/api_service.dart';
import '../models/user_model.dart';
import '../models/result_model.dart';
import '../models/resource_model.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.read(apiServiceProvider));
});

final userDashboardProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getDashboard();
});

final statisticsProvider = FutureProvider<StatisticsModel>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getStatistics();
});

final packagesProvider = FutureProvider<List<PackageModel>>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getPackages();
});

final faqProvider = FutureProvider<List<FaqModel>>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getFaq();
});

final resourcesProvider = FutureProvider<List<ResourceModel>>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getResources();
});

final examHistoryProvider = FutureProvider<List<ResultModel>>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getExamHistory();
});

class UserRepository {
  final ApiService _api;

  UserRepository(this._api);

  Future<Map<String, dynamic>> getDashboard() async {
    return _api.getUserDashboard();
  }

  Future<UserModel> getProfile() async {
    final data = await _api.getUserProfile();
    return UserModel.fromJson(data['data'] as Map<String, dynamic>? ?? data);
  }

  Future<UserModel> updateProfile(Map<String, dynamic> updates) async {
    final data = await _api.updateUserProfile(updates);
    return UserModel.fromJson(data['data'] as Map<String, dynamic>? ?? data);
  }

  Future<List<ResultModel>> getExamHistory({int page = 1}) async {
    final data = await _api.getExamHistory(page: page);
    return (data['data'] as List<dynamic>? ?? [])
        .map((e) => ResultModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<StatisticsModel> getStatistics() async {
    final data = await _api.getStatistics();
    return StatisticsModel.fromJson(data['data'] as Map<String, dynamic>? ?? data);
  }

  Future<List<PackageModel>> getPackages() async {
    final data = await _api.getPackages();
    return (data['data'] as List<dynamic>? ?? [])
        .map((e) => PackageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FaqModel>> getFaq() async {
    final data = await _api.getFaq();
    return (data['data'] as List<dynamic>? ?? [])
        .map((e) => FaqModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ResourceModel>> getResources() async {
    final data = await _api.getResources();
    return (data['data'] as List<dynamic>? ?? [])
        .map((e) => ResourceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}