/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

export 'src/basevenuewolf_sdk_base.dart';

// TODO: Export any libraries intended for clients of this package.
import 'dart:math';
import 'package:http/http.dart' as http;

class BasevenueWolfSDK {
  final String baseUrl;
  final String _apiKey;

  BasevenueWolfSDK({required this.baseUrl})
      : _apiKey = _generateDummyApiKey();

  // Dummy API key generator for the POC
  static String _generateDummyApiKey() {
    final random = Random();
    return 'bvw-${random.nextInt(1000000)}';
  }

  // Example method to get a user's main token balance
  Future<double> getUsersMainTokenBalance(String userId) async {
    final uri = Uri.parse('$baseUrl/getBalance?userId=$userId&apiKey=$_apiKey');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // For the POC, assume the response body is a number in string format
      return double.tryParse(response.body) ?? 0.0;
    } else {
      throw Exception('Error fetching token balance');
    }
  }

  // Example method to get the main token address
  Future<String> getMainTokenAddress() async {
    final uri = Uri.parse('$baseUrl/getMainTokenAddress?apiKey=$_apiKey');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error fetching token address');
    }
  }
}
