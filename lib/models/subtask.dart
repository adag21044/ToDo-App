class Subtask {
  final String title;
  bool isCompleted;

  Subtask({required this.title, this.isCompleted = false});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }
}
