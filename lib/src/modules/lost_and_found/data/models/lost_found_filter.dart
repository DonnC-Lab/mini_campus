class LostFoundFilter {
  final String month;
  final String type;

  LostFoundFilter({
    this.type = 'lost',
    this.month = 'Jan',
  });

  LostFoundFilter copyWith({
    String? month,
    String? type,
  }) {
    return LostFoundFilter(
      month: month ?? this.month,
      type: type ?? this.type,
    );
  }
}
