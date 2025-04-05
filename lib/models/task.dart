class Task {
  final String title;
  final DateTime date;
  bool isDone;
  final int priority;
  final String label;

  Task({
    required this.title,
    required this.date,
    this.isDone = false,
    this.priority = 5, // Default to highest priority if not specified
    this.label = 'Unlabeled',
  });
}
