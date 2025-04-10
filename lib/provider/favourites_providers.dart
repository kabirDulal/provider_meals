import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';
class FavrouiteMealsNotifier extends StateNotifier<List<Meal>>{
  FavrouiteMealsNotifier() : super([]);
  void toggleMealFavouriteStatus(Meal meal){
    final mealIsFavourite = state.contains(meal);
    if(mealIsFavourite){
      state = state.where((m)=> m.id != meal.id).toList();
    }else {
      state = [...state, meal];
    }
  }
}
final favrouiteMealProvider = StateNotifierProvider((ref){
  return FavrouiteMealsNotifier();
});

