import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/blocs.dart';
import '../../data/models.dart';

class MenuListView extends StatefulWidget {
  const MenuListView({super.key});

  @override
  State<MenuListView> createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  final Set<String> _selectedCategories = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<MenuCategoryBloc, MenuCategoryState>(
            builder: (context, categoryState) {
              if (categoryState is MenuCategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (categoryState is MenuCategoryLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        FilterChip(
                          label: const Text('All Items'),
                          selected: _selectedCategories.isEmpty,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedCategories.clear();
                            });
                          },
                        ),
                        ...categoryState.menuCategories.map((category) => FilterChip(
                          label: Text(category.name),
                          selected: _selectedCategories.contains(category.id),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedCategories.add(category.id);
                              } else {
                                _selectedCategories.remove(category.id);
                              }
                            });
                          },
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categoryState.menuCategories.length,
                      itemBuilder: (context, index) {
                        final category = categoryState.menuCategories[index];
                        if (_selectedCategories.isNotEmpty && !_selectedCategories.contains(category.id)) {
                          return SizedBox.shrink(key: ValueKey(category.id));
                        }
                        return ExpansionTile(
                          key: ValueKey(category.id),
                          leading: ReorderableDragStartListener(
                            index: index,
                            child: const Icon(Icons.drag_handle),
                          ),
                          title: Text(
                            category.name,
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 20),
                          ),
                          children: <Widget>[
                            BlocBuilder<MenuItemBloc, MenuItemState>(
                              builder: (context, menuItemState) {
                                if (menuItemState is MenuItemLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                } else if (menuItemState is MenuItemLoaded) {
                                  List<MenuItem> items = menuItemState.menuItems
                                      .where((item) => item.menuCategoryIds!.contains(category.id))
                                      .toList();
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: items.length,
                                    itemBuilder: (context, itemIndex) {
                                      final menuItem = items[itemIndex];
                                      return ListTile(
                                        leading: menuItem.imageUrl != null && menuItem.imageUrl!.isNotEmpty
                                            ? ClipRect(
                                                child: CachedNetworkImage(
                                                  imageUrl: menuItem.imageUrl!,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Container(
                                                    width: 50,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    child: const CircularProgressIndicator(),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                    width: 50,
                                                    height: 50,
                                                    color: Colors.grey,
                                                    child: const Icon(Icons.error, color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: 50,
                                                height: 50,
                                                color: Colors.grey,
                                                child: const Icon(Icons.image, color: Colors.white),
                                              ),
                                        title: Text(
                                          menuItem.name,
                                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 16),
                                        ),
                                        subtitle: Text(menuItem.description),
                                        trailing: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          color: Colors.grey[300],
                                          child: Text(
                                            '\$${menuItem.price.toStringAsFixed(2)}',
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        onTap: () {
                                          context.read<MenuItemBloc>().add(
                                            SelectedMenuItem(menuItem: menuItem),
                                          );
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, itemIndex) => const Divider(),
                                  );
                                } else {
                                  return const Text('Something went wrong with menu items');
                                }
                              },
                            )
                          ],
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        context.read<MenuCategoryBloc>().add(
                          SortMenuCategories(oldIndex: oldIndex, newIndex: newIndex),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return const Text('Something went wrong with categories');
              }
            },
          ),
        ],
      ),
    );
  }
}