import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vendor_dashboard_provider.dart';

class VendorDashboardScreen extends StatefulWidget {
  final String vendorProfileId;
  const VendorDashboardScreen({Key? key, required this.vendorProfileId}) : super(key: key);

  @override
  _VendorDashboardScreenState createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // fetch dashboard data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VendorDashboardProvider>(context, listen: false).fetchAll(widget.vendorProfileId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dash = Provider.of<VendorDashboardProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: dash.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Orders (${dash.orders.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dash.orders.length,
                      itemBuilder: (_, i) {
                        final o = dash.orders[i];
                        return ListTile(
                          title: Text(o.orderType),
                          subtitle: Text('Client: ${o.firstName ?? ''} ${o.lastName ?? ''} - ${o.phone ?? ''}'),
                          trailing: Text(o.status),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Trucks (${dash.trucks.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dash.trucks.length,
                      itemBuilder: (_, i) {
                        final t = dash.trucks[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(t.truckName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('${t.capacityLiters} L'),
                                Text(t.isDispatched ? 'Dispatched' : 'Idle'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
