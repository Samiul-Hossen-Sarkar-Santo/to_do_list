import 'package:flutter/material.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;
  final List<String> existingLabels;
  final Function(String title, DateTime date, String label, int priority)
      onSave;
  final bool isDarkMode;

  const TaskDialog({
    Key? key,
    this.task,
    required this.existingLabels,
    required this.onSave,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  late String _selectedLabel;
  late int _priority;
  final TextEditingController _newLabelController = TextEditingController();
  bool _isCreatingNewLabel = false;

  // Preset labels
  final List<String> _presetLabels = [
    'Urgent',
    'Shopping',
    'Birthday',
    'Work',
    'Personal'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _selectedDate = widget.task?.date ?? DateTime.now();
    _selectedLabel = widget.task?.label ??
        'Urgent'; // Default to Urgent instead of Unlabeled
    _priority = widget.task?.priority ?? 5;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _newLabelController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create a combined list of existing and preset labels without duplicates
    final List<String> allLabels = [
      ...{...widget.existingLabels, ..._presetLabels}
    ];

    // Ensure the selected label exists in the list
    if (!allLabels.contains(_selectedLabel)) {
      _selectedLabel = allLabels.first;
    }

    return AlertDialog(
      backgroundColor: AppTheme.cardColor(widget.isDarkMode),
      title: Text(
        widget.task == null ? 'Add New Task' : 'Edit Task',
        style: TextStyle(color: AppTheme.textColor(widget.isDarkMode)),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(color: AppTheme.textColor(widget.isDarkMode)),
                decoration: InputDecoration(
                  //labelText: 'Task Title',
                  hintText: 'Enter task title',
                  labelStyle: TextStyle(
                      color: AppTheme.subTextColor(widget.isDarkMode)),
                  hintStyle: TextStyle(
                      color: AppTheme.subTextColor(widget.isDarkMode)
                          .withOpacity(0.7)),
                  filled: true,
                  fillColor: AppTheme.inputBackgroundColor(widget.isDarkMode),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  // These properties fix the label overflow issue
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.inputBackgroundColor(widget.isDarkMode),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  textColor: AppTheme.textColor(widget.isDarkMode),
                  iconColor: Theme.of(context).primaryColor,
                  title: Text('Date',
                      style: TextStyle(
                          color: AppTheme.textColor(widget.isDarkMode))),
                  subtitle: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: TextStyle(
                        color: AppTheme.subTextColor(widget.isDarkMode)),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 16),
              if (!_isCreatingNewLabel) ...[
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.inputBackgroundColor(widget.isDarkMode),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Label',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.subTextColor(widget.isDarkMode),
                        ),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: _selectedLabel,
                        isExpanded: true,
                        dropdownColor:
                            AppTheme.inputBackgroundColor(widget.isDarkMode),
                        style: TextStyle(
                            color: AppTheme.textColor(widget.isDarkMode)),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        menuMaxHeight:
                            200, // Limit the height of the dropdown menu
                        items: [
                          ...allLabels.map((label) => DropdownMenuItem(
                                value: label,
                                child: Text(label),
                              )),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedLabel = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isCreatingNewLabel = true;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Create New Label',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.inputBackgroundColor(widget.isDarkMode),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: TextField(
                    controller: _newLabelController,
                    autofocus: true,
                    style:
                        TextStyle(color: AppTheme.textColor(widget.isDarkMode)),
                    decoration: InputDecoration(
                      labelText: 'New Label',
                      labelStyle: TextStyle(
                          color: AppTheme.subTextColor(widget.isDarkMode)),
                      border: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      //hintText: 'Type a new label name...',
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            color: AppTheme.subTextColor(widget.isDarkMode),
                            onPressed: () {
                              setState(() {
                                _isCreatingNewLabel = false;
                                _newLabelController.clear();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _selectedLabel = value;
                          _isCreatingNewLabel = false;
                        });
                      }
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.inputBackgroundColor(widget.isDarkMode),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priority',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor(widget.isDarkMode),
                      ),
                    ),
                    Text(
                      '1 is the lowest and 5 is the highest priority',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.subTextColor(widget.isDarkMode)),
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _priority.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _priority.toString(),
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (value) {
                        setState(() {
                          _priority = value.round();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Skip button - save with default values
            final String title = _titleController.text.isEmpty
                ? 'Untitled Task'
                : _titleController.text;

            widget.onSave(
              title,
              _selectedDate,
              'Urgent', // Default label
              5, // Highest priority
            );
            Navigator.of(context).pop();
          },
          child: Text('Skip',
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close',
              style:
                  TextStyle(color: AppTheme.subTextColor(widget.isDarkMode))),
        ),
        ElevatedButton(
          onPressed: () {
            final String title = _titleController.text.isEmpty
                ? 'Untitled Task'
                : _titleController.text;

            final String label =
                _isCreatingNewLabel && _newLabelController.text.isNotEmpty
                    ? _newLabelController.text
                    : _selectedLabel;

            widget.onSave(
              title,
              _selectedDate,
              label,
              _priority,
            );
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
