import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class Portfolio extends StatefulWidget {
  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  double balance = 0.0;
  double profit = 0.0;
  int assets = 0;
  int profitPercentage = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://api-cryptiva.azure-api.net/staging/api/v1/accounts/portfolio'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> portfolioData = data['data']['portfolio'];

      setState(() {
        balance = portfolioData['balance'];
        profit = portfolioData['profit'];
        assets = portfolioData['assets'];
        profitPercentage = portfolioData['profit_percentage'];
      });
    } else {
      throw Exception('Failed to load portfolio data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final mobile = screenWidth < 650;

    return Container(
      width: 1324,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF111115),
        border: Border.all(color: const Color(0xFF3E3F48), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          _buildTopSection(context, mobile),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, bool mobile) {
    return Container(
      height: mobile ? 200 : 120,
      decoration: BoxDecoration(
        color: Color(0xff111115),
        border: Border(
          bottom:
              BorderSide(color: Color.fromARGB(255, 228, 238, 161), width: 1),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: mobile
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAmountColumn(mobile, '\$$balance'),
                  _buildHorizontalDivider(),
                  _buildProfitIndicator(
                      mobile, '\$$profit', '$profitPercentage%'),
                  _buildHorizontalDivider(),
                  _buildAmountColumn(mobile, '$assets', info: 'Assets'),
                ],
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: _buildAmountColumn(mobile, '\$$balance'),
                ),
                _buildVerticalDivider(),
                Flexible(
                  child: _buildProfitIndicator(
                      mobile, '\$$profit', '$profitPercentage%'),
                ),
                _buildVerticalDivider(),
                Flexible(
                  child: _buildAmountColumn(mobile, '$assets', info: 'Assets'),
                ),
              ],
            ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 80,
      width: 1,
      color: const Color(0xFF3E3F48),
    );
  }

  Widget _buildHorizontalDivider() {
    return Container(
      height: 1,
      width: 80,
      color: const Color(0xFF3E3F48),
    );
  }

  Widget _buildAmountColumn(bool mobile, String amount,
      {String info = "Balance"}) {
    return Column(
      crossAxisAlignment:
          mobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          info,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF4F4F5),
            height: 1.45,
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xffFFFFFF),
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildProfitIndicator(bool mobile, String amount, String percentage) {
    return Column(
      crossAxisAlignment:
          mobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Profits',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF4F4F5),
            height: 1.45,
          ),
        ),
        Row(
          crossAxisAlignment:
              mobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          mainAxisAlignment:
              mobile ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Text(
              amount,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xffFFFFFF),
                height: 1.45,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Container(
              width: 67,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF111115),
                border: Border.all(color: const Color(0xFF00AC3A), width: 1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/upwards_arrow.svg'),
                  SizedBox(width: 4),
                  Text(
                    percentage,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF00CA45),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildBottomSection() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Color(0xff111115),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          border: Border.all(
            color: const Color(0xFF3E3F48),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 32),
            Icon(
              Icons.warning,
              color: const Color(0xFFE7B500),
              size: 24,
            ),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'This subscription expires in a month',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFFF4F4F5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
