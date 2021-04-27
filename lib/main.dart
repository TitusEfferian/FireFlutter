// dont forget to setup the fireflutter config
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error initialize firebase'));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return CupertinoApp(home: HomePage());
        }
        return Center(child: Text('loading initiaal'));
      },
      future: _initialization,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference places =
        FirebaseFirestore.instance.collection('places');

    return FutureBuilder<QuerySnapshot>(
      future: places.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Something went wrong");
        }

        if (snapshot.hasData && snapshot.data.size == 0) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Map<String, dynamic> data = snapshot.data.data();
          // snapshot.data.docs.forEach((element) { print(element["place_name"]);});
          snapshot.data.docs
              .forEach((QueryDocumentSnapshot queryDocumentSnapshot) {
            print(queryDocumentSnapshot.data());
          });
          return CupertinoPageScaffold(
              child: Center(
                child: Text('testing'),
              ),
              navigationBar: CupertinoNavigationBar(
                middle: Text("testing"),
              ));
        }

        return Text("loading");
      },
    );
  }
}

class SecondRoute extends StatelessWidget {
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('second route'),
      ),
      child: Center(
        child: CupertinoButton(
          child: Text('go to first route'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
