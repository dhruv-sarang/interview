import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview/bloc/category/category_bloc.dart';
import '../read_question/read_question_view.dart';
import '../../model/category.dart';

class SelectCategoryReadView extends StatelessWidget {
  const SelectCategoryReadView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryBloc>().add(CategoryFetchRequest());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Category"),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryErrorState) {
            return Center(child: Text("Error: ${state.error}"));
          } else if (state is CategoryLoadedState) {
            List<Category> categories = state.categories;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    color: const Color(0xFFA3C1DA),
                    child: ListTile(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReadQuestionView(
                                category.id!, category.categoryName),
                          ),
                        );
                      },
                      title: Text(category.categoryName),
                      leading: Text("${category.id}"),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: Text("No categories found."));
        },
      ),
    );
  }
}