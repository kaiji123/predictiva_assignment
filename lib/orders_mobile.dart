import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MobileOrders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<MobileOrders> {
  late PageController _pageController;
  List<Widget> _rows = [];
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
          _rows = orders.map<Widget>((order) {
            DateFormat dateFormat = DateFormat('dd MMM, yyyy');
            String formattedDate = dateFormat.format(
                DateTime.fromMillisecondsSinceEpoch(
                    order['creation_time'] * 1000));
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order['symbol'],
                          style: TextStyle(color: Colors.white)),
                      Text(
                        '${order['price']}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 255, 255, 255),
                          height: 1.45, // 23.2px / 16px = 1.457
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      order['side'] == 'SELL'
                          ? TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                primary: Color(
                                    0xFF3E3F48), // Button background color
                                padding: EdgeInsets.zero, // Remove padding
                              ),
                              child: SvgPicture.asset('assets/sell.svg'),
                            )
                          : Text('BUY', style: TextStyle(color: Colors.white)),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFFB1B1B8),
                          height: 1.45, // 23.2px / 16px = 1.457
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  List<Widget> _getDataRows(int pageIndex) {
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
        // For screen widths less than or equal to 650px
        return _buildMobileLayout();
      },
    );
  }

  Widget _buildMobileLayout() {
    // Customize desktop layout here
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
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
                          child: Column(
                            children: _getDataRows(index),
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
