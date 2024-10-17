part of 'quiz_bloc.dart';

sealed class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int correctAnswerCount;
  final int selectedAnswers;

  QuizLoaded({
    required this.questions,
    required this.currentQuestionIndex,
    required this.correctAnswerCount,
    required this.selectedAnswers,
  });

  QuizLoaded copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    int? correctAnswerCount,
    int? selectedAnswers,
  }) {
    return QuizLoaded(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      correctAnswerCount: correctAnswerCount ?? this.correctAnswerCount,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }
}

class QuizError extends QuizState {
  final String message;

  QuizError(this.message);
}

class QuizCompleted extends QuizState {
  final int correctAnswerCount;
  final int totalQuestions;

  QuizCompleted(this.correctAnswerCount, this.totalQuestions);
}