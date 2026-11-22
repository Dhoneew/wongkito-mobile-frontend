class Address {
  final String id;
  final String recipientName;
  final String phoneNumber;
  final String fullAddress;
  final String label;
  final bool isPrimary;

  const Address({
    required this.id,
    required this.recipientName,
    required this.phoneNumber,
    required this.fullAddress,
    required this.label,
    this.isPrimary = false,
  });

  Address copyWith({
    String? id,
    String? recipientName,
    String? phoneNumber,
    String? fullAddress,
    String? label,
    bool? isPrimary,
  }) {
    return Address(
      id: id ?? this.id,
      recipientName: recipientName ?? this.recipientName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullAddress: fullAddress ?? this.fullAddress,
      label: label ?? this.label,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }
}
