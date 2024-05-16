import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
        scaffoldBackgroundColor: const Color(0xFF0D0D0F),
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
  late PageController _pageController;
  List<DataRow> _rows = [];
  final int _rowsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api-cryptiva.azure-api.net/staging/api/v1/orders/open'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> orders = data['data']['orders'];
        setState(() {
          _rows = orders.map<DataRow>((order) {
            DateFormat dateFormat = DateFormat('dd MMM, yyyy');
            String formattedDate = dateFormat.format(
                DateTime.fromMillisecondsSinceEpoch(
                    order['creation_time'] * 1000));
            return DataRow(cells: [
              DataCell(Text(order['symbol'])),
              DataCell(Text('${order['price']}')),
              DataCell(Text(order['type'])),
              order['side'] == 'SELL'
                  ? DataCell(
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          primary: Color(0xFF3E3F48), // Button background color
                          padding: EdgeInsets.zero, // Remove padding
                        ),
                        child: SvgPicture.asset('assets/sell.svg'),
                      ),
                    )
                  : DataCell(Text('BUY')),
              DataCell(Text(order['quantity'].toString())),
              DataCell(Text(formattedDate)),
            ]);
          }).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
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
        margin: const EdgeInsets.only(left: 52),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    primary: Color(0xFF3E3F48),
                    padding: EdgeInsets.zero,
                  ),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    child: SvgPicture.asset(
                      'assets/filter.svg',
                      width: 92,
                      height: 48,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: (_rows.length / _rowsPerPage).ceil(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SingleChildScrollView(
                        child: DataTable(
                          columns: const [
                            DataColumn(
                                label: Text('Symbol',
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text('Price',
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text('Type',
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text('Action',
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text('Quantity',
                                    style: TextStyle(color: Colors.white))),
                            DataColumn(
                                label: Text('Date',
                                    style: TextStyle(color: Colors.white))),
                          ],
                          rows: _getDataRows(index),
                        ),
                      ),
                      _buildPaginationButtons(index),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _getDataRows(int pageIndex) {
    int start = pageIndex * _rowsPerPage;
    int end = (pageIndex + 1) * _rowsPerPage;
    if (end > _rows.length) {
      end = _rows.length;
    }
    return _rows.sublist(start, end);
  }

  Widget _buildPaginationButtons(index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (_pageController.page! > 0) {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            }
          },
        ),
        Text('${index + 1}'),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            if (_pageController.page! < _rows.length / _rowsPerPage) {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            }
          },
        ),
      ],
    );
  }

  void _filterButtonPressed() {
    // Implement your filter logic here
    // For example, you can update the _rows list based on filters
  }
}
