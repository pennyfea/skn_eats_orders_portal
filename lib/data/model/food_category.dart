import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'food_category.g.dart';

@JsonSerializable()
class FoodCategory extends Equatable {
  final String id;
  final String name;
  final String? imageUrl;

  const FoodCategory ({
    required this.id,
    required this.name,
    this.imageUrl
  });

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl
  ];

  factory FoodCategory.fromJson(Map<String, dynamic> json) => _$FoodCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$FoodCategoryToJson(this);


  static List<FoodCategory> foodCategories = [
    const FoodCategory(
      id: '1',
      name: "American"
    ),
    const FoodCategory(
      id: '2',
      name: "Asian"
    ),
    const FoodCategory(
      id: '3',
      name: "BBQ"
    ),
    const FoodCategory(
      id: '4',
      name: "Bar"
    ),
    const FoodCategory(
      id: '5',
      name: "Burgers"
    ),
    const FoodCategory(
      id: '6',
      name: "Chicken"
    ),
    const FoodCategory(
      id: '7',
      name: "Chinese"
    ),
    const FoodCategory(
      id: '8',
      name: "Convenience Stores"
    ),
    const FoodCategory(
      id: '9',
      name: "Desserts"
    ),
    const FoodCategory(
      id: '10',
      name: "Halal"
    ),
    const FoodCategory(
      id: '11',
      name: "Indian"
    ),
    const FoodCategory(
      id: '12',
      name: "Local Cuisine"
    ),
    const FoodCategory(
      id: '13',
      name: "Pizza"
    ),
    const FoodCategory(
      id: '14',
      name: "Salads"
    ),
    const FoodCategory(
      id: '15',
      name: "Seafood"
    ),
    const FoodCategory(
      id: '16',
      name: "Soup"
    ),
    const FoodCategory(
      id: '17',
      name: "Sushi"
    )
  ];
}