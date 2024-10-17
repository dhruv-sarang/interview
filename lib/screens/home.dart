import 'package:flutter/material.dart';
import 'package:interview/screens/change_currency_rate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? fromCurrency;
  String? toCurrency;
  double amount = 0;
  double convertedAmount = 0;

  final Map<String, double> rates = {
    'USD': 1.0,
    'EUR': 0.85,
    'INR': 82.0,
    'JPY': 110.0,
  };

  late final List<String> currencies;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currencies = rates.keys.toList();
  }

  void convertCurrency() {
    setState(() {
      if (fromCurrency != null && toCurrency != null) {
        double fromRate = rates[fromCurrency]!;
        double toRate = rates[toCurrency]!;
        convertedAmount = (amount / fromRate) * toRate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                hint: const Text('From Currency'),
                value: fromCurrency,
                onChanged: (String? newValue) {
                  setState(() {
                    fromCurrency = newValue;
                    convertCurrency();
                  });
                },
                items: currencies.map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                hint: const Text('To Currency'),
                value: toCurrency,
                onChanged: (String? newValue) {
                  setState(() {
                    toCurrency = newValue;
                    convertCurrency();
                  });
                },
                items: currencies.map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: convertCurrency,
                child: const Text('Convert'),
              ),
              const SizedBox(height: 20),
              Text(
                'Converted Amount: ${convertedAmount.toStringAsFixed(2)} ${toCurrency ?? ''}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FilledButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeCurrencyRate(
                currencies: currencies,
                rates: rates,
              ),
            ),
          ),
          child: const Text('Change Currency Rate'),
        ),
      ),
    );
  }
}
