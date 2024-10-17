import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/question.dart';
import '../../bloc/question/question_bloc.dart';

class ReadQuestionView extends StatelessWidget {
  final int id;
  final String name;

  const ReadQuestionView(this.id, this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    context.read<QuestionBloc>().add(FetchQuestions(id)); // Fetch questions

    return Scaffold(
      appBar: AppBar(
        title: Text('Questions of $name'),
      ),
      body: BlocBuilder<QuestionBloc, QuestionState>(
        builder: (context, state) {
          if (state is QuestionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuestionError) {
            return Center(child: Text("Error: ${state.error}"));
          } else if (state is QuestionLoaded) {
            List<Question> questions = state.questions;

            return Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  Question question = questions[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Card(
                      color: const Color(0xFFA3C1DA),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            leading: Text('${index + 1}.',
                                style: const TextStyle(fontSize: 20)),
                            title: Text(question.que,
                                style: const TextStyle(fontSize: 20)),
                            trailing: IconButton(
                              onPressed: () {
                                showAlertDialog(question, context);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                          ListTile(
                            leading: Radio(
                              value: 1,
                              groupValue: question.ans,
                              onChanged: (value) {},
                            ),
                            title: Text(question.op1),
                          ),
                          ListTile(
                            leading: Radio(
                              value: 2,
                              groupValue: question.ans,
                              onChanged: (value) {},
                            ),
                            title: Text(question.op2),
                          ),
                          ListTile(
                            leading: Radio(
                              value: 3,
                              groupValue: question.ans,
                              onChanged: (value) {},
                            ),
                            title: Text(question.op3),
                          ),
                          ListTile(
                            leading: Radio(
                              value: 4,
                              groupValue: question.ans,
                              onChanged: (value) {},
                            ),
                            title: Text(question.op4),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(child: Text("No questions found."));
        },
      ),
    );
  }

  Future<void> showAlertDialog(Question question, BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert'),
        content: const Text('Are you sure you want to Delete this question?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<QuestionBloc>()
                  .add(DeleteQuestion(question)); // Delete question
              Navigator.pop(context, false);
            },
            child: const Text('Yes'),
          )
        ],
      ),
    );
  }
}
