class Category {
  int? id;
  String categoryName;

  Category({required this.categoryName});

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'cId': id,
    };
  }

  Category.withId({this.id, required this.categoryName});


  factory Category.fromMap(Map<String, dynamic> map) {
    final id = map['cId'] ?? 0;

    return Category.withId(
      id: id,
      categoryName: map['categoryName'] ?? 'Unknown',
    );
  }
}
