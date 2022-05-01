class FeedbackModel {
  final String student;
  final String message;
  final double rate;
  final String module;

  FeedbackModel({
    required this.student,
    required this.message,
    required this.rate,
    required this.module,
  });

  Map<String, dynamic> toMap() {
    return {
      'student': student,
      'message': message,
      'rate': rate,
      'module': module,
    };
  }

  @override
  String toString() {
    return 'FeedbackModel(student: $student, message: $message, rate: $rate, module: $module)';
  }
}
