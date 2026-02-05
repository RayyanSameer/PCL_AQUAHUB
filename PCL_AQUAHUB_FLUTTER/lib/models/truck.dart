class Truck {
  final String id;
  final String truckName;
  final int capacityLiters;
  final bool isDispatched;
  final double totalEarnings;

  Truck({required this.id, required this.truckName, required this.capacityLiters, required this.isDispatched, required this.totalEarnings});

  factory Truck.fromJson(Map<String, dynamic> json) {
    return Truck(
      id: json['id']?.toString() ?? '',
      truckName: json['truck_name']?.toString() ?? json['truckName']?.toString() ?? '',
      capacityLiters: json['capacity_liters'] != null ? int.tryParse(json['capacity_liters'].toString()) ?? 0 : 0,
      isDispatched: json['is_dispatched'] == true || json['is_dispatched']?.toString() == 'true',
      totalEarnings: json['total_earnings'] != null ? double.tryParse(json['total_earnings'].toString()) ?? 0.0 : 0.0,
    );
  }
}
