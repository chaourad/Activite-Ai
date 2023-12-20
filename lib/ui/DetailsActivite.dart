import 'package:flutter/material.dart';
import 'package:projet/model/Activity.dart';

class DetailsActivite extends StatelessWidget {
  final Activity activity;

  const DetailsActivite({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.titre),
        backgroundColor: const Color.fromRGBO(85, 105, 254, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              activity.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text("Titer: ${activity.titre}"),
            Text('Location: ${activity.lieu}'),
            Text('Price: ${activity.prix}'),
            Text('Categorie: ${activity.categorie}'),
            Text('Nombre de personne minimale: ${activity.nbr_min}'),
          ],
        ),
      ),
    );
  }
}
