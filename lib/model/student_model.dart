class Student {
  final int? id;
  final String name;
  final String address;
  final String city;
  final String pin;

  Student(
      {this.id,
      required this.name,
      required this.address,
      required this.city,
      required this.pin});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      pin: json['pin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'pin': pin,
    };
  }
}
