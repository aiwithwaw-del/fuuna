import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/firebase_service.dart';
import 'app.dart';

void main() async {
  await FirebaseService.initialize();
  
  runApp(
    const ProviderScope(
      child: FuunaApp(),
    ),
  );
}