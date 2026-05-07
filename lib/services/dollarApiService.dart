import 'package:dio/dio.dart';

import 'dioClient.dart';

class DollarApiService {
  final Dio _dio = DioClient.getDio();
  Future<double> getDollarCourse() async {
    try {
      final response = await _dio.get(
        '/api/v1/average',
        options: Options(
          headers: {
            'Authorization':
                "Bearer e4tDEM8q6o8VhfjnsGPcrJS4LnsUVu8heTeBVgk7e46b31ac",
          },
        ),
      );
      var rawValue = response.data['buy_usd'] ?? response.data['average_buy'];
      if (rawValue != null) {
        return double.tryParse(rawValue.toString()) ?? 0.0;
      } else {
        throw Exception("USD key not found in response");
      }
    } on DioException catch (e) {
      print("Network Error: ${e.message}");
      print("Status Code: ${e.response?.statusCode}");
      print("Error Data: ${e.response?.data}");
      rethrow;
    } catch (e) {
      print("Parsing Error: $e");
      rethrow;
    }
  }
}
