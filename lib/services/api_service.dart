import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vida/models/meal.dart';
import 'package:vida/models/menu.dart';
import 'package:vida/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL for the Go backend API
  static const String baseUrl = 'http://localhost:8080';
  
  // HTTP client for making requests
  final http.Client _client = http.Client();
  
  // Headers for API requests
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionToken = prefs.getString('session_token');
    
    return {
      'Content-Type': 'application/json',
      if (sessionToken != null) 'Authorization': 'Bearer $sessionToken',
    };
  }

  // Authentication methods
  Future<String> getGoogleAuthUrl() async {
    final response = await _client.get(Uri.parse('$baseUrl/auth/google'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get auth URL: ${response.statusCode}');
    }
  }

  Future<bool> processAuthCallback(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('session_token', data['token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log.e('Error processing auth callback: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(
        Uri.parse('$baseUrl/logout'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('session_token');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log.e('Error logging out: $e');
      return false;
    }
  }

  // Meal management methods
  Future<List<Meal>> getMeals() async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(
        Uri.parse('$baseUrl/meals'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((mealJson) => Meal.fromJson(mealJson)).toList();
      } else {
        throw Exception('Failed to load meals: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error getting meals: $e');
      throw Exception('Failed to load meals: $e');
    }
  }

  Future<Meal> getMeal(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(
        Uri.parse('$baseUrl/meals/$id'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Meal.fromJson(data);
      } else {
        throw Exception('Failed to load meal: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error getting meal: $e');
      throw Exception('Failed to load meal: $e');
    }
  }

  Future<Meal> createMeal(Meal meal) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$baseUrl/meals'),
        headers: headers,
        body: jsonEncode(meal.toJson()),
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Meal.fromJson(data);
      } else {
        throw Exception('Failed to create meal: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error creating meal: $e');
      throw Exception('Failed to create meal: $e');
    }
  }

  Future<Meal> updateMeal(Meal meal) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.put(
        Uri.parse('$baseUrl/meals/${meal.id}'),
        headers: headers,
        body: jsonEncode(meal.toJson()),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Meal.fromJson(data);
      } else {
        throw Exception('Failed to update meal: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error updating meal: $e');
      throw Exception('Failed to update meal: $e');
    }
  }

  Future<bool> deleteMeal(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.delete(
        Uri.parse('$baseUrl/meals/$id'),
        headers: headers,
      );
      
      return response.statusCode == 204;
    } catch (e) {
      log.e('Error deleting meal: $e');
      return false;
    }
  }

  // Menu management methods
  Future<List<Menu>> getMenus() async {
    try {
      final headers = await _getHeaders();
      final response = await _client.get(
        Uri.parse('$baseUrl/menus'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((menuJson) => Menu.fromJson(menuJson)).toList();
      } else {
        throw Exception('Failed to load menus: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error getting menus: $e');
      throw Exception('Failed to load menus: $e');
    }
  }

  Future<Menu> createMenu(Menu menu) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.post(
        Uri.parse('$baseUrl/menus'),
        headers: headers,
        body: jsonEncode(menu.toJson()),
      );
      
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Menu.fromJson(data);
      } else {
        throw Exception('Failed to create menu: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error creating menu: $e');
      throw Exception('Failed to create menu: $e');
    }
  }

  Future<Menu> updateMenu(Menu menu) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.put(
        Uri.parse('$baseUrl/menus/${menu.id}'),
        headers: headers,
        body: jsonEncode(menu.toJson()),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Menu.fromJson(data);
      } else {
        throw Exception('Failed to update menu: ${response.statusCode}');
      }
    } catch (e) {
      log.e('Error updating menu: $e');
      throw Exception('Failed to update menu: $e');
    }
  }

  Future<bool> deleteMenu(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await _client.delete(
        Uri.parse('$baseUrl/menus/$id'),
        headers: headers,
      );
      
      return response.statusCode == 204;
    } catch (e) {
      log.e('Error deleting menu: $e');
      return false;
    }
  }
}
