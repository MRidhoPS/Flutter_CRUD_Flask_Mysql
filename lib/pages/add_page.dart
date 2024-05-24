// // ignore_for_file: library_private_types_in_public_api

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../api/student_api.dart';
import '../model/student_model.dart';

class StudentFormPage extends StatefulWidget {
  final Student? student;
  final Function(Student) onSave;

  const StudentFormPage({super.key, this.student, required this.onSave});

  @override
  _StudentFormPageState createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String address;
  late String city;
  late String pin;
  final ApiService apiService = ApiService();
  bool _isLoading = false; // To handle loading state

  @override
  void initState() {
    super.initState();
    name = widget.student?.name ?? '';
    address = widget.student?.address ?? '';
    city = widget.student?.city ?? '';
    pin = widget.student?.pin ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: address,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
                onSaved: (value) => address = value!,
              ),
              TextFormField(
                initialValue: city,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
                onSaved: (value) => city = value!,
              ),
              TextFormField(
                initialValue: pin,
                decoration: const InputDecoration(labelText: 'Pin'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pin';
                  }
                  return null;
                },
                onSaved: (value) => pin = value!,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _isLoading = true; // Set loading state
                          });

                          final student = Student(
                            id: widget.student?.id,
                            name: name,
                            address: address,
                            city: city,
                            pin: pin,
                          );

                          try {
                            if (widget.student != null &&
                                widget.student!.id != null) {
                              await apiService.updateStudents(
                                widget.student!.id!,
                                student,
                              );
                            } else {
                              await apiService.addStudents(student);
                            }
                            widget.onSave(student);
                            Navigator.pop(context, true);
                            // Return true to indicate success
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to add student')),
                            );
                          } finally {
                            setState(() {
                              _isLoading = false; // Reset loading state
                            });
                          }
                        }
                      },
                      child: const Text('Save'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
