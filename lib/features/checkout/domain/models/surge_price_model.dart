class SurgePriceModel {
  String? title;
  String? customerNote;
  int? customerNoteStatus;
  double? price;
  String? priceType;

  SurgePriceModel({
    this.title,
    this.customerNote,
    this.customerNoteStatus,
    this.price,
    this.priceType,
  });

  SurgePriceModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    customerNote = json['customer_note'];
    customerNoteStatus = json['customer_note_status'];
    price = double.tryParse(json['price'].toString());
    priceType = json['price_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['customer_note'] = customerNote;
    data['customer_note_status'] = customerNoteStatus;
    data['price'] = price;
    data['price_type'] = priceType;
    return data;
  }
}
