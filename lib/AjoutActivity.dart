import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tflite_v2/tflite_v2.dart';

class AjoutActivity extends StatefulWidget {
  const AjoutActivity({Key? key}) : super(key: key);

  @override
  State<AjoutActivity> createState() => _AjoutActivityState();
}

class _AjoutActivityState extends State<AjoutActivity> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  var _recognitions;
  var categories = "";
  TextEditingController titre = TextEditingController();
  TextEditingController lieu = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController nbr_minimal = TextEditingController();
  TextEditingController urlimage = TextEditingController();
  TextEditingController cate = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
        urlimage.text = _image?.path ?? '';
      });
      detectimage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> detectimage(File image) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
      categories = _recognitions[0]["label"];
      cate.text = categories;
    });
    print(_recognitions);
    int endTime = DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  void clearFields() {
    titre.clear();
    lieu.clear();
    price.clear();
    nbr_minimal.clear();
    urlimage.clear();
    cate.clear();
    setState(() {
      _image = null;
      file = null;
      _recognitions = null;
      categories = "";
    });
  }

 Future<void> _uploadFile() async {
  try {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("images/${DateTime.now().millisecondsSinceEpoch}.jpg");

    TaskSnapshot taskSnapshot = await storageReference.putFile(File(_image!.path));

    // Récupérez l'URL de téléchargement à partir du TaskSnapshot
    String photoUrl = await taskSnapshot.ref.getDownloadURL();

    // Ajoutez l'activité à Firestore
    Map<String, dynamic> data = {
      "lieu": lieu.text,
      "categorie": cate.text,
      "prix": int.parse(price.text),
      "nbr_min": int.parse(nbr_minimal.text),
      "titre": titre.text,
      "image": photoUrl, // Utilisez l'URL de téléchargement de l'image
    };

    await FirebaseFirestore.instance.collection("activite").add(data);

    clearFields();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Activité enregistrée avec succès'),
      duration: Duration(seconds: 2),
    ));
  } catch (e) {
    print("Error during file upload: $e");
    // Gérez l'erreur de manière appropriée (affichez un message à l'utilisateur, enregistrez l'erreur, etc.)
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une activité"),
        backgroundColor: const Color.fromRGBO(85, 105, 254, 1.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              if (_image != null)
                Image.file(
                  File(_image!.path),
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                )
              else
                const Text('No image selected'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image from Gallery'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: titre,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Titre de l'activité",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lieu,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Lieu",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Prix",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nbr_minimal,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nombre minimal de participants",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cate,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Catégorie",
                    enabled: false),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
               onPressed: () async {
    try {
      // Conversion des champs numériques
      int prix = int.parse(price.text);
      int nbrMin = int.parse(nbr_minimal.text);

      await _uploadFile();

      // ... (Votre code existant)
    } catch (e) {
      print("Error adding activity: $e");
    }
  },
                child: const Text("Ajouter un événement"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

