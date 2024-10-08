import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe/StripeServices.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? paymentintent;
  Stripeservices stripeservices = Stripeservices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    makePayment();
                  },
                  child: Text('Pay'))
            ],
          ),
        ));
  }

  Future<void> makePayment() async {
    try {
      // Create the payment intent
      final paymentIntent =
          await Stripeservices.createPymentIntent('1000', 'PKR');

      if (paymentIntent == null ||
          !paymentIntent.containsKey('client_secret')) {
        print('Invalid payment intent response: $paymentIntent');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid payment intent response')));
      }

      // Initialize the payment sheet
      try {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            merchantDisplayName: 'Mubashir Munir',
            paymentIntentClientSecret:
                paymentIntent['client_secret'], // Correct key
            googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: 'US',
              currencyCode: 'USD',
              testEnv: true,
              label: 'Mubashir Munir',
            ),
          ),
        );
      } catch (initError) {
        print('Error initializing payment sheet: $initError');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to initialize payment sheet')));
      }

      // Display the payment sheet
      displayPaymentSheet();
    } catch (e) {
      print('Error during payment process: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Paid successfully')));
    } catch (e) {
      print('Error presenting payment sheet: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }
}
