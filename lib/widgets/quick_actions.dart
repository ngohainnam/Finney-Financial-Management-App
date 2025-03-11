import 'package:flutter/material.dart';
import 'package:visualize_infinance/models/expense_model.dart';
import 'package:visualize_infinance/utils/constants.dart';


class QuickActionsWidget extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsWidget({
    Key? key,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((action) {
            return GestureDetector(
              onTap: action.onTap,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    decoration: BoxDecoration(
                      color: action.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
                    ),
                    child: Icon(
                      action.icon,
                      color: action.color,
                      size: AppDimensions.iconSizeLarge,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    action.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}