class Plan {
  final String id;
  final String name;
  final int duration; // in months
  final String description;
  final double price;

  Plan({
    required this.id,
    required this.name,
    required this.duration,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'description': description,
      'price': price,
    };
  }

  factory Plan.fromMap(Map<String, dynamic> map) {
    return Plan(
      id: map['id'],
      name: map['name'],
      duration: map['duration'],
      description: map['description'],
      price: map['price'],
    );
  }
}