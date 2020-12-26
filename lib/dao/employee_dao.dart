import 'package:floor/floor.dart';
import 'package:flutter_floor/entity/employee.dart';

@dao
abstract class EmployeeDao {
  @Query('Select * from Employee')
  Stream<List<Employee>> getAllEmployee();

  @Query('Select * from Employee Where id=:id')
  Stream<Employee> getAllEmployeeById(int id);

  @Query("Delete from Employee")
  Future<void> deleteAllEmployee();

  @insert
  Future<void> insertEmployee(Employee employee);

  @update
  Future<void> updateEmployee(Employee employee);

  @delete
  Future<void> deleteEmployee(Employee employee);
}
