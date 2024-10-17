import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/db_helper.dart';
import '../../model/question.dart';

part 'quiz_state.dart';

part 'quiz_event.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final DbHelper dbHelper = DbHelper();
  List<Question> questions = [];
  int correctAnswerCount = 0;

  QuizBloc() : super(QuizInitial()) {
    on<LoadQuizEvent>((event, emit) async {
      emit(QuizLoading());
      try {
        var lists = await dbHelper.getAllQuestion();
        lists.shuffle();
        questions = lists.sublist(0, min(5, lists.length));
        emit(QuizLoaded(
          questions: questions,
          currentQuestionIndex: 0,
          correctAnswerCount: 0,
          selectedAnswers: 0,
        ));
      } catch (e) {
        emit(QuizError("Failed to load questions"));
      }
    });

    on<ResetQuizEvent>((event, emit) {
      correctAnswerCount = 0; // Reset correct answer count
      emit(
          QuizInitial()); // Optionally, you can reset the state to QuizInitial or load new questions
    });

    on<UpdateSelectedOptionQuizEvent>((event, emit) {
      final currentState = state as QuizLoaded;
      emit(currentState.copyWith(selectedAnswers: event.selectedQuizOption));
    });

    on<AnswerQuizEvent>((event, emit) {
      if (state is QuizLoaded) {
        final currentState = state as QuizLoaded;

        if (currentState.questions[currentState.currentQuestionIndex].ans ==
            event.selectedAnswer) {
          correctAnswerCount++;
        }

        if (currentState.currentQuestionIndex <
            currentState.questions.length - 1) {
          emit(currentState.copyWith(
            currentQuestionIndex: currentState.currentQuestionIndex + 1,
            correctAnswerCount: correctAnswerCount,
            selectedAnswers: 0,
          ));
        } else {
          emit(
              QuizCompleted(correctAnswerCount, currentState.questions.length));
        }
      }
    });
  }
}

//
// class QuizBloc extends Bloc<QuizEvent, QuizState> {
//   final DbHelper dbHelper = DbHelper();
//   List<Question> questions = [];
//   int correctAnswerCount = 0;
//   int selectedOptionForQuiz = 0;
//
//   QuizBloc() : super(QuizInitial()) {
//     on<LoadQuizEvent>((event, emit) async {
//       emit(QuizLoading());
//       try {
//         var lists = await dbHelper.getAllQuestion();
//         lists.shuffle();
//         questions = lists.sublist(0, min(5, lists.length));
//         emit(QuizLoaded(
//           questions: questions,
//           currentQuestionIndex: 0,
//           correctAnswerCount: 0,
//           selectedAnswers: 0,
//         ));
//       } catch (e) {
//         emit(QuizError("Failed to load questions"));
//       }
//     });
//
//     on<UpdateSelectedOptionQuizEvent>((event, emit) {
//       selectedOptionForQuiz = event.selectedQuizOption;
//       emit(QuizOptionUpdatedState(selectedOptionForQuiz));
//     });
//
//     on<AnswerQuizEvent>((event, emit) {
//       if (state is QuizLoaded) {
//         final currentState = state as QuizLoaded;
//
//         if (currentState.questions[currentState.currentQuestionIndex].ans == event.selectedAnswer) {
//           correctAnswerCount++;
//         }
//
//         if (currentState.currentQuestionIndex < currentState.questions.length - 1) {
//           emit(QuizLoaded(
//             questions: currentState.questions,
//             currentQuestionIndex: currentState.currentQuestionIndex + 1,
//             correctAnswerCount: correctAnswerCount,
//             selectedAnswers: 0,
//           ));
//         } else {
//           emit(QuizCompleted(correctAnswerCount, currentState.questions.length));
//           correctAnswerCount = 0; // Reset for next quiz
//         }
//       }
//     });
//   }
// }
