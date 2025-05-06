import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/localization/locales.dart';

enum TimeRange {
  week,
  month,
  year,
  allTime,
}

class TimeRangeData {
  final TimeRange range;
  final DateTime startDate;
  final DateTime endDate;
  final String label;
  final int? year;

  TimeRangeData({
    required this.range,
    required this.startDate,
    required this.endDate,
    required this.label,
    this.year,
  });

  factory TimeRangeData.week() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(start.year, start.month, start.day);
    return TimeRangeData(
      range: TimeRange.week,
      startDate: startDate,
      endDate: now,
      label: 'thisWeek',
    );
  }

  factory TimeRangeData.month() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return TimeRangeData(
      range: TimeRange.month,
      startDate: start,
      endDate: now,
      label: 'thisMonth',
    );
  }

  factory TimeRangeData.year() {
    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1);
    return TimeRangeData(
      range: TimeRange.year,
      startDate: start,
      endDate: now,
      label: 'thisYear',
    );
  }

  factory TimeRangeData.allTime({int? year}) {
    final now = DateTime.now();
    final selectedYear = year ?? now.year;
    final start = DateTime(selectedYear, 1, 1);
    final end = selectedYear == now.year
        ? now
        : DateTime(selectedYear, 12, 31);
    return TimeRangeData(
      range: TimeRange.allTime,
      startDate: start,
      endDate: end,
      label: 'allTime',
      year: selectedYear,
    );
  }

  // Helper to create a new instance with a different year
  TimeRangeData copyWithYear(int newYear) {
    if (range != TimeRange.allTime) return this;
    return TimeRangeData.allTime(year: newYear);
  }

  String getLocalizedLabel(BuildContext context) {
    switch (label) {
      case 'thisWeek':
        return LocaleData.thisWeek.getString(context);
      case 'thisMonth':
        return LocaleData.thisMonth.getString(context);
      case 'thisYear':
        return LocaleData.thisYear.getString(context);
      case 'allTime':
        return '${LocaleData.allTime.getString(context)} (${year ?? DateTime.now().year})';
      default:
        return label;
    }
  }
}

class TimeRangeSelector extends StatelessWidget {
  final TimeRangeData initialTimeRange;
  final Function(TimeRangeData) onTimeRangeChanged;

  const TimeRangeSelector({
    super.key,
    required this.initialTimeRange,
    required this.onTimeRangeChanged,
  });

  void _showTimeRangeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: TimeRangeOptionsSheet(
          currentTimeRange: initialTimeRange,
          onTimeRangeChanged: (newRange) {
            Navigator.of(context).pop();
            onTimeRangeChanged(newRange);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () => _showTimeRangeModal(context),
            icon: const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
            label: Text(
              initialTimeRange.getLocalizedLabel(context),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          if (initialTimeRange.range == TimeRange.allTime)
            _buildYearNavigationButtons(context),
        ],
      ),
    );
  }

  Widget _buildYearNavigationButtons(BuildContext context) {
    final currentYear = initialTimeRange.year ?? DateTime.now().year;
    final isCurrentYear = DateTime.now().year == currentYear;

    return Row(
      children: [
        // Previous year button
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.primary,
            size: 16,
          ),
          onPressed: () {
            onTimeRangeChanged(initialTimeRange.copyWithYear(currentYear - 1));
          },
        ),

        // Year display
        Text(
          currentYear.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        // Next year button (disable if at current year)
        IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: isCurrentYear ? Colors.grey.shade300 : AppColors.primary,
            size: 16,
          ),
          onPressed: isCurrentYear
              ? null
              : () {
                  if (currentYear < DateTime.now().year) {
                    onTimeRangeChanged(initialTimeRange.copyWithYear(currentYear + 1));
                  }
                },
        ),
      ],
    );
  }
}

class TimeRangeOptionsSheet extends StatefulWidget {
  final TimeRangeData currentTimeRange;
  final Function(TimeRangeData) onTimeRangeChanged;

  const TimeRangeOptionsSheet({
    super.key,
    required this.currentTimeRange,
    required this.onTimeRangeChanged,
  });

  @override
  State<TimeRangeOptionsSheet> createState() => _TimeRangeOptionsSheetState();
}

class _TimeRangeOptionsSheetState extends State<TimeRangeOptionsSheet> {
  late TimeRangeData _selectedTimeRange;

  @override
  void initState() {
    super.initState();
    _selectedTimeRange = widget.currentTimeRange;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              LocaleData.selectTimePeriod.getString(context),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildTimeRangeOption(
            LocaleData.thisWeek.getString(context),
            Icons.view_week,
            TimeRangeData.week(),
          ),
          _buildDivider(),
          _buildTimeRangeOption(
            LocaleData.thisMonth.getString(context),
            Icons.calendar_view_month,
            TimeRangeData.month(),
          ),
          _buildDivider(),
          _buildTimeRangeOption(
            LocaleData.thisYear.getString(context),
            Icons.calendar_today,
            TimeRangeData.year(),
          ),
          _buildDivider(),
          _buildTimeRangeOption(
            LocaleData.allTime.getString(context),
            Icons.all_inclusive,
            TimeRangeData.allTime(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTimeRangeOption(String title, IconData icon, TimeRangeData timeRange) {
    final isSelected = timeRange.range == TimeRange.allTime
        ? _selectedTimeRange.range == TimeRange.allTime
        : _selectedTimeRange.range == timeRange.range;

    return InkWell(
      onTap: () {
        setState(() {
          if (timeRange.range == TimeRange.allTime && _selectedTimeRange.range == TimeRange.allTime) {
            _selectedTimeRange = TimeRangeData.allTime(year: _selectedTimeRange.year);
          } else {
            _selectedTimeRange = timeRange;
          }
        });
        widget.onTimeRangeChanged(_selectedTimeRange);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : Colors.grey.shade600,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.black,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.withValues(alpha: 0.2),
      height: 1,
    );
  }
}