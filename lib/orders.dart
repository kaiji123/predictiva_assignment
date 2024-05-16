import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:predictiva/orders_mobile.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
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

  List<DataRow> _getDataRows(int pageIndex) {
    int start = pageIndex * _rowsPerPage;
    int end = (pageIndex + 1) * _rowsPerPage;
    if (end > _rows.length) {
      end = _rows.length;
    }
    return _rows.sublist(start, end);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 650) {
          // For screen widths less than or equal to 650px
          return _buildMobileLayout();
        } else {
          // For screen widths greater than 650px
          return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 103),
        decoration: BoxDecoration(
          color: const Color(0xFF161619),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            color: const Color(0xFF3E3F48),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Open Trades',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: _filterButtonPressed,
                    style: TextButton.styleFrom(
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
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: (_rows.length / _rowsPerPage).ceil(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
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

  Widget _buildMobileLayout() {
    // Customize desktop layout here
    return MobileOrders();
  }

  void _filterButtonPressed() {
    // Implement your filter logic here
    // For example, you can update the _rows list based on filters
  }

  Widget _buildPaginationButtons(int index) {
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
}
