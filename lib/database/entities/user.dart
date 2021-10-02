import 'package:djigibao_manager/database/entities/role.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final Role role;

  User({required this.name, required this.role});

  User.fromJson(Map<String, dynamic> json)
      : name = json["name"].toString(),
        role = roleFromValue(json["role"].toString());

  Map<String, dynamic> toJson() => {"name": name, "role": roleToValue(role)};
}
