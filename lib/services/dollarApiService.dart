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
                "Bearer LvNTShPFtVy4MyEhMZbWk8QCgh6QBrEr1OgXG1592106899d",
          },
        ),
      );
      return double.parse(response.data['buy_usd'].toString());
    } catch (e) {
      throw Exception("Failed to load currency: $e");
    }
  }
}
