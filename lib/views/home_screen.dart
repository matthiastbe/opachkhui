import 'package:flutter/material.dart';
import 'add_appartment_page.dart';

class HomeScreen extends StatelessWidget {
  final String token;

  HomeScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Appartements'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddApartmentPage(token: token),
              ),
            );
          },
          child: Text('Ajouter un Appartement'),
        ),
      ),
    );
  }
}
