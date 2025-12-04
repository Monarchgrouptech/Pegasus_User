class CategoryModel {
  int? id;
  String? name;
  String? imageFullUrl;

  CategoryModel({this.id, this.name, this.imageFullUrl});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageFullUrl = json['image_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image_full_url'] = imageFullUrl;
    return data;
  }
}
