import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: AccountOverview(),
    );
  }
}

class AccountOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Overview'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile Layout
            return MobileLayout();
          } else {
            // Tablet/Desktop Layout
            return TabletLayout();
          }
        },
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi Robin,',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Here is an overview of your account activities.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          AccountInfoCard(),
          SizedBox(height: 16),
          SubscriptionInfo(),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilterButton(),
            ],
          ),
          SizedBox(height: 16),
          Expanded(child: OpenTradesList()),
        ],
      ),
    );
  }
}

class TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi Robin,',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Here is an overview of your account activities.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                AccountInfoCard(),
                SizedBox(height: 16),
                SubscriptionInfo(),
                SizedBox(height: 16),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilterButton(),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(child: OpenTradesList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AccountInfoRow(label: 'Balance', value: '\$616.81'),
            Divider(color: Colors.grey),
            AccountInfoRow(
              label: 'Profits',
              value: '\$86.03',
              valueStyle: TextStyle(color: Colors.red),
              additionalWidget: Text(
                '8%',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Divider(color: Colors.grey),
            AccountInfoRow(label: 'Assets', value: '12'),
          ],
        ),
      ),
    );
  }
}

class AccountInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle valueStyle;
  final Widget additionalWidget;

  const AccountInfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.valueStyle = const TextStyle(),
    this.additionalWidget = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Row(
          children: [
            Text(value, style: valueStyle.copyWith(fontSize: 16)),
            SizedBox(width: 4),
            additionalWidget,
          ],
        ),
      ],
    );
  }
}

class SubscriptionInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.warning, color: Colors.yellow),
        SizedBox(width: 8),
        Text(
          'This subscription expires in a month',
          style: TextStyle(color: Colors.yellow),
        ),
      ],
    );
  }
}

class OpenTradesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // You can replace this with the actual number of trades
      itemBuilder: (context, index) {
        return OpenTradeCard();
      },
    );
  }
}

class OpenTradeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('MINAUSDT', style: TextStyle(color: Colors.white)),
            Text('Sell', style: TextStyle(color: Colors.red)),
          ],
        ),
        title: Text('1.5636', style: TextStyle(color: Colors.white)),
        subtitle: Text('19 Dec, 2023', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.black, // Background color
        onPrimary: Colors.white, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey), // Border color
        ),
      ),
      onPressed: () {
        // Add your filter functionality here
        showDialog(
          context: context,
          builder: (context) => FilterDialog(),
        );
      },
      icon: Icon(Icons.filter_list),
      label: Text('Filter'),
    );
  }
}

class FilterDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Trades'),
      content: Text('Filter options go here'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
