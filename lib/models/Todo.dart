class Todo{
  String title;
  bool completed;

  Todo({ required this.title, required this.completed });

  factory Todo.fromJson(Map<String, dynamic> jsonData) {
    return Todo(
      title: jsonData['title'],
      completed: jsonData['completed'],
    );
  }

  static Map<String, dynamic> toMap(Todo todo) => {
      'title': todo.title,
      'completed': todo.completed
  };
}