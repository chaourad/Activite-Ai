import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet/model/Activity.dart';
import 'package:projet/ui/DetailsActivite.dart';

class ListeActivite extends StatefulWidget {
  const ListeActivite({Key? key});

  @override
  State<ListeActivite> createState() => _ListeActiviteState();
}

class _ListeActiviteState extends State<ListeActivite> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String selectedCategory = "Toutes"; // Catégorie sélectionnée par défaut
  Set<String> uniqueCategories = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des activités"),
        backgroundColor: const Color.fromRGBO(85, 105, 254, 1.0),
      ),
      body: Column(
        children: [
          // Zone des boutons de catégories
          Container(
            padding: const EdgeInsets.all(8.0),
            height: 80,
            child: FutureBuilder<QuerySnapshot>(
              future: db.collection("activite").get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Utiliser un ensemble pour stocker des catégories uniques
                uniqueCategories = {"Toutes"};
                uniqueCategories.addAll(snapshot.data!.docs
                    .map((doc) => doc["categorie"].toString()));

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: uniqueCategories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          child: Chip(
                            label: Text(category),
                            backgroundColor: selectedCategory == category
                                ? Color.fromRGBO(85, 105, 254, 1.0)
                                : Colors.grey,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          // Liste des activités filtrées par catégorie
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: selectedCategory == "Toutes"
                  ? db.collection("activite").snapshots()
                  : db
                      .collection("activite")
                      .where("categorie", isEqualTo: selectedCategory)
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No activities found.'),
                  );
                }

                List<Activity> activities = snapshot.data!.docs
                    .map((doc) => Activity.FromFirestore(doc))
                    .toList();

                return ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    Activity activity = activities[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsActivite(activity: activity),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(File(activity.image)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            activity.titre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Location: ${activity.lieu}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
