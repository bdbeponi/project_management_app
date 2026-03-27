import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project_management/feature/clients/data/repositories/client_repo.dart';
import 'package:project_management/feature/clients/model/client_list_response_model.dart';

class ClientsProvider extends ChangeNotifier {
  final ClientRepository _repository;

  ClientsProvider({ClientRepository? repository})
    : _repository = repository ?? ClientRepository();

  // ===================== State =====================

  final List<Item> _clients = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;

  int _currentPage = 1;
  bool _hasMore = true;

  String _search = '';
  String _orderBy = 'desc';
  String? _role;
  String? _status;

  // ===================== Getters =====================

  List<Item> get clients => List.unmodifiable(_clients);

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  int get totalClients => _clients.length;

  int get activeClients => _clients.where((c) => c.isActive == true).length;

  int get inactiveClients => _clients.where((c) => c.isActive == false).length;

  // ===================== Core APIs =====================

  Future<void> fetchClients({bool refresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _clients.clear();
    }

    notifyListeners();

    try {
      final response = await _repository.getClients(
        page: _currentPage,
        search: _search,
        orderBy: _orderBy,
        role: _role,
        status: _status,
        forceRefresh: refresh,
      );

      final items = response.data?.items ?? [];
      final meta = response.data?.meta;

      if (_currentPage == 1) {
        _clients
          ..clear()
          ..addAll(items);
      } else {
        _clients.addAll(items);
      }

      _hasMore = meta == null ? false : meta.currentPage! < meta.lastPage!;

      _currentPage++;
    } catch (e, s) {
      log('Fetch clients failed', error: e, stackTrace: s);
      _errorMessage = 'Failed to load clients';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final response = await _repository.loadNextPage();
      final items = response.data?.items ?? [];

      _clients.addAll(items);
      _hasMore =
          response.data?.meta?.currentPage != response.data?.meta?.lastPage;
    } catch (e) {
      log('Load more failed: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchClients(refresh: true);
  }

  // ===================== Filters =====================

  Future<void> searchClients(String query) async {
    _search = query;
    await fetchClients(refresh: true);
  }

  Future<void> applyFilters({
    String? role,
    String? status,
    String orderBy = 'desc',
  }) async {
    _role = role;
    _status = status;
    _orderBy = orderBy;

    await fetchClients(refresh: true);
  }

  void clearFilters() {
    _search = '';
    _role = null;
    _status = null;
    _orderBy = 'desc';

    fetchClients(refresh: true);
  }

  // ===================== Helpers =====================

  Item? getClientById(String id) {
    try {
      return _clients.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
