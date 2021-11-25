class MeterValue {
  DateTime date;
  int value;
  int? correction;
  MeterValue(this.date, this.value, {this.correction});

  Map<String, dynamic> toJson() {
    return {
      "date": date.millisecondsSinceEpoch,
      "value": value,
      "correction": correction ?? 0,
    };
  }

  MeterValue.fromJson(Map<String, dynamic> map)
      : date = DateTime.fromMillisecondsSinceEpoch(map["date"]),
        value = map["value"],
        correction = map["correction"] ?? 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MeterValue &&
        other.date == date &&
        other.value == value &&
        other.correction == correction;
  }

  @override
  int get hashCode => date.hashCode ^ value.hashCode ^ correction.hashCode;
}
