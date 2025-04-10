import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/provider/meals_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/main_drawer.dart';
const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
 Map<Filter, bool> _selectedFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegan: false,
    Filter.vegetarian: false
  };

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: const Color.fromARGB(255, 139, 42, 13),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          )),
    );
  }

  void _navigteToOnSelectScreen(String identifier) async{
    Navigator.pop(context);
    if (identifier == 'filters') {
      final result = await Navigator.of(context)
          .push<Map<Filter, bool>>(MaterialPageRoute(builder: (ctx) => FiltersScreen(currentFilters: _selectedFilters,)));    
          setState(() {
            _selectedFilters = result ?? kInitialFilters;
          });      
    }
  }

  final List<Meal> _favouriteMeals = [];
  void _toggleSelectedFavroiteMeal(Meal meal) {
    final isExisting = _favouriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favouriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favourite');
    } else {
      setState(() {
        _favouriteMeals.add(meal);
      });
      _showInfoMessage('Meal is added to favourite');
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final availabeMeals = meals.where((meal){
      if(_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree){
        return false;
      }
      if(_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree){
        return false;
      }
      if(_selectedFilters[Filter.vegan]! && !meal.isVegan){
        return false;
      }
      if(_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian){
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      onToggleFavouriteMeal: _toggleSelectedFavroiteMeal, 
      availabeMeals: availabeMeals,
    );
    var activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favouriteMeals,
        onToggleFavouriteMeal: _toggleSelectedFavroiteMeal,
      );
      activePageTitle = 'Your Favourite';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          activePageTitle,
        ),
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      drawer: MainDrawer(
        onSelectScreen: _navigteToOnSelectScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(57, 240, 154, 148),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites')
        ],
      ),
    );
  }
}
