import 'package:sixam_mart/common/enums/data_source_enum.dart';
import 'package:sixam_mart/features/item/domain/models/basic_medicine_model.dart';
import 'package:sixam_mart/features/item/domain/models/common_condition_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/cart/domain/models/cart_model.dart';

abstract class ItemServiceInterface {
  Future<ItemModel?> getPopularItemList({required String type, DataSourceEnum? source, required int offset, String? search, List<int>? categoryIds, List<String>? filter, int? rating, double? minPrice, double? maxPrice});
  Future<ItemModel?> getReviewedItemList({required String type, DataSourceEnum? source, required int offset, String? search, List<int>? categoryIds, List<String>? filter, int? rating, double? minPrice, double? maxPrice});
  Future<ItemModel?> getFeaturedCategoriesItemList(DataSourceEnum? source);
  Future<List<Item>?> getRecommendedItemList(String type, DataSourceEnum? source);
  Future<ItemModel?> getDiscountedItemList({required String type, DataSourceEnum? source, required int offset, String? search, List<int>? categoryIds, List<String>? filter, int? rating, double? minPrice, double? maxPrice});
  Future<Item?> getItemDetails(int? itemID);
  Future<BasicMedicineModel?> getBasicMedicine(DataSourceEnum source);
  Future<List<CommonConditionModel>?> getCommonConditions();
  Future<List<Item>?> getConditionsWiseItems(int id);
  List<bool> initializeCartAddonActiveList(List<AddOn>? addOnIds, List<AddOns>? addOns);
  List<int?> initializeCartAddonsQtyList(List<AddOn>? addOnIds, List<AddOns>? addOns);
  List<bool> collapseVariation(List<FoodVariation>? foodVariations);
  List<int> initializeCartVariationIndexes(List<Variation>? variation, List<ChoiceOptions>? choiceOptions);
  List<List<bool?>> initializeSelectedVariation(List<FoodVariation>? foodVariations);
  List<bool> initializeCollapseVariation(List<FoodVariation>? foodVariations);
  List<int> initializeVariationIndexes(List<ChoiceOptions>? choiceOptions);
  List<bool> initializeAddonActiveList(List<AddOns>? addOns);
  List<int> initializeAddonQtyList(List<AddOns>? addOns);
  Future<String> prepareVariationType(List<ChoiceOptions>? choiceOptions, List<int>? variationIndex);
  int setAddOnQuantity(bool isIncrement, int addOnQty);
  Future<int> setQuantity(bool isIncrement, bool moduleStock, int? stock, int qty, int? quantityLimit, {bool getxSnackBar = false});
  List<List<bool?>> setNewCartVariationIndex(int index, int i, List<FoodVariation>? foodVariations, List<List<bool?>> selectedVariations);
  int selectedVariationLength(List<List<bool?>> selectedVariations, int index);
  double? getStartingPrice(Item item);
  Future<int> isExistInCartForBottomSheet(List<CartModel> cartList, int? itemId, int? cartIndex, List<List<bool?>>? variations);
}