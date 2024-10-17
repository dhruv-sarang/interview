import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/category.dart';
import '../../database/db_helper.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final DbHelper _dbHelper = DbHelper();

  CategoryBloc() : super(CategoryInitialState()) {
    on<CategoryFetchRequest>((event, emit) async {
      emit(CategoryLoadingState());
      try {
        List<Category> categories = await _dbHelper.read_category();
        emit(CategoryLoadedState(categories));
      } catch (e) {
        emit(CategoryErrorState(e.toString()));
      }
    });

    on<CategoryAdd>((event, emit) async {
      try {
        int result = await _dbHelper.insert_category(event.category);
        if (result != -1) {
          event.category.id = result;
          final currentState = state;
          if (currentState is CategoryLoadedState) {
            List<Category> updatedList = List.from(currentState.categories)
              ..add(event.category);
            emit(CategoryLoadedState(updatedList));
            add(CategoryFetchRequest());
          }
        }
      } catch (e) {
        emit(CategoryErrorState(e.toString()));
      }
    });

    on<CategoryUpdate>((event, emit) async {
      try {
        await _dbHelper.updateCategory(event.category);
        final currentState = state;
        if (currentState is CategoryLoadedState) {
          List<Category> updatedList = currentState.categories
              .map((cat) => cat.id == event.category.id ? event.category : cat)
              .toList();
          emit(CategoryLoadedState(updatedList));
        }
      } catch (e) {
        emit(CategoryErrorState(e.toString()));
      }
    });

    on<CategoryDelete>((event, emit) async {
      try {
        await _dbHelper.deleteCategory(event.category.id);
        final currentState = state;
        if (currentState is CategoryLoadedState) {
          List<Category> updatedList = currentState.categories
              .where((cat) => cat.id != event.category.id)
              .toList();
          emit(CategoryLoadedState(updatedList));
        }
      } catch (e) {
        emit(CategoryErrorState(e.toString()));
      }
    });
  }
}
