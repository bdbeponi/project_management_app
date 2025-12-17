  import 'package:flutter/foundation.dart';
  import 'package:rxdart/subjects.dart';

  abstract class BaseViewModel<T> extends ChangeNotifier {
    /// --- Common States ---
    bool _isLoading = false;
    String? _errorMessage;
    T? _data;

    final BehaviorSubject<T> _subject;

    BaseViewModel(T empty)
        : _data = empty,
          _subject = BehaviorSubject<T>.seeded(empty);

    /// --- Getters ---
    bool get isLoading => _isLoading;
    String? get errorMessage => _errorMessage;
    T? get data => _data;
    Stream<T> get stream => _subject.stream;

    /// --- Core Methods ---
    Future<void> fetchData(Future<T> Function() fetcher) async {
      _setLoading(true);
      _setError(null);

      try {
        final result = await fetcher();
        _data = result;
        _subject.add(result);
        notifyListeners();
      } catch (e) {
        _setError(e.toString());
      } finally {
        _setLoading(false);
      }
    }

    Future<void> refresh(Future<T> Function() fetcher) => fetchData(fetcher);

    void _setLoading(bool value) {
      _isLoading = value;
      notifyListeners();
    }

    void _setError(String? value) {
      _errorMessage = value;
      notifyListeners();
    }

    @override
    void dispose() {
      _subject.close();
      super.dispose();
    }
  }
