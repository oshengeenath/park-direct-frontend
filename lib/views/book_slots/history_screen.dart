import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:park_direct_frontend/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

@@ -34,7 +35,7 @@ class _HistoryScreenState extends State<HistoryScreen> {
  Future<void> fetchHistoryData() async {
    await getUserData();
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/bookings/$userEmail'));
      if (response.statusCode == 200) {
        developer.log('body: ${response.body}');
        setState(() {