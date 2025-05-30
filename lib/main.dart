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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          secondary: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const TempConverter(),
    );
  }
}

class TempConverter extends StatefulWidget {
  const TempConverter({super.key});

  @override
  State<TempConverter> createState() => _TempConverterState();
}

class _TempConverterState extends State<TempConverter> {
  final tempInput = TextEditingController();
  bool isConvertingFromF = true;
  List<PastConversion> conversions = [];

  void convertTemp() {
    if (tempInput.text.isEmpty) return;

    try {
      final startTemp = double.parse(tempInput.text);
      double endTemp;
      
      if (isConvertingFromF) {
        // F to C formula: (F - 32) × 5/9
        endTemp = (startTemp - 32) * 5 / 9;
        
      } else {
        // C to F formula: (C × 9/5) + 32
        endTemp = (startTemp * 9 / 5) + 32;
      }

      setState(() {
        conversions.insert(
            0,
            PastConversion(
              before: startTemp,
              after: endTemp,
              startedWithF: isConvertingFromF,
        ));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    tempInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'T.C App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Convert Temperature!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Fahrenheit to Celsius'),
                            value: true,
                            groupValue: isConvertingFromF,
                            onChanged: (value) =>
                                setState(() => isConvertingFromF = value!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Celsius to Fahrenheit'),
                            value: false,
                            groupValue: isConvertingFromF,
                            onChanged: (value) =>
                                setState(() => isConvertingFromF = value!),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: tempInput,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText:
                            'Enter the degrees in ${isConvertingFromF ? 'Fahrenheit' : 'Celsius'}',
                        border: const OutlineInputBorder(),
                        filled: true,
                        prefixIcon: const Icon(Icons.thermostat),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: convertTemp,
                      icon: const Icon(Icons.autorenew),
                      label: const Text('Convert!'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.history, size: 24),
                const SizedBox(width: 8),
                Text(
                  'History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: ListView.builder(
                  itemCount: conversions.length,
                  itemBuilder: (context, index) {
                    final conversion = conversions[index];
                    return ListTile(
                      title: Text(
                        '${conversion.before.toStringAsFixed(1)}° ${conversion.startedWithF ? 'F' : 'C'} = '
                        '${conversion.after.toStringAsFixed(1)}° ${conversion.startedWithF ? 'C' : 'F'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      leading: Icon(
                        Icons.swap_horiz,
                        color: Theme.of(context).colorScheme.secondary,
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

class PastConversion {
  final double before;
  final double after;
  final bool startedWithF;

  PastConversion({
    required this.before,
    required this.after,
    required this.startedWithF,
  });
}
