part of 'category_bloc.dart';

enum CategoryStatus { initial, loading, success, error }

sealed class CategoryState {}

final class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<Category> categories;
  CategoryLoadedState(this.categories);
}

class CategoryErrorState extends CategoryState {
  final String error;
  CategoryErrorState(this.error);
}
