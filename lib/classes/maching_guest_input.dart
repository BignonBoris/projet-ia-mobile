class MachingGuestInput {
  final String? guest_id;
  final String? guest_resume;
  final int? compatibility_score;
  final String? reason;
  final String? advice;
  final String? status;

  // Constructeur pour initialiser les propriétés.
  MachingGuestInput({
    this.guest_id,
    this.guest_resume,
    this.compatibility_score,
    this.reason,
    this.advice,
    this.status,
  });

  // Add the toJson() method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'guest_id': guest_id ?? "",
      'guest_resume': guest_resume ?? "",
      'compatibility_score': compatibility_score ?? 0,
      'reason': reason ?? "",
      'advice': advice ?? "",
      'status': status ?? "",
    };

    return data;
  }
}
