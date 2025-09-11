import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whatscookin/models/website.dart';
import 'package:whatscookin/routes/routes.dart';

class UserRecipe {
  List<String> userInputIngredients = [];
  List<AIRecipe> obtainedRecipes = [];

  UserRecipe();

  Future<void> getRecipes() async {
    obtainedRecipes = [];
    try{
      var url = Uri.parse(backendRoute);

      Map<String, dynamic> body = {"ingredients": userInputIngredients};           
      var response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(body));         
      Map<String, dynamic> recipeResponse = jsonDecode(response.body);

      recipeResponse.forEach((key, value){
        obtainedRecipes.add(AIRecipe(quantifiedIngredients: value.cast<String>(), name: key));
      });
    }catch (e){
      print(e);
    }
    
  }
}

class AIRecipe{
  List<String> quantifiedIngredients;
  String name;
  List<String> recipeSteps = [];
  List<Website> recipeWebsites=[];

  AIRecipe({required this.quantifiedIngredients, required this.name});

  List<String> extractListItems(String text) {
    // Regular expression to match numbered list items
    final regex = RegExp(r'\d+\.\s*(.*?)(?=\n\d+\.|\n*$)', multiLine: true);

    // Extract matching items and store them in a list
    Iterable<Match> matches = regex.allMatches(text);

    return matches.map((match) => match.group(1)!).toList();
  }

  Future<void> getChosenAiRecipe() async {
    var url = Uri.parse("$backendRoute/getRecipe");

    Map<String, dynamic> body = {"name": name, "ingredients": quantifiedIngredients};
    var response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(body));

    Map<String, dynamic> stepsResponse = jsonDecode(response.body);

    recipeSteps = extractListItems(stepsResponse["recipe"]);
  }

  Future<void> getWebpages() async {
    var url = Uri.parse("$backendRoute/getParticularRecipe/$name");
    
    var response = await http.get(url, headers: {'Content-Type': 'application/json'});

    List<dynamic> webpageList = jsonDecode(response.body);

    recipeWebsites = webpageList.map((webpage)=>
      Website(title: webpage['title'], link: webpage['link'], image: webpage['image']['src'], description: webpage['description'])
    ).toList();
  }
}
