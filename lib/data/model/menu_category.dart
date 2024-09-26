import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'menu_category.g.dart';

@JsonSerializable()
class MenuCategory extends Equatable {
  final String id;
  final String name;

  const MenuCategory({
    required this.id,
    required this.name,
  });

  MenuCategory copyWith({
    String? id,
    String? name,
  }) {
    return MenuCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];

  factory MenuCategory.fromJson(Map<String, dynamic> json) =>
      _$MenuCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$MenuCategoryToJson(this);

  factory MenuCategory.fromFirestore(Map<String, dynamic> data) {
    return MenuCategory(
      id: data['id'] as String,
      name: data['name'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
    };
  }
}
