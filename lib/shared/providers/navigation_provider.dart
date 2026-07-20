import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the selected bottom-navigation index.
final navigationIndexProvider = StateProvider<int>((ref) => 0);
