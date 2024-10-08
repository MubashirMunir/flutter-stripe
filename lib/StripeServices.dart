import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stripe/Key/keys.dart';

class Stripeservices {
  static createPymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((int.parse(amount) * 100)).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var secretKey = Keys.secretKey;
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
  }
}
