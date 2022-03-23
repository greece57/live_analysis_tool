import 'package:supabase_flutter/supabase_flutter.dart';

class Project {
  Project(this.tournament, this.round, this.home, this.guest, this.createdAt,
      this.updatedAt);
  Project.draft(this.tournament, this.round, this.home, this.guest);

  String tournament;
  String round;
  String home;
  String guest;
  DateTime? createdAt;
  DateTime? updatedAt;

  Project.fromJson(Map<String, dynamic> json)
      : tournament = json['tournament'],
        round = json['round'],
        home = json['home'],
        guest = json['guest'],
        createdAt = DateTime.tryParse(json['created_at'] ?? ""),
        updatedAt = DateTime.tryParse(json['updated_at'] ?? "");

  Map<String, dynamic> toJson(User? user) {
    return {
      'tournament': tournament,
      'round': round,
      'home': home,
      'guest': guest,
      'updated_at': updatedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'user_id': user?.id
    };
  }
}
