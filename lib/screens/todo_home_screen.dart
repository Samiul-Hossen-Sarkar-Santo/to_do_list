import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../widgets/task_dialog.dart';
import '../widgets/reorder_labels_dialog.dart';
import '../theme/app_theme.dart';

class TodoHomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const TodoHomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  final TextEditingController _taskController = TextEditingController();
  final List<Task> _tasks = [];
  String _selectedCategory = 'All';
  String _sortBy = 'date'; // 'date' or 'priority'
  bool _showCompletedTasks = false; // Track visibility of completed tasks
  final List<String> _labels = [
    'Urgent',
    'Shopping',
    'Birthday',
    'Work',
    'Personal'
  ];

  void _addTask() {
    // Show task dialog without a pre-filled title
    _showTaskDialog();
  }

  void _showTaskDialog([Task? taskToEdit]) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        task: taskToEdit,
        existingLabels: _labels,
        isDarkMode: widget.isDarkMode,
        onSave: (title, date, label, priority) {
          if (title.trim().isEmpty) return;

          setState(() {
            if (!_labels.contains(label) && label.isNotEmpty) {
              _labels.add(label);
            }

            if (taskToEdit != null) {
              // Update existing task
              final index = _tasks.indexOf(taskToEdit);
              _tasks[index] = Task(
                title: title,
                date: date,
                isDone: taskToEdit.isDone,
                priority: priority,
                label: label,
              );
            } else {
              // Add new task
              _tasks.add(Task(
                title: title,
                date: date,
                priority: priority,
                label: label,
              ));
            }
            _taskController.clear();
          });
        },
      ),
    );
  }

  void _toggleTask(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  void _changeFilter(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _changeSort(String sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
  }

  void _showReorderDialog() {
    showDialog(
      context: context,
      builder: (context) => ReorderLabelsDialog(
        labels: List.from(_labels),
        isDarkMode: widget.isDarkMode,
        onReorder: (reorderedLabels) {
          setState(() {
            _labels.clear();
            _labels.addAll(reorderedLabels);
            if (_selectedCategory != 'All' &&
                !_labels.contains(_selectedCategory)) {
              _selectedCategory = 'All';
            }
          });
        },
      ),
    );
  }

  List<Task> get _filteredTasks {
    var tasks = _tasks;

    // Apply category filter
    if (_selectedCategory != 'All') {
      tasks = tasks.where((task) => task.label == _selectedCategory).toList();
    }

    // Apply completed filter
    if (_showCompletedTasks) {
      tasks = tasks.where((task) => task.isDone).toList();
    } else {
      tasks = tasks.where((task) => !task.isDone).toList();
    }

    // Apply sorting
    if (_sortBy == 'date') {
      tasks.sort((a, b) => b.date.compareTo(a.date));
    } else {
      tasks.sort((a, b) => b.priority.compareTo(a.priority));
    }

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    int completedTasks = _tasks.where((t) => t.isDone).length;
    int remainingTasks = _tasks.where((t) => !t.isDone).length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor(widget.isDarkMode),
      appBar: AppBar(
        title: const Text(
          ' Yayyy! Done!!!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: _changeSort,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'date',
                child: Text('Sort by Date'),
              ),
              const PopupMenuItem(
                value: 'priority',
                child: Text('Sort by Priority'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Add Task Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor(widget.isDarkMode),
                border: Border.all(
                  color: AppTheme.borderColor(widget.isDarkMode),
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor(widget.isDarkMode),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _addTask,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: Theme.of(context).primaryColor,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Add New Task',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor(widget.isDarkMode),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Progress
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor(widget.isDarkMode),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor(widget.isDarkMode),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "$completedTasks / ${_tasks.length} tasks completed",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor(widget.isDarkMode),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 120,
                        child: LinearProgressIndicator(
                          value: _tasks.isEmpty
                              ? 0
                              : completedTasks / _tasks.length,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                          backgroundColor:
                              AppTheme.inputBackgroundColor(widget.isDarkMode),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Filters
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.cardColor(widget.isDarkMode),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor(widget.isDarkMode),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Tasks',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.textColor(widget.isDarkMode),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.reorder),
                        onPressed: _showReorderDialog,
                        tooltip: 'Reorder Labels',
                        color: AppTheme.subTextColor(widget.isDarkMode),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('All'),
                              selected: _selectedCategory == 'All',
                              onSelected: (_) => _changeFilter('All'),
                            ),
                            const SizedBox(width: 8),
                            ..._labels.map((label) {
                              final bool isSelected =
                                  label == _selectedCategory;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(label),
                                  selected: isSelected,
                                  onSelected: (_) => _changeFilter(label),
                                ),
                              );
                            }).toList(),
                            // Add extra padding at the end to ensure the shadow is visible
                            const SizedBox(width: 24),
                          ],
                        ),
                      ),
                      // Scroll hint shadow on the right edge
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 24,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppTheme.cardColor(widget.isDarkMode)
                                    .withOpacity(0.0),
                                AppTheme.cardColor(widget.isDarkMode),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: AppTheme.subTextColor(widget.isDarkMode),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Task List
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor(widget.isDarkMode),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowColor(widget.isDarkMode),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _showCompletedTasks
                              ? 'Completed Tasks'
                              : 'Remaining Tasks',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppTheme.textColor(widget.isDarkMode),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              _showCompletedTasks
                                  ? '$completedTasks completed'
                                  : '$remainingTasks remaining',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.subTextColor(widget.isDarkMode),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: _showCompletedTasks,
                              onChanged: (value) {
                                setState(() {
                                  _showCompletedTasks = value;
                                });
                              },
                              activeColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _filteredTasks.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _showCompletedTasks
                                        ? Icons.check_circle_outline
                                        : Icons.task_alt,
                                    size: 48,
                                    color: AppTheme.subTextColor(
                                        widget.isDarkMode),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _showCompletedTasks
                                        ? "No completed tasks yet."
                                        : "No tasks yet.",
                                    style: TextStyle(
                                        color: AppTheme.subTextColor(
                                            widget.isDarkMode)),
                                  ),
                                  if (!_showCompletedTasks)
                                    Text(
                                      "Tap + to add a new task",
                                      style: TextStyle(
                                        color: AppTheme.subTextColor(
                                            widget.isDarkMode),
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              itemCount: _filteredTasks.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final task = _filteredTasks[index];
                                return ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  leading: Checkbox(
                                    value: task.isDone,
                                    onChanged: (_) => _toggleTask(task),
                                  ),
                                  title: Text(
                                    task.title,
                                    style: TextStyle(
                                      decoration: task.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          AppTheme.textColor(widget.isDarkMode),
                                    ),
                                  ),
                                  subtitle: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context)
                                          .style
                                          .copyWith(
                                            fontSize: 12,
                                            color: AppTheme.subTextColor(
                                                widget.isDarkMode),
                                          ),
                                      children: [
                                        TextSpan(
                                          text: task.label,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              " • ${DateFormat('MMM d, yyyy').format(task.date)}",
                                        ),
                                        TextSpan(
                                          text: " • Priority: ${task.priority}",
                                          style: TextStyle(
                                            color: AppTheme.priorityColor(
                                                task.priority),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: _showCompletedTasks
                                      ? IconButton(
                                          icon:
                                              const Icon(Icons.delete_outline),
                                          color: Colors.red,
                                          onPressed: () => _deleteTask(task),
                                        )
                                      : null,
                                  onTap: () => _showTaskDialog(task),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
