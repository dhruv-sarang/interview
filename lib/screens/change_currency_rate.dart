import 'package:flutter/material.dart';

class ChangeCurrencyRate extends StatefulWidget {
  const ChangeCurrencyRate({
    super.key,
    required this.rates,
    required this.currencies,
  });

  final List<String> currencies;
  final Map<String, double> rates;

  @override
  State<ChangeCurrencyRate> createState() => _ChangeCurrencyRateState();
}

class _ChangeCurrencyRateState extends State<ChangeCurrencyRate> {
  String? selectedCurrencyForRate;
  TextEditingController newRateController = TextEditingController();
  double newRate = 0;

  void updateRate() {
    if (selectedCurrencyForRate != null && newRate > 0) {
      newRateController.text = newRate.toString();
      setState(() {
        widget.rates[selectedCurrencyForRate!] = newRate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Currency Rate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<String>(
                hint: const Text('Select Currency for change Rate'),
                value: selectedCurrencyForRate,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCurrencyForRate = newValue;
                    newRateController.text =
                        widget.rates[selectedCurrencyForRate].toString();
                  });
                },
                items: widget.currencies.map((String currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: newRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'New Rate'),
                onChanged: (value) {
                  setState(() {
                    newRate = double.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateRate,
                child: const Text('Update Rate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
