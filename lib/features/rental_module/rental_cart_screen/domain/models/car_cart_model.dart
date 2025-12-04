
class CarCartModel {
  List<Carts>? carts;

  CarCartModel({this.carts});

  CarCartModel.fromJson(Map<String, dynamic> json) {
    if (json['carts'] != null) {
      carts = <Carts>[];
      json['carts'].forEach((v) {
        carts!.add(Carts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (carts != null) {
      data['carts'] = carts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Carts {
  int? id;
  int? providerId;
  int? userId;
  int? vehicleId;
  int? moduleId;
  int? quantity;
  int? isGuest;
  String? createdAt;
  String? updatedAt;
  Provider? provider;

  Carts(
      {this.id,
        this.providerId,
        this.userId,
        this.vehicleId,
        this.moduleId,
        this.quantity,
        this.isGuest,
        this.createdAt,
        this.updatedAt,
        this.provider});

  Carts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    userId = json['user_id'];
    vehicleId = json['vehicle_id'];
    moduleId = json['module_id'];
    quantity = json['quantity'];
    isGuest = json['is_guest'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    provider = json['provider'] != null
        ? Provider.fromJson(json['provider'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['user_id'] = userId;
    data['vehicle_id'] = vehicleId;
    data['module_id'] = moduleId;
    data['quantity'] = quantity;
    data['is_guest'] = isGuest;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    return data;
  }
}

// class Vehicles {
//   int? id;
//   String? name;
//   String? description;
//   String? thumbnail;
//   String? images;
//   int? providerId;
//   int? brandId;
//   int? categoryId;
//   String? model;
//   String? type;
//   String? engineCapacity;
//   String? enginePower;
//   String? seatingCapacity;
//   int? airCondition;
//   String? fuelType;
//   String? transmissionType;
//   int? multipleVehicles;
//   int? tripHourly;
//   int? tripDistance;
//   int? hourlyPrice;
//   int? distancePrice;
//   String? discountType;
//   int? discountPrice;
//   String? tag;
//   String? documents;
//   int? status;
//   int? newTag;
//   int? totalTrip;
//   String? avgRating;
//   int? totalReviews;
//   String? createdAt;
//   String? updatedAt;
//   int? zoneId;
//   String? thumbnailFullUrl;
//   List<String>? imagesFullUrl;
//   List<String>? documentsFullUrl;
//
//   Vehicles(
//       {this.id,
//         this.name,
//         this.description,
//         this.thumbnail,
//         this.images,
//         this.providerId,
//         this.brandId,
//         this.categoryId,
//         this.model,
//         this.type,
//         this.engineCapacity,
//         this.enginePower,
//         this.seatingCapacity,
//         this.airCondition,
//         this.fuelType,
//         this.transmissionType,
//         this.multipleVehicles,
//         this.tripHourly,
//         this.tripDistance,
//         this.hourlyPrice,
//         this.distancePrice,
//         this.discountType,
//         this.discountPrice,
//         this.tag,
//         this.documents,
//         this.status,
//         this.newTag,
//         this.totalTrip,
//         this.avgRating,
//         this.totalReviews,
//         this.createdAt,
//         this.updatedAt,
//         this.zoneId,
//         this.thumbnailFullUrl,
//         this.imagesFullUrl,
//         this.documentsFullUrl,
//       });
//
//   Vehicles.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     thumbnail = json['thumbnail'];
//     images = json['images'];
//     providerId = json['provider_id'];
//     brandId = json['brand_id'];
//     categoryId = json['category_id'];
//     model = json['model'];
//     type = json['type'];
//     engineCapacity = json['engine_capacity'];
//     enginePower = json['engine_power'];
//     seatingCapacity = json['seating_capacity'];
//     airCondition = json['air_condition'];
//     fuelType = json['fuel_type'];
//     transmissionType = json['transmission_type'];
//     multipleVehicles = json['multiple_vehicles'];
//     tripHourly = json['trip_hourly'];
//     tripDistance = json['trip_distance'];
//     hourlyPrice = json['hourly_price'];
//     distancePrice = json['distance_price'];
//     discountType = json['discount_type'];
//     discountPrice = json['discount_price'];
//     tag = json['tag'];
//     documents = json['documents'];
//     status = json['status'];
//     newTag = json['new_tag'];
//     totalTrip = json['total_trip'];
//     avgRating = json['avg_rating'];
//     totalReviews = json['total_reviews'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     zoneId = json['zone_id'];
//     thumbnailFullUrl = json['thumbnail_full_url'];
//     imagesFullUrl = json['images_full_url'].cast<String>();
//     documentsFullUrl = json['documents_full_url'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['thumbnail'] = this.thumbnail;
//     data['images'] = this.images;
//     data['provider_id'] = this.providerId;
//     data['brand_id'] = this.brandId;
//     data['category_id'] = this.categoryId;
//     data['model'] = this.model;
//     data['type'] = this.type;
//     data['engine_capacity'] = this.engineCapacity;
//     data['engine_power'] = this.enginePower;
//     data['seating_capacity'] = this.seatingCapacity;
//     data['air_condition'] = this.airCondition;
//     data['fuel_type'] = this.fuelType;
//     data['transmission_type'] = this.transmissionType;
//     data['multiple_vehicles'] = this.multipleVehicles;
//     data['trip_hourly'] = this.tripHourly;
//     data['trip_distance'] = this.tripDistance;
//     data['hourly_price'] = this.hourlyPrice;
//     data['distance_price'] = this.distancePrice;
//     data['discount_type'] = this.discountType;
//     data['discount_price'] = this.discountPrice;
//     data['tag'] = this.tag;
//     data['documents'] = this.documents;
//     data['status'] = this.status;
//     data['new_tag'] = this.newTag;
//     data['total_trip'] = this.totalTrip;
//     data['avg_rating'] = this.avgRating;
//     data['total_reviews'] = this.totalReviews;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['zone_id'] = this.zoneId;
//     data['thumbnail_full_url'] = this.thumbnailFullUrl;
//     data['images_full_url'] = this.imagesFullUrl;
//     data['documents_full_url'] = this.documentsFullUrl;
//     return data;
//   }
// }

class Provider {
  int? id;
  String? name;
  double? tax;
  List<int>? pickupZoneId;
  bool? gstStatus;
  String? gstCode;
  String? logoFullUrl;
  String? coverPhotoFullUrl;
  String? metaImageFullUrl;
  Discount? discount;
  List<Translations>? translations;
  List<Storage>? storage;

  Provider({
    this.id,
    this.name,
    this.tax,
    this.pickupZoneId,
    this.gstStatus,
    this.gstCode,
    this.logoFullUrl,
    this.coverPhotoFullUrl,
    this.metaImageFullUrl,
    this.discount,
    this.translations,
    this.storage,
  });

  Provider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tax = json['tax']?.toDouble();
    if(json['pickup_zone_id'] != null){
      json['pickup_zone_id'].forEach((zone) {
        pickupZoneId = [];
        pickupZoneId!.add(int.parse(zone.toString()));
      });
    }
    gstStatus = json['gst_status'];
    gstCode = json['gst_code'];
    logoFullUrl = json['logo_full_url'];
    coverPhotoFullUrl = json['cover_photo_full_url'];
    metaImageFullUrl = json['meta_image_full_url'];
    discount = json['discount'] != null
        ? Discount.fromJson(json['discount'])
        : null;
    if (json['translations'] != null) {
      translations = <Translations>[];
      json['translations'].forEach((v) {
        translations!.add(Translations.fromJson(v));
      });
    }
    if (json['storage'] != null) {
      storage = <Storage>[];
      json['storage'].forEach((v) {
        storage!.add(Storage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tax'] = tax;
    data['gst_status'] = gstStatus;
    data['gst_code'] = gstCode;
    data['logo_full_url'] = logoFullUrl;
    data['cover_photo_full_url'] = coverPhotoFullUrl;
    data['meta_image_full_url'] = metaImageFullUrl;
    if (discount != null) {
      data['discount'] = discount!.toJson();
    }
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    if (storage != null) {
      data['storage'] = storage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Discount {
  int? id;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  double? minPurchase;
  double? maxDiscount;
  double? discount;
  String? discountType;
  int? storeId;
  String? createdAt;
  String? updatedAt;

  Discount({
    this.id,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.minPurchase,
    this.maxDiscount,
    this.discount,
    this.discountType,
    this.storeId,
    this.createdAt,
    this.updatedAt,
  });

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    minPurchase = json['min_purchase']?.toDouble();
    maxDiscount = json['max_discount']?.toDouble();
    discount = json['discount']?.toDouble();
    discountType = json['discount_type'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['min_purchase'] = minPurchase;
    data['max_discount'] = maxDiscount;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['store_id'] = storeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Translations {
  int? id;
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;
  String? createdAt;
  String? updatedAt;

  Translations(
      {this.id,
        this.translationableType,
        this.translationableId,
        this.locale,
        this.key,
        this.value,
        this.createdAt,
        this.updatedAt});

  Translations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['translationable_type'] = translationableType;
    data['translationable_id'] = translationableId;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Storage {
  int? id;
  String? dataType;
  String? dataId;
  String? key;
  String? value;
  String? createdAt;
  String? updatedAt;

  Storage(
      {this.id,
        this.dataType,
        this.dataId,
        this.key,
        this.value,
        this.createdAt,
        this.updatedAt});

  Storage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataType = json['data_type'];
    dataId = json['data_id'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['data_type'] = dataType;
    data['data_id'] = dataId;
    data['key'] = key;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}