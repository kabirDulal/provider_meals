import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filter { glutenFree, lactoseFree, vegan, vegetarian }

class FilterProviderNotifier extends StateNotifier<Map<Filter, bool>> {
  FilterProviderNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegan: false,
          Filter.vegetarian: false,
        });
  void setFilters(Map<Filter, bool> choosenFilters){
    state = choosenFilters;
  }
  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
    // state[filter] = isActive;  //not allowed! => mutating state
  }
}
final filterProvider = StateNotifierProvider<FilterProviderNotifier, Map<Filter, bool>>((ref)=>
  FilterProviderNotifier()
);
