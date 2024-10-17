import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/quiz/quiz_bloc.dart';
import '../../preference/pref_manager.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<QuizBloc>().add(LoadQuizEvent());
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Welcome ${PrefManager.getEmail().split('@gmail.com').first}'),
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is QuizError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is QuizLoaded) {
            return buildQuizScreen(context, state);
          } else if (state is QuizCompleted) {
            return showQuizResult(
                context, state.correctAnswerCount, state.totalQuestions);
          }
          return Container();
        },
      ),
    );
  }

  Widget buildQuizScreen(BuildContext context, QuizLoaded state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildQuestionInfo(state),
            const SizedBox(height: 20),
            buildQuestionDetail(state),
            const SizedBox(height: 20),
            buildAnswerOptions(context, state),
            const SizedBox(height: 20),
            buildActionButton(context, state),
          ],
        ),
      ),
    );
  }

  Widget buildQuestionInfo(QuizLoaded state) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFFA3C1DA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 2, color: Colors.grey.shade700),
      ),
      child: Center(
        child: Text(
          "${state.currentQuestionIndex + 1}/${state.questions.length} Questions",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildQuestionDetail(QuizLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question ${state.currentQuestionIndex + 1}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            state.questions[state.currentQuestionIndex].que,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget buildAnswerOptions(BuildContext context, QuizLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 1; i <= 4; i++)
          ListTile(
            leading: Radio(
              value: i,
              groupValue: state.selectedAnswers,
              onChanged: (value) {
                context.read<QuizBloc>().add(
                    UpdateSelectedOptionQuizEvent(selectedQuizOption: value!));
              },
            ),
            title:
                Text(state.questions[state.currentQuestionIndex].getOption(i)),
          ),
      ],
    );
  }

  Widget buildActionButton(BuildContext context, QuizLoaded state) {
    return ElevatedButton(
      onPressed: () {
        context
            .read<QuizBloc>()
            .add(AnswerQuizEvent(selectedAnswer: state.selectedAnswers));
      },
      child: const Text('Next'),
    );
  }

  Widget showQuizResult(
      BuildContext context, int correctAnswerCount, int totalQuestions) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Quiz Completed!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          'Your Correct Answers: $correctAnswerCount / $totalQuestions',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.read<QuizBloc>().add(ResetQuizEvent());
            context.read<QuizBloc>().add(LoadQuizEvent());
          },
          child: const Text('Retake Quiz'),
        ),
      ],
    );
  }
}
