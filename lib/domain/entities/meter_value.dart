class MeterValue {
  DateTime date;
  String value;
  MeterValue(this.date, this.value);

  Map<String, dynamic> toJson() {
    return {
      "date": date.millisecondsSinceEpoch,
      "value": value,
    };
  }

  MeterValue.fromJson(Map<String, dynamic> map)
      : date = DateTime.fromMillisecondsSinceEpoch(map["date"]),
        value = map["value"];
}
