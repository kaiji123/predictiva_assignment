import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor:
            const Color(0xFF0D0D0F), // Set scaffold background color to #0D0D0F
        textTheme: const TextTheme(
          bodyText2: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.3,
            color: Colors.white,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<DataRow> _rows = [
    DataRow(cells: [
      DataCell(const Text('AAPL')),
      DataCell(const Text('\$150.05')),
      DataCell(const Text('Buy')),
      DataCell(const Text('Execute')),
      DataCell(const Text('10')),
      DataCell(const Text('2024-05-16')),
    ]),
    DataRow(cells: [
      DataCell(const Text('GOOGL')),
      DataCell(const Text('\$2800.10')),
      DataCell(TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            primary: Color(0xFF3E3F48), // Button background color
            padding: EdgeInsets.zero, // Remove padding
          ),
          child: SvgPicture.asset(
            'assets/sell.svg',
          ))),
      DataCell(const Text('Cancel')),
      DataCell(const Text('5')),
      DataCell(const Text('2024-05-15')),
    ]),
    DataRow(cells: [
      DataCell(const Text('AMZN')),
      DataCell(const Text('\$3500.00')),
      DataCell(const Text('Buy')),
      DataCell(const Text('Execute')),
      DataCell(const Text('8')),
      DataCell(const Text('2024-05-14')),
    ]),
  ];

  void _filterButtonPressed() {
    // Implement your filter logic here
    // For example, you can update the _rows list based on filters
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Table with Filter'),
      ),
      body: Container(
        width: 1324,
        height: 647,
        margin: const EdgeInsets.only(top: 392, left: 52),
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: const Color(0xFF161619),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
          border: Border.all(
            color: const Color(0xFF3E3F48),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Open Trades',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                TextButton(
                  onPressed: _filterButtonPressed,
                  style: TextButton.styleFrom(
                    primary: Color(0xFF3E3F48), // Button background color
                    padding: EdgeInsets.zero, // Remove padding
                  ),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white, // Color you want to apply
                      BlendMode.srcIn, // Blend mode
                    ),
                    child: SvgPicture.asset(
                      'assets/filter.svg',
                      width: 92, // Adjust size as needed
                      height: 48,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: const Color(
                      0xFF161619), // Set background color for DataTable
                  child: DataTable(
                    columns: const [
                      DataColumn(
                          label: Text('Symbol',
                              style: TextStyle(
                                  color: Colors
                                      .white))), // Set text color to white
                      DataColumn(
                          label: Text('Price',
                              style: TextStyle(
                                  color: Colors
                                      .white))), // Set text color to white
                      DataColumn(
                          label: Text('Type',
                              style: TextStyle(
                                  color: Colors
                                      .white))), // Set text color to white
                      DataColumn(
                          label: Text('Action',
                              style: TextStyle(
                                  color: Colors
                                      .white))), // Set text color to white
                      DataColumn(
                          label: Text('Quantity',
                              style: TextStyle(
                                  color: Colors
                                      .white))), // Set text color to white
                      DataColumn(
                          label: Text('Date',
                              style: TextStyle(
                                  color: Colors
                                      .white))), // Set text color to white
                    ],
                    rows: _rows.map((DataRow row) {
                      return DataRow(
                        cells: row.cells,
                        color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08);
                            }
                            return null; // Use default row color
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
