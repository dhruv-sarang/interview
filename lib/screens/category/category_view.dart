import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/category/category_bloc.dart';
import '../../model/category.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(CategoryFetchRequest());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Category"),
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          if (state is CategoryLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoadedState) {
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return ListTile(
                  leading: Text('${index+1}'),
                  title: Text(category.categoryName),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context
                          .read<CategoryBloc>()
                          .add(CategoryDelete(category));
                    },
                  ),
                  onTap: () {
                    openCategoryDialog(context, category);
                  },
                );
              },
            );
          }
          return const Center(child: Text("No categories found."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          openCategoryDialog(context, null);
        },
      ),
    );
  }

  void openCategoryDialog(BuildContext context, Category? category) {
    TextEditingController titleController = TextEditingController();
    if (category != null) {
      titleController.text = category.categoryName;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(category == null ? 'Add Category' : 'Update Category'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (category == null) {
                  context.read<CategoryBloc>().add(CategoryAdd(
                      Category(categoryName: titleController.text)));
                } else {
                  context.read<CategoryBloc>().add(
                        CategoryUpdate(
                          Category.withId(
                              id: category.id,
                              categoryName: titleController.text),
                        ),
                      );
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(category == null ? 'Add' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
