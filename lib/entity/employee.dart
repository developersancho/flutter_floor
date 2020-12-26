
import 'package:floor/floor.dart';

@entity
class Employee {
  @PrimaryKey(autoGenerate: true)
  final int id;

  String firstName, lastName, email;

  Employee({this.id, this.firstName, this.lastName, this.email});
}