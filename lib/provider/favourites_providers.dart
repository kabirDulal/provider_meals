import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';

class FavrouiteMealsNotifier extends StateNotifier<List<Meal>> {
  FavrouiteMealsNotifier() : super([]);
  bool toggleMealFavouriteStatus(Meal meal) {
    final mealIsFavourite = state.contains(meal);
    if (mealIsFavourite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favrouiteMealProvider =
    StateNotifierProvider<FavrouiteMealsNotifier, List<Meal>>((ref) {
  return FavrouiteMealsNotifier();
});
