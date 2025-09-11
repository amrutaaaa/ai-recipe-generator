import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whatscookin/models/recipe.dart';
import 'package:whatscookin/views/loading.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  UserRecipe userRecipe = UserRecipe();
  final _ingredientFormGlobalKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    
    String ingredient = "";

    Widget searchBar = Container(
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: Form(
            key: _ingredientFormGlobalKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: "Add Ingredients"
                    ),
                    onSaved: (value){
                      if (value!= null && value!="") ingredient = value;
                    },
                    validator: (value) {
                      if (value==null || value=="") return "Ingredient name cannot be empty";
                      return null;
                    },
                  ),
                ),
                IconButton(
                  onPressed: (){
                    if (_ingredientFormGlobalKey.currentState!.validate()){
                      _ingredientFormGlobalKey.currentState!.save();
                      _ingredientFormGlobalKey.currentState!.reset();

                      setState(() {
                        userRecipe.userInputIngredients.add(ingredient);
                      });
                    }
                  }, 
                  icon: Icon(Icons.add)
                )
              ],
            ),
          ),
        );

    return isLoading? Loading(): Scaffold(
      body: 
      userRecipe.userInputIngredients.isEmpty ?  Center(child: searchBar) : 
      SafeArea(
        child: Column(
          children: [
            searchBar,
            Expanded(
              child: ListView.builder(
                itemCount: userRecipe.userInputIngredients.length,
                itemBuilder: (context, index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userRecipe.userInputIngredients[index]),
                          IconButton(
                            onPressed: (){
                              setState(() {
                                userRecipe.userInputIngredients.remove(userRecipe.userInputIngredients[index]);
                              });
                            },
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red[400],
                            )
                          )
                        ],
                      ),
                    )
                  );
                }
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () async{
                  FocusScope.of(context).unfocus();
                  setState(() {
                    isLoading = true;
                  });
                  
                  await userRecipe.getRecipes();

                  setState(() {
                    isLoading = false;
                  });
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(
                    "/recipeOptions",
                    arguments: {'userRecipe': userRecipe}
                    );
                  }
                }, 
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 17.0,
                    letterSpacing: 2.0
                  ),
                )
              ),
            )
          ],
        )
      ),
    );
  }
}