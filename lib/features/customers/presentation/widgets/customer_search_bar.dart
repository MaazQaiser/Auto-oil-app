import 'package:flutter/material.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/widgets/search_field.dart';

/// Search bar for filtering customers by name, phone, or city.
class CustomerSearchBar extends StatelessWidget {
  const CustomerSearchBar({
    super.key,
    required this.onChanged,
    this.controller,
    this.hint = 'Search by name, phone, or city',
  });

  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return SearchField(
      controller: controller,
      hint: hint.isEmpty ? StringConstants.search : hint,
      onChanged: onChanged,
    );
  }
}
