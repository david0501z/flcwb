import 'package:riverpod/riverpod.dart';

mixin AutoDisposeNotifierMixin<T> {
  set value(T value) {
    onUpdate(value);
  }

  bool updateShouldNotify(T previous, T next) {
    final res = previous != next;
    if (res) {
      onUpdate(next);
    }
    return res;
  }

  void onUpdate(T value) {}
}

mixin AnyNotifierMixin<T> {
  T get value;

  set value(T value) {
    onUpdate(value);
  }

  bool updateShouldNotify(T previous, T next) {
    final res = previous != next;
    if (res) {
      onUpdate(next);
    }
    return res;
  }

  void onUpdate(T value) {}
}
