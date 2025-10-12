class MachingGuestInput {
  final String guest_id;
  final String guest_resume;
  final int compatibility_score;
  final String reason;
  final String advice;

  // Constructeur pour initialiser les propriétés.
  MachingGuestInput({
    required this.guest_id,
    required this.guest_resume,
    required this.compatibility_score,
    required this.reason,
    required this.advice,
  });
}
