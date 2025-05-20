import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppNavbar extends StatelessWidget {
  final Function(String)? onSearchSubmitted;
  final TextEditingController _searchController = TextEditingController();

  AppNavbar({
    super.key,
    this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Ask me financial question...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none, 
              ),
              filled: true,
              fillColor: AppColors.blurGray.withValues(alpha: 0.2), 
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send_rounded, color: AppColors.darkBlue),
                onPressed: () {
                  if (_searchController.text.isNotEmpty && onSearchSubmitted != null) {
                    onSearchSubmitted!(_searchController.text);
                    _searchController.clear();
                  }
                },
              ),
            ),
            textInputAction: TextInputAction.send,
            onSubmitted: (value) {
              if (value.isNotEmpty && onSearchSubmitted != null) {
                onSearchSubmitted!(value);
                _searchController.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}