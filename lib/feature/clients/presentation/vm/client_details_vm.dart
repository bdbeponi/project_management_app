import 'package:flutter/material.dart';
import 'package:project_management/feature/clients/data/repositories/client_details_repo.dart';
import 'package:project_management/feature/clients/model/client_details_response_model.dart';

class ClientDetailsVM extends ChangeNotifier {
  final ClientDetailsRepository _repository;

  ClientDetailsVM({ClientDetailsRepository? repository})
    : _repository = repository ?? ClientDetailsRepository();

  Data? client;
  bool isLoading = false;
  String? errorMessage;

  /// Fetch client details by ID
  Future<void> fetchClientDetails(String? clientId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final response = await _repository.getClientDetails(clientId: clientId);

    if (response.success == true && response.data != null) {
      client = response.data;
      errorMessage = null;
    } else {
      client = null;
      errorMessage = response.message ?? 'Failed to load client details';
    }

    isLoading = false;
    notifyListeners();
  }

  /// Refresh current client details
  Future<void> refresh(String clientId) async {
    await fetchClientDetails(clientId);
  }
}
