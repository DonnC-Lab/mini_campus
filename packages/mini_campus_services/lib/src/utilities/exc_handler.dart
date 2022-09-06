class ExcHandler {
  final Object exception;
  final String logName;
  final String? topic;

  ExcHandler({required this.exception, this.logName = 'exceptionHandler', this.topic});
}
