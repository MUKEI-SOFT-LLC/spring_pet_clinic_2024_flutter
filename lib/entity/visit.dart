class Visit {
  late int id;
  late String? date;
  late String? description;
  Visit.fromJson(json) {
    id = json['id'] as int;
    date = json['date'] as String;
    description = json['description'] as String;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date' : date,
    'description' : description
  };
}