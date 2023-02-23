import 'package:clean_arch/data/http/http.dart';
import 'package:clean_arch/infra/http/http.dart';
import 'package:http/http.dart';

HttpClient makeHttpAdapter() {
  final client = Client();
  return HttpAdapter(client);
}
