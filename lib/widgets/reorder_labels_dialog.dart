import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ReorderLabelsDialog extends StatefulWidget {
  final List<String> labels;
  final Function(List<String>) onReorder;
  final bool isDarkMode;

  const ReorderLabelsDialog({
    Key? key,
    required this.labels,
    required this.onReorder,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<ReorderLabelsDialog> createState() => _ReorderLabelsDialogState();
}

class _ReorderLabelsDialogState extends State<ReorderLabelsDialog> {
  late List<String> _reorderedLabels;

  @override
  void initState() {
    super.initState();
    _reorderedLabels = List.from(widget.labels);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.cardColor(widget.isDarkMode),
      title: Text(
        'Reorder Labels',
        style: TextStyle(
          color: AppTheme.textColor(widget.isDarkMode),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Long press and drag to reorder labels',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.inputBackgroundColor(widget.isDarkMode),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ReorderableListView(
                  padding: const EdgeInsets.all(12),
                  children: _reorderedLabels.asMap().entries.map((entry) {
                    return Padding(
                      key: ValueKey(entry.value),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.cardColor(widget.isDarkMode),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.shadowColor(widget.isDarkMode),
                              spreadRadius: 0.5,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            entry.value,
                            style: TextStyle(
                              color: AppTheme.textColor(widget.isDarkMode),
                            ),
                          ),
                          leading: Icon(
                            Icons.drag_indicator,
                            color: AppTheme.subTextColor(widget.isDarkMode),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final String item = _reorderedLabels.removeAt(oldIndex);
                      _reorderedLabels.insert(newIndex, item);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: AppTheme.subTextColor(widget.isDarkMode),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onReorder(_reorderedLabels);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
