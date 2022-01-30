import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'models/Todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _todo = "";
  final _formKey = GlobalKey<FormState>();
  late SharedPreferences sp;
  List<Todo> _todos = [];

  @override
  void initState() {
    //@ Fetch all the todos from shared preferences
    spInitialization();
    super.initState();
  }

  spInitialization() async {
    sp = await SharedPreferences.getInstance();
    var response = await sp.getString('todos');
    var decoded = json.decode(response!).map<Todo>((todo) => Todo.fromJson(todo)).toList();
    setState(() {
      _todos = decoded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text("DO IT, YES YOU CAN"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: Checkbox(
                    activeColor: Colors.green,
                    value: _todos[index].completed,
                    onChanged: (val) async {
                      setState(() {
                        _todos[index].completed = val!;
                      });
                      var res = json.encode(_todos.map((todo) => Todo.toMap(todo)).toList());
                      await sp.setString('todos', res);
                    }),
                title: Text(
                  _todos[index].title,
                  style: TextStyle(
                      fontSize: 20,
                      color: _todos[index].completed
                          ? Colors.grey.shade700
                          : Colors.white,
                      decoration: _todos[index].completed
                          ? TextDecoration.lineThrough
                          : null),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.shade900,
                  ),
                  onPressed: () async {
                    setState(() {
                      _todos.removeAt(index);
                    });
                    var res = json.encode(_todos.map((todo) => Todo.toMap(todo)).toList());
                    await sp.setString('todos', res);
                  },
                ),
              ),
              Divider(
                height: 10,
                color: Colors.green,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: Colors.grey.shade900,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Add New Todo",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                child: TextFormField(
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return "Enter a todo";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.task,
                                      color: Colors.green.shade900,
                                    ),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    hintText: "Enter a Todo",
                                    filled: true,
                                    fillColor: Colors.green[200],
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none),
                                  ),
                                  autofocus: true,
                                  onChanged: (val) {
                                    _todo = val;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()){
                                          setState(() {
                                            _todos.add(Todo(
                                                title: _todo,
                                                completed: false));
                                          });
                                          var res = json.encode(_todos.map((todo) => Todo.toMap(todo)).toList());
                                          await sp.setString('todos', res);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text("Add")),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel"),
                                  )
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
