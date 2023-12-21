import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late User? _user;
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController anniversaireController = TextEditingController();

  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
      if (user != null) {
        loadUserInfo();
        // Mettez à jour emailController lors de l'authentification
        emailController.text = user.email ?? '';
      }
    });
  }

  void loadUserInfo() async {
    if (_user != null) {
      String userId = _user!.uid;

      DocumentSnapshot profileSnapshot =
          await firestore.collection("profils").doc(userId).get();

      if (profileSnapshot.exists) {
        Map<String, dynamic> data =
            profileSnapshot.data() as Map<String, dynamic>;

        setState(() {
          adressController.text = data['adresse'] ?? '';
          postalCodeController.text = data['codePostal'].toString() ?? '';
          cityController.text = data['ville'] ?? '';
          anniversaireController.text = data['anniversaire'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromRGBO(85, 105, 254, 1.0),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: adressController,
                decoration: const InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                ),
                enabled: isEditMode,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: postalCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Code Postal',
                  border: OutlineInputBorder(),
                ),
                enabled: isEditMode,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'Ville',
                  border: OutlineInputBorder(),
                ),
                enabled: isEditMode,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: anniversaireController,
                decoration: const InputDecoration(
                  labelText: 'Anniversaire',
                  border: OutlineInputBorder(),
                ),
                enabled: isEditMode,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (isEditMode) {
                    enregistrerProfilEtAuthentifier();
                  } else {
                    setState(() {
                      isEditMode = true;
                    });
                  }
                },
                child: Text(isEditMode ? 'Valider' : 'Modifier'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void enregistrerProfilEtAuthentifier() async {
    try {
      if (_user == null) {
        return;
      }

      DocumentReference userDocRef =
          firestore.collection("profils").doc(_user!.uid);

      // Vérifier si le document existe
      DocumentSnapshot userDocSnapshot = await userDocRef.get();

      if (!userDocSnapshot.exists) {
        // Créer le document avec les données initiales
        await userDocRef.set({
          'email': _user!.email ?? '', // Exemple de champ obligatoire
        });
      }

      // Mettre à jour le document avec les données du profil
      await userDocRef.update({
        'adresse': adressController.text,
        'codePostal': int.tryParse(postalCodeController.text) ?? 0,
        'anniversaire': anniversaireController.text,
        'ville': cityController.text,
      });

      setState(() {
        isEditMode = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profil enregistré avec succès'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      print('Erreur lors de la mise à jour du profil : $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la mise à jour du profil'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
