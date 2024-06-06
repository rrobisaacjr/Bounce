// package imports
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// file imports

const double borderRadius = 25.0;

class EditTaskModal extends StatefulWidget {
  final String originalTitle;
  final String originalDescription;
  final Timestamp? originalDeadline;

  EditTaskModal({
    required this.originalTitle,
    required this.originalDescription,
    required this.originalDeadline,
  });

  @override
  _EditTaskModalState createState() => _EditTaskModalState();
}

class _EditTaskModalState extends State<EditTaskModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.originalTitle;
    _descriptionController.text = widget.originalDescription;
    _deadlineController.text = widget.originalDeadline != null
        ? DateFormat('yyyy-MM-dd').format(widget.originalDeadline!.toDate())
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Card(
      color: Colors.black87,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(children: [
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            Card(
              child: SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Edit task',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Icon(
                                        Icons.title_rounded,
                                      )),
                                  hintStyle:
                                      const TextStyle(color: Colors.black54),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a title.';
                                }
                                return null;
                              },
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: _descriptionController,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 60),
                                      child: Icon(
                                        Icons.subtitles_rounded,
                                      )),
                                  hintStyle:
                                      const TextStyle(color: Colors.black54),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a description.';
                                }
                                return null;
                              },
                            )),
                        InkWell(
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: widget.originalDeadline!.toDate(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (selectedDate != null) {
                                _deadlineController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(selectedDate);
                              }
                            },
                            child: IgnorePointer(
                                child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: _deadlineController,
                                decoration: InputDecoration(
                                    isDense: true,
                                    prefixIcon: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Icon(
                                          Icons.access_alarm_rounded,
                                        )),
                                    hintStyle:
                                        const TextStyle(color: Colors.black54),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please set a deadline.';
                                  }
                                  return null;
                                },
                              ),
                            ))),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: TextButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 198, 255, 27)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.of(context).pop({
                                    'title': _titleController.text,
                                    'description': _descriptionController.text,
                                    'deadline': _deadlineController.text,
                                  });
                                }
                              },
                              child: const SizedBox(
                                  height: 40,
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(
                                          Icons.edit_rounded,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text('Edit Task',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 20,
                                              )))
                                    ],
                                  ))),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ])),
    )));
  }
}
