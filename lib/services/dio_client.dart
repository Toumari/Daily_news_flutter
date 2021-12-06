import 'package:dio/dio.dart';
import 'package:news_app/services/news_api.dart';
import 'crypto_api.dart';

class DioClient {
  final Dio _dio = Dio();

  final api_key = "";
  final _newsUrl = "https://api2.binance.com/api/v3/ticker/24hr";
  final _newsUrl2 =
      "https://newsapi.org/v2/everything?q=tesla&from=2021-11-06&sortBy=publishedAt&apiKey={api_key}";

  Future<List<String>> getBitCoinValue() async {
    try {
      Response response = await _dio.get(_newsUrl);

      var returned = <String>[];
      for (int i = 0; i <= 200; i++) {
        BitcoinTracker bitcoinFact = BitcoinTracker.fromJson(response.data[i]);

        String symbol = bitcoinFact.symbol;
        String askPrice = bitcoinFact.askPrice;

        returned.add("${bitcoinFact.symbol} : ${bitcoinFact.askPrice}");
      }
      ;
      return returned;
    } on DioError catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Article>> getNews() async {
    try {
      Response response = await _dio.get(_newsUrl2);
      NewsApi newsApi = NewsApi.fromJson(response.data);
      return newsApi.articles;
    } on DioError catch (e) {
      print(e);
      return e.error;
    }
  }
}
