import 'package:flutter/material.dart';
import 'package:whatscookin/views/loading.dart';
import 'package:whatscookin/views/options_view.dart';
import 'package:whatscookin/views/recipe_view.dart';
import 'package:whatscookin/views/search.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      "/": (context)=> Search(),
      "/recipeOptions": (context)=> OptionsView(),
      "/finalRecipe": (context)=> RecipeView(),
      "/loading": (context)=>Loading()
    },
  ));
}