class VendorLoginResponse {
  final String vendorProfileId;
  final String userId;
  final String businessName;
  final String contactName;
  final String phone;
  final String email;

  VendorLoginResponse({required this.vendorProfileId, required this.userId, required this.businessName, required this.contactName, required this.phone, required this.email});

  factory VendorLoginResponse.fromJson(Map<String, dynamic> json) {
    return VendorLoginResponse(
      vendorProfileId: json['vendor_profile_id']?.toString() ?? json['vendor_profile_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      businessName: json['business_name']?.toString() ?? '',
      contactName: json['contact_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}
