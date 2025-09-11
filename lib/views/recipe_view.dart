import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatscookin/models/recipe.dart';

Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

class RecipeView extends StatefulWidget {
  const RecipeView({super.key});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  @override
  Widget build(BuildContext context) {
    dynamic received = ModalRoute.of(context)!.settings.arguments;
    AIRecipe recipe = received["selectedRecipe"];
    // recipe.getWebpages();
    return Scaffold(
  appBar: AppBar(
    title: Text(recipe.name),
    centerTitle: true,
    backgroundColor: Colors.blueGrey[100],
  ),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 20.0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...recipe.quantifiedIngredients.map((ing) => Center(child: Text(ing))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                "Recipe",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...recipe.recipeSteps.asMap().map(
                  (index, step) => MapEntry(
                    index,
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "${index + 1}. ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: step),
                        ],
                      ),
                    ),
                  ),
                ).values,
              ],
            ),
          ),
          Divider(
            height: 10.0,
            thickness: 2.0,
          ),
          Center(child: Text("Related Websites",
          style: TextStyle(
            fontSize: 17,
            letterSpacing: 2.0,
          ),)),          
          ...recipe.recipeWebsites.map(
            (website) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(30))
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(website.image),
                  ),
                  title:InkWell(
                    onTap: () async {
                      await _launchURL(website.link);
                    },
                    child: Text(
                      website.title,
                      style: TextStyle(
                                color: Colors.blue, 
                            ),
                    ),
                  ) ,
                  subtitle: Text(website.description),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
  }
}