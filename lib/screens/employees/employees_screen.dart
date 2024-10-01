import 'package:e_track/models/employee.dart';
import 'package:e_track/screens/add_employee/add_employee_screen.dart';
import 'package:e_track/screens/common/edittext.dart';
import 'package:e_track/screens/employees/employee_controller.dart';
import 'package:e_track/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../add_employee/add_employee_controller.dart';
import '../common/populate_row_item.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final controller = Get.put(EmployeeController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToCreation();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text(
          "Employees",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: colorBlack),
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.searchEnable.toggle();
                controller.searchTextController.clear();
                controller.dateUsers.value = controller.apiData;
              },
              icon: const Icon(Icons.search))
        ],
        elevation: 0,
      ),
      body: SafeArea(
          child: Obx(
        () => Column(
          children: [
            controller.searchEnable.value
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Card(
                        elevation: 5,
                        child: EditText(
                            hint: "Type here to search (Username, Name, Email, Mobile)",
                            onChange: (value) {
                              controller.onChangeListener();
                            },
                            label: null,
                            controller: controller.searchTextController)))
                : const SizedBox(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchUsers();
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.dateUsers.length,
                  itemBuilder: (context, index) {
                    Employee employee = controller.dateUsers[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 1.0),
                      child: InkWell(
                        onTap: () {
                          navigateToCreation(employeeId: employee.employeeId);
                        },
                        child: Card(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              PopulateRowItem(
                                label: 'Username:',
                                value:
                                employee.userName,
                              ),
                              PopulateRowItem(
                                label: 'Name:',
                                value:
                                    "${employee.firstName} ${employee.lastName}",
                              ),
                              PopulateRowItem(
                                label: 'Email:',
                                value: employee.email,
                              ),
                              PopulateRowItem(
                                label: 'Mobile:',
                                value: employee.mobile,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void navigateToCreation({String? employeeId}) {
    Get.delete<AddEmployeeController>();
    Get.to(() => AddEmployeeScreen(
          employeeId: employeeId,
        ))?.then((value) {
      if (value != null) {
        controller.fetchUsers();
      }
      return value;
    });
  }
}
