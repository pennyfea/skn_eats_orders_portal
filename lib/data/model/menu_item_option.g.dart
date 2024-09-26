// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemOption _$MenuItemOptionFromJson(Map<String, dynamic> json) =>
    MenuItemOption(
      id: json['id'] as String,
      choices:
          (json['choices'] as List<dynamic>).map((e) => e as String).toList(),
      category: json['category'] as String,
      price: (json['price'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MenuItemOptionToJson(MenuItemOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'choices': instance.choices,
      'category': instance.category,
      'price': instance.price,
      'quantity': instance.quantity,
    };
