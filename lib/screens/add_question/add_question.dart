import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/question/question_bloc.dart';
import '../../model/category.dart';
import '../../model/question.dart';

class AddQuestion extends StatelessWidget {
  final Question? question;

  const AddQuestion({Key? key, this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CategoryBloc>(context).add(CategoryFetchRequest());

    final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
    int categoryId = -1;
    String? question, op1, op2, op3, op4;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create A Question"),
      ),
      body: SingleChildScrollView(
        reverse: true,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Form(
            key: globalKey,
            child: Column(
              children: [
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoadingState) {
                      return const CircularProgressIndicator();
                    } else if (state is CategoryErrorState) {
                      return Text('Error: ${state.error}');
                    } else if (state is CategoryLoadedState) {
                      return buildCategoryFormField(state.categories, (value) {
                        categoryId = value;
                      });
                    }
                    return Container();
                  },
                ),
                const SizedBox(height: 20),
                buildQuestionForm((value) {
                  question = value;
                }),
                const SizedBox(height: 20),
                BlocBuilder<QuestionBloc, QuestionState>(
                  builder: (context, questionState) {
                    return Column(
                      children: List.generate(4, (index) {
                        return buildOptionForm(context, index + 1, (value) {
                          switch (index + 1) {
                            case 1:
                              op1 = value;
                              break;
                            case 2:
                              op2 = value;
                              break;
                            case 3:
                              op3 = value;
                              break;
                            case 4:
                              op4 = value;
                              break;
                          }
                        });
                      }),
                    );
                  },
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  color: const Color(0xFFA3C1DA),
                  minWidth: double.infinity,
                  height: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    if (globalKey.currentState!.validate()) {
                      globalKey.currentState!.save();
                      final newQuestion = Question(
                        que: question!,
                        op1: op1!,
                        op2: op2!,
                        op3: op3!,
                        op4: op4!,
                        cId: categoryId,
                        createdAt: DateTime.now().millisecondsSinceEpoch,
                        ans: BlocProvider.of<QuestionBloc>(context)
                            .selectedOption,
                      );

                      BlocProvider.of<QuestionBloc>(context)
                          .add(AddQuestionEvent(newQuestion));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Submit the Question",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryFormField(
      List<Category> categoryList, Function(int) onChanged) {
    return DropdownButtonFormField<int>(
      value: null,
      iconEnabledColor: Colors.black45,
      validator: (value) => value == null ? 'Select a category' : null,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      items: categoryList.map<DropdownMenuItem<int>>((Category category) {
        return DropdownMenuItem<int>(
          value: category.id,
          child: Text(category.categoryName),
        );
      }).toList(),
      decoration: const InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildQuestionForm(Function(String) onSaved) {
    return TextFormField(
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Enter your question',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value!.isEmpty ? 'This field cannot be empty' : null,
      onSaved: (value) {
        if (value != null) {
          onSaved(value);
        }
      },
    );
  }

  Widget buildOptionForm(
      BuildContext context, int optionNumber, Function(String) onSaved) {
    final selectedOption =
        BlocProvider.of<QuestionBloc>(context).selectedOption;
    return Row(
      children: [
        Radio<int>(
          value: optionNumber,
          groupValue: selectedOption,
          onChanged: (int? value) {
            if (value != null) {
              BlocProvider.of<QuestionBloc>(context).add(
                UpdateSelectedOptionEvent(value),
              );
            }
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Option $optionNumber',
                border: const OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'This field cannot be empty' : null,
              onSaved: (value) {
                if (value != null) {
                  onSaved(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
