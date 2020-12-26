import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floor/dao/employee_dao.dart';
import 'package:flutter_floor/database/app_database.dart';
import 'package:flutter_floor/entity/employee.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database =
      await $FloorAppDatabase.databaseBuilder('floor_app.db').build();
  final dao = database.employeeDao;

  runApp(MyApp(dao: dao));
}

class MyApp extends StatelessWidget {
  final EmployeeDao dao;

  MyApp({this.dao});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', dao: dao),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.dao}) : super(key: key);
  final EmployeeDao dao;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final employee = Employee(
                    firstName: Faker().person.firstName(),
                    lastName: Faker().person.lastName(),
                    email: Faker().internet.email());
                await widget.dao.insertEmployee(employee);
                showSnackBar(scaffoldKey.currentState, "Add Success");
              }),
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () async {
                widget.dao.deleteAllEmployee();
                setState(() {
                  showSnackBar(scaffoldKey.currentState, "Clear Success");
                });
              })
        ],
      ),
      body: StreamBuilder(
        stream: widget.dao.getAllEmployee(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            var employees = snapshot.data as List<Employee>;
            return ListView.builder(
                itemCount: employees != null ? employees.length : 0,
                itemBuilder: (context, index) {
                  return Slidable(
                    child: ListTile(
                      title: Text(
                          "${employees[index].firstName} ${employees[index].lastName}"),
                      subtitle: Text("${employees[index].email}"),
                    ),
                    actionPane: SlidableDrawerActionPane(),
                    secondaryActions: [
                      IconSlideAction(
                        caption: "Update",
                        color: Colors.blue,
                        icon: Icons.update,
                        onTap: () async {
                          final employee = employees[index];
                          employee.firstName = Faker().person.firstName();
                          employee.lastName = Faker().person.lastName();
                          employee.email = Faker().internet.email();

                          await widget.dao.updateEmployee(employee);
                        },
                      ),
                      IconSlideAction(
                        caption: "Delete",
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () async {
                          final employee = employees[index];

                          await widget.dao.deleteEmployee(employee);
                        },
                      )
                    ],
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void showSnackBar(ScaffoldState currentState, String s) {
    final snackbar = SnackBar(content: Text(s));
    currentState.showSnackBar(snackbar);
  }
}
