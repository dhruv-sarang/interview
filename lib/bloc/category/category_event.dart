part of 'category_bloc.dart';

sealed class CategoryEvent {}

class CategoryFetchRequest extends CategoryEvent {}

class CategoryAdd extends CategoryEvent {
  final Category category;

  CategoryAdd(this.category);
}

class CategoryUpdate extends CategoryEvent {
  final Category category;

  CategoryUpdate(this.category);
}

class CategoryDelete extends CategoryEvent {
  final Category category;

  CategoryDelete(this.category);
}