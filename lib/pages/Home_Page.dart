// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mysql_flask_crud/api/student_api.dart';
import 'package:mysql_flask_crud/model/student_model.dart';
import 'package:mysql_flask_crud/pages/Add_Page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  late Future<List<Student>> futureStudents;

  @override
  void initState() {
    super.initState();
    futureStudents = apiService.getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD WITH PYTHON MYSQL"),
      ),
      body: FutureBuilder(
        future: futureStudents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No Data Students"));
          } else {
            // maksud dari code ini adalah ketika hasil dari snapshot tersebut tidak ada data, defaultnya adalah sebuah list kosong, jika tidak akan mengembalikan data dari snapshot tersebut
            final students = snapshot.data ?? [];
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index) {
                final studentIndex = students[index];
                return ListTile(
                  title: Text(studentIndex.name),
                  subtitle: Text(studentIndex.address),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentFormPage(
                                    student: studentIndex,
                                    onSave: (updatestudents) {
                                setState(() {
                                  futureStudents = apiService.getStudents();
                                });
                              }),
                            ),
                          );
                          if (updated) {
                            setState(() {
                              futureStudents = apiService.getStudents();
                            });
                          }
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                          onPressed: () async {
                            await apiService.deleteStudent(studentIndex.id!);
                            setState(() {
                              futureStudents = apiService.getStudents();
                            });
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentFormPage(
                onSave: (newStudent) {
                  setState(() {
                    futureStudents = apiService.getStudents();
                  });
                },
              ),
            ),
          );
          if (added) {
            setState(() {
              futureStudents = apiService.getStudents();
            });
          }
        },
      ),
    );
  }
}
