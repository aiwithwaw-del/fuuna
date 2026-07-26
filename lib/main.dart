import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuuna/services/firebase_service.dart';
import 'package:fuuna/app.dart';

void main() async {
  await FirebaseService.initialize();

  runApp(
    const ProviderScope(
      child: FuunaApp(),
    ),
  );
}