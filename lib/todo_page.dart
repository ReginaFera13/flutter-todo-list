import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // List containing text and isComplete values for each task
  List<Map<String, dynamic>> tasks = [];
  // Allows us to grab the value from the TextField when submitting via the icon button
  final TextEditingController textEditingController = TextEditingController();
  // Allows for focus control of the TextField
  final FocusNode textFieldFocusNode = FocusNode();

  // Sets the style of the TextField boarder for multi-setting use
  final border = OutlineInputBorder(
    borderSide: const BorderSide(
      width: 2.0,
      style: BorderStyle.solid,
      color: Colors.grey,
    ),
    borderRadius: BorderRadius.circular(25),
  );

  void addTask(String task) {
    developer.log('pressed');
    // Trims whitespace
    String trimmedTask = task.trim();

    // Checks if valid input (aka not empty)
    if (trimmedTask.isNotEmpty) {
      developer.log(trimmedTask);

      // Adds task to task list and sets completion to false
      setState(() {
        tasks.add({
          'text': task,
          'isComplete': false,
        });
      });

      // Clears the TextField
      textEditingController.clear();

      developer.log('$tasks');
      
      // Focuses the text field again so user doesn't have to click the TextField again to enter another task
      FocusScope.of(context).requestFocus(textFieldFocusNode);
    } else {
      developer.log('Task is Empty');
      // If empty, use the same add task method to close the keyboard
      FocusScope.of(context).unfocus();
    }
  }

  void removeTask(Map<String, dynamic> task) {
    developer.log('pressed');
    developer.log(task['text']);

    // Removes task from task list
    setState(() {
      tasks.remove(task);
    });

    developer.log('$tasks');
  }

  void completeTask(Map<String, dynamic> task) {
    developer.log('pressed');
    developer.log(task['text']);

    // Sets task completion to true for UI changes
    setState(() {
      task['isComplete'] = !task['isComplete'];
    });

    developer.log('$tasks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: GestureDetector( // Allows for phone guestures to be recognized
        onTap: () {
          FocusScope.of(context).unfocus(); // This dismisses the keyboard
        },
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'To Do',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                child: TextField(
                  focusNode: textFieldFocusNode, // Sets the focus to the TextField so that the onscreen keyboard opens
                  onSubmitted: addTask,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: 'Enter task',
                    filled: true,
                    fillColor: Colors.green.shade50,
                    focusedBorder: border,
                    enabledBorder: border,
                    suffixIcon: IconButton(
                      onPressed: () => addTask(textEditingController.text),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: tasks.map((task) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          task['text'],
                          style: TextStyle(
                            decoration: task['isComplete'] ? TextDecoration.lineThrough : null, // Line through if task is complete
                            color: task['isComplete'] ? Colors.grey : Colors.black, // Grey out if task is complete
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(
                            Icons.check,
                            color: task['isComplete'] ? Colors.green : Colors.grey, // Grey = incomplete; Green = complete
                          ),
                          onPressed: () => completeTask(task),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromARGB(255, 156, 91, 91),
                          ),
                          onPressed: () => removeTask(task),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
