import 'package:flutter/material.dart';
import 'package:whatscookin/models/recipe.dart';
import 'package:whatscookin/views/loading.dart';

class OptionsView extends StatefulWidget {
  const OptionsView({super.key});

  @override
  State<OptionsView> createState() => _OptionsViewState();
}

class _OptionsViewState extends State<OptionsView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    dynamic received = ModalRoute.of(context)!.settings.arguments;
    UserRecipe userRecipe = received["userRecipe"];
    List<AIRecipe> recipesList = userRecipe.obtainedRecipes;

    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Options"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[200],
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Recipes',
            onPressed: () async {
             setState(() {
               isLoading = true;
             });
             await userRecipe.getRecipes();
             setState(() {
               isLoading = false;
             });
            },
          ),
        ]
      ),
      body: isLoading? Loading(): GridView.count(
        crossAxisCount: 2,
        children: recipesList.map((recipe){
          return InkWell(
            onTap: () async{
              setState(() {
                isLoading = true;
              });
              await recipe.getChosenAiRecipe();
              await recipe.getWebpages();
              isLoading = false;
              if (context.mounted) Navigator.of(context).pushNamed("/finalRecipe", arguments: {"selectedRecipe": recipe});
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  //Container(
                    //height: 50,
                    //width: 50,
                    //color: Colors.blueGrey[300],
                  //),
                  Column(
                    children: [
                      Text(
                        recipe.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          letterSpacing: 1.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          recipe.quantifiedIngredients.join(", "),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.0,
                            letterSpacing: 1.0,
                            color: Colors.blueGrey[400]
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }).toList(),
      )
    );
  }
}