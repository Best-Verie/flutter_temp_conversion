import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T.C App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TemperatureConverterPage(),
    );
  }
}

class TemperatureConverterPage extends StatefulWidget {
  const TemperatureConverterPage({super.key});

  @override
  State<TemperatureConverterPage> createState() => _TemperatureConverterPageState();
}

class _TemperatureConverterPageState extends State<TemperatureConverterPage> {
  final TextEditingController _temperatureController = TextEditingController();
  bool _isFahrenheitToCelsius = true;
  List<ConversionHistory> _history = [];

  void _convert() {
    if (_temperatureController.text.isEmpty) return;

    try {
      final double inputTemp = double.parse(_temperatureController.text);
      double result;
      String conversionType;
      
      if (_isFahrenheitToCelsius) {
        result = (inputTemp - 32) * 5 / 9;
        conversionType = 'F to C';
      } else {
        result = (inputTemp * 9 / 5) + 32;
        conversionType = 'C to F';
      }

      setState(() {
        _history.insert(0, ConversionHistory(
          inputTemperature: inputTemp,
          outputTemperature: result,
          isFahrenheitToCelsius: _isFahrenheitToCelsius,
        ));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
    }
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('°F to °C'),
                            value: true,
                            groupValue: _isFahrenheitToCelsius,
                            onChanged: (bool? value) {
                              setState(() {
                                _isFahrenheitToCelsius = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('°C to °F'),
                            value: false,
                            groupValue: _isFahrenheitToCelsius,
                            onChanged: (bool? value) {
                              setState(() {
                                _isFahrenheitToCelsius = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _temperatureController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter temperature in ${_isFahrenheitToCelsius ? '°F' : '°C'}',
                        border: const OutlineInputBorder(),
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _convert,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Convert Temperature'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                elevation: 2,
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final conversion = _history[index];
                    return ListTile(
                      title: Text(
                        '${conversion.isFahrenheitToCelsius ? 'F to C' : 'C to F'}: '
                        '${conversion.inputTemperature.toStringAsFixed(1)} => '
                        '${conversion.outputTemperature.toStringAsFixed(2)}',
                      ),
                      leading: Icon(
                        Icons.history,
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConversionHistory {
  final double inputTemperature;
  final double outputTemperature;
  final bool isFahrenheitToCelsius;

  ConversionHistory({
    required this.inputTemperature,
    required this.outputTemperature,
    required this.isFahrenheitToCelsius,
  });
}
